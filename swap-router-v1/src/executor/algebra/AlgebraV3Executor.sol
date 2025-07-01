/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "../../interface/IUniswapV3Pool.sol";
import "../../library/UniswapV3Lib.sol";
import "../../library/Utils.sol";
import "./IAlgebraV3Router.sol";

/// @notice sushiswapV3, uniswapV3, pancakeV3 router
abstract contract AlgebraV3Executor {
    using SafeERC20 for IERC20;

    struct AlgebraV3Data {
        address router;
        uint160 sqrtX96;
    }

    function swapAlgebraV3(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory data) internal {
        AlgebraV3Data memory arg = abi.decode(data, (AlgebraV3Data));
        bool zeroForOne = fromToken < toToken;
        // approve
        IERC20(fromToken).forceApprove(arg.router, fromTokenAmount);
        // execute
        IAlgebraV3Router(arg.router).exactInputSingle(
            IAlgebraV3Router.ExactInputSingleParams({
                tokenIn: fromToken,
                tokenOut: toToken,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: fromTokenAmount,
                amountOutMinimum: 0,
                limitSqrtPrice: arg.sqrtX96 == 0
                    ? (zeroForOne ? UniswapV3Lib.MIN_SQRT_RATIO + 1 : UniswapV3Lib.MAX_SQRT_RATIO - 1)
                    : arg.sqrtX96
            })
        );
    }
}
