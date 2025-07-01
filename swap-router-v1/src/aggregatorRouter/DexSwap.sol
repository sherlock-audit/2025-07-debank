/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../library/Admin.sol";
import "../library/UniversalERC20.sol";
import "../library/SignedDecimalMath.sol";
import "./Spender.sol";

/**
 * @title DexSwap
 * @notice A DEX router supporting multiple aggregators with fee management
 * @dev Key features:
 * - Multi-aggregator support through adapter pattern
 * - Configurable fees on input/output tokens
 * - Support for both ERC20 and ETH swaps
 * - Admin controlled with pause mechanism
 * - Protected against reentrancy
 * - Slippage protection
 *
 * Flow: validate -> charge input fee (if any) -> swap -> 
 * verify slippage -> charge output fee (if any) -> transfer to user
 */
contract DexSwap is ReentrancyGuard, Admin {
    using SignedDecimalMath for uint256;
    using UniversalERC20 for IERC20;
    using SafeERC20 for IERC20;

    struct Adapter {
        address addr;
        bool isRegistered;
        bytes4 selector;
    }

    struct SwapParams {
        string aggregatorId;
        address fromToken;
        uint256 fromTokenAmount;
        address toToken;
        uint256 minAmountOut;
        uint256 feeRate;
        bool feeOnFromToken;
        address feeReceiver;
        bytes data;
    }

    uint256 public maxFeeRate;
    Spender public immutable spender;
    mapping(string aggregatorId => Adapter) public adapters;
    address[] public registeredAdapters;

    event AdapterSet(string indexed aggregatorId, address indexed addr, bytes4 selector);
    event AdapterRemoved(string indexed aggregatorId);
    event Swap(
        string indexed aggregatorId,
        address sender,
        address fromToken,
        uint256 fromTokenAmount,
        address toToken,
        uint256 toTokenAmount,
        uint256 fee
    );

    constructor(address[3] memory _admins, uint256 _maxFeeRate) Admin(_admins) {
        maxFeeRate = _maxFeeRate;
        spender = new Spender();
    }

    function getAdapters() external view returns (address[] memory) {
        return registeredAdapters;
    }

    function setAdapter(string calldata aggregatorId, address addr, bytes4 selector) external onlyAdmin {
        if (adapters[aggregatorId].isRegistered) revert RouterError.AdapterExists();
        if (addr == address(0)) revert RouterError.AdapterAddressZero();
        for (uint256 i = 0; i < registeredAdapters.length; i++) {
            if (registeredAdapters[i] == addr) revert RouterError.AdapterExists();
        }

        Adapter storage adapter = adapters[aggregatorId];
        adapter.addr = addr;
        adapter.selector = selector;
        adapter.isRegistered = true;
        registeredAdapters.push(addr);
        emit AdapterSet(aggregatorId, addr, selector);
    }

    function removeAdapter(string calldata aggregatorId) external onlyAdmin {
        if (!adapters[aggregatorId].isRegistered) revert RouterError.AdapterDoesNotExist();

        address addr = adapters[aggregatorId].addr;
        adapters[aggregatorId].isRegistered = false;
        adapters[aggregatorId].addr = address(0);
        adapters[aggregatorId].selector = bytes4(0);
        for (uint256 i = 0; i < registeredAdapters.length; i++) {
            if (registeredAdapters[i] == addr) {
                registeredAdapters[i] = registeredAdapters[registeredAdapters.length - 1];
                registeredAdapters.pop();
                break;
            }
        }
        emit AdapterRemoved(aggregatorId);
    }

    /**
     * @dev Performs a swap
     */
    function swap(SwapParams memory params) external payable whenNotPaused nonReentrant {
        _swap(params);
    }

    function _swap(SwapParams memory params) internal {
        Adapter storage adapter = adapters[params.aggregatorId];

        // 1. check params
        _validateSwapParams(params, adapter);

        uint256 feeAmount;
        uint256 receivedAmount;

        // 2. charge fee on fromToken if needed
        if (params.feeOnFromToken) {
            (params.fromTokenAmount, feeAmount) = _chargeFee(
                params.fromToken, params.feeOnFromToken, params.fromTokenAmount, params.feeRate, params.feeReceiver
            );
        }

        // 3. transfer fromToken
        if (params.fromToken != UniversalERC20.ETH) {
            IERC20(params.fromToken).safeTransferFrom(msg.sender, address(spender), params.fromTokenAmount);
        }

        // 4. execute swap
        {
            uint256 balanceBefore = IERC20(params.toToken).universalBalanceOf(address(this));
            spender.swap{value: params.fromToken == UniversalERC20.ETH ? params.fromTokenAmount : 0}(
                adapter.addr,
                abi.encodeWithSelector(
                    adapter.selector, params.fromToken, params.toToken, msg.sender, params.data
                )
            );
            receivedAmount = IERC20(params.toToken).universalBalanceOf(address(this)) - balanceBefore;
        }

        // 5. check slippage
        if (receivedAmount < params.minAmountOut) revert RouterError.SlippageLimitExceeded();

        // 6. charge fee on toToken if needed
        if (!params.feeOnFromToken) {
            (receivedAmount, feeAmount) =
                _chargeFee(params.toToken, params.feeOnFromToken, receivedAmount, params.feeRate, params.feeReceiver);
        }

        IERC20(params.toToken).universalTransfer(payable(msg.sender), receivedAmount);
        emit Swap(
            params.aggregatorId,
            msg.sender,
            address(params.fromToken),
            params.fromTokenAmount,
            address(params.toToken),
            receivedAmount,
            feeAmount
        );
    }

    function _validateSwapParams(SwapParams memory params, Adapter storage adapter) internal view {
        if (params.feeReceiver == address(this)) revert RouterError.IncorrectFeeReceiver();
        if (params.feeRate > maxFeeRate) revert RouterError.FeeRateTooBig();
        if (params.fromToken == params.toToken) revert RouterError.TokenPairInvalid();
        if (!adapter.isRegistered) revert RouterError.AdapterDoesNotExist();
        if (msg.value != (params.fromToken == UniversalERC20.ETH ? params.fromTokenAmount : 0)) {
            revert RouterError.IncorrectMsgValue();
        }
    }

    function _chargeFee(address token, bool feeOnFromToken, uint256 amount, uint256 feeRate, address feeReceiver)
        internal
        returns (uint256, uint256)
    {
        uint256 feeAmount = amount.decimalMul(feeRate);
        if (feeRate > 0) {
            if (feeOnFromToken) {
                IERC20(token).universalTransferFrom(msg.sender, payable(feeReceiver), feeAmount);
            } else {
                IERC20(token).universalTransfer(payable(feeReceiver), feeAmount);
            }
        }
        return (amount -= feeAmount, feeAmount);
    }

    /// @notice Receive ETH
    receive() external payable {}
}
