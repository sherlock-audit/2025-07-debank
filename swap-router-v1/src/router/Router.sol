    /*
        Copyright Debank
        SPDX-License-Identifier: BUSL-1.1*/

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "../library/Admin.sol";
import "../library/UniversalERC20.sol";
import "../library/SignedDecimalMath.sol";
import "../executor/Executor.sol";

/**
 * @title Router
 * @notice Main entry point for token swaps with fee management
 * @dev Key features:
 * - Manages swap execution through Executor contract
 * - Configurable fee system on input/output tokens
 * - Admin controlled adapter management
 * - Supports both ERC20 and ETH swaps
 * - Protected against reentrancy
 *
 * Flow: charge fee -> transfer to executor -> 
 * execute multi-path swaps -> verify slippage -> return tokens
 */
contract Router is Admin, ReentrancyGuard {
    using SignedDecimalMath for uint256;
    using SafeERC20 for IERC20;
    using UniversalERC20 for IERC20;

    uint256 public maxFeeRate;
    Executor public immutable executor;

    // =============== event =======================
    event Swap(
        address sender, address fromToken, uint256 fromTokenAmount, address toToken, uint256 toTokenAmount, uint256 fee
    );
    event UpdateAdapter(address indexed adapter, bool add);

    constructor(address[3] memory _admins, uint256 _maxFeeRate) Admin(_admins) {
        maxFeeRate = _maxFeeRate;
        executor = new Executor();
    }

    /// @notice Swap tokens using the executor
    /// @param fromToken The token to swap from
    /// @param fromTokenAmount The amount of fromToken to swap
    /// @param toToken The token to swap to
    /// @param minAmountOut The minimum amount of toToken to receive
    /// @param feeOnFromToken If the fee should be charged on fromToken
    /// @param feeRate The fee rate to charge, feeRate/10000 will be charged to the feeReceiver
    /// @param feeReceiver The address to receive the fee
    /// @param paths The paths to swap
    function swap(
        address fromToken,
        uint256 fromTokenAmount,
        address toToken,
        uint256 minAmountOut,
        bool feeOnFromToken,
        uint256 feeRate,
        address feeReceiver,
        Utils.MultiPath[] calldata paths
    ) external payable whenNotPaused nonReentrant {
        require(fromToken != toToken, "Router: fromToken and toToken cannot be the same");
        require(feeRate <= maxFeeRate, "Router: Fee Rate is too big");
        require(msg.value == (fromToken == UniversalERC20.ETH ? fromTokenAmount : 0), "Router: Incorrect msg.value");
        uint256 feeAmount;

        // charge fee
        if (feeOnFromToken) {
            (fromTokenAmount, feeAmount) = chargeFee(fromToken, feeOnFromToken, fromTokenAmount, feeRate, feeReceiver);
        }
        // deposit to executor
        if (fromToken != UniversalERC20.ETH) {
            IERC20(fromToken).safeTransferFrom(msg.sender, address(executor), fromTokenAmount);
        }

        uint256 balanceBefore = IERC20(toToken).universalBalanceOf(address(this));

        //execute swap，transfer token to executor
        executor.executeMegaSwap{value: fromToken == UniversalERC20.ETH ? fromTokenAmount : 0}(
            IERC20(fromToken), IERC20(toToken), paths
        );

        uint256 receivedAmount = IERC20(toToken).universalBalanceOf(address(this)) - balanceBefore;

        // charge fee
        if (!feeOnFromToken) {
            (receivedAmount, feeAmount) = chargeFee(toToken, feeOnFromToken, receivedAmount, feeRate, feeReceiver);
        }

        // check slippage
        require(receivedAmount >= minAmountOut, "Router: Slippage Limit Exceeded");

        // transfer out
        IERC20(toToken).universalTransfer(payable(msg.sender), receivedAmount);
        emit Swap(msg.sender, address(fromToken), fromTokenAmount, address(toToken), receivedAmount, feeAmount);
    }

    function chargeFee(address token, bool feeOnFromToken, uint256 amount, uint256 feeRate, address feeReceiver)
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

    function updateAdaptor(address _adapter, bool isAdd) external onlyAdmin {
        executor.updateAdaptor(_adapter, isAdd);
        emit UpdateAdapter(_adapter, isAdd);
    }

    /// @notice Receive ETH
    receive() external payable {}
}
