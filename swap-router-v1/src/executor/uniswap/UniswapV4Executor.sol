/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@v4-core/contracts/types/PoolKey.sol";
import "../../library/UniversalERC20.sol";
import "./IUniversalRouter.sol";

struct UniswapV4Data {
    address router;
    PoolKey poolKey;
    bytes hookData;
}

interface IPermit2 {
    function approve(address token, address spender, uint160 amount, uint48 expiration) external;
}

/// @notice uniswapV4 router
abstract contract UniswapV4Executor {
    using SafeERC20 for IERC20;
    using UniversalERC20 for IERC20;

    address public immutable permit2;

    constructor(address _permit2) {
        permit2 = _permit2;
    }

    uint256 internal constant SWAP_EXACT_IN_SINGLE = 0x06;
    uint256 internal constant SETTLE_ALL = 0x0c;
    uint256 internal constant TAKE_ALL = 0x0f;
    uint256 internal constant V4_SWAP = 0x10;

    function swapUniswapV4(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory data) internal {
        UniswapV4Data memory arg = abi.decode(data, (UniswapV4Data));

        address actualFromToken = fromToken == UniversalERC20.ETH ? address(0) : fromToken;
        address actualToToken = toToken == UniversalERC20.ETH ? address(0) : toToken;
        bool zeroForOne = actualFromToken < actualToToken;

        bytes memory commands = abi.encodePacked(uint8(V4_SWAP));
        bytes[] memory inputs = new bytes[](1);
        bytes memory actions = abi.encodePacked(uint8(SWAP_EXACT_IN_SINGLE), uint8(SETTLE_ALL), uint8(TAKE_ALL));

        bytes[] memory params = new bytes[](3);
        params[0] = abi.encode(
            IUniversalRouter.ExactInputSingleParams({
                poolKey: arg.poolKey,
                zeroForOne: zeroForOne,
                amountIn: SafeCast.toUint128(fromTokenAmount),
                amountOutMinimum: 0,
                hookData: arg.hookData
            })
        );
        // user input
        params[1] = abi.encode(Currency.wrap(actualFromToken), fromTokenAmount);
        // user output
        params[2] = abi.encode(Currency.wrap(actualToToken), 0);

        // Combine actions and params into inputs
        inputs[0] = abi.encode(actions, params);
        // approve
        if (fromToken != UniversalERC20.ETH) {
            IERC20(fromToken).forceApprove(permit2, fromTokenAmount);
            IPermit2(permit2).approve(
                fromToken, arg.router, SafeCast.toUint160(fromTokenAmount), SafeCast.toUint48(block.timestamp)
            );
            // execute
            IUniversalRouter(arg.router).execute(commands, inputs, block.timestamp);
        } else {
            // execute
            IUniversalRouter(arg.router).execute{value: fromTokenAmount}(commands, inputs, block.timestamp);
        }
    }
}
