/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../library/UniswapV3Lib.sol";
import "../../library/Utils.sol";
import "./IUniswapV3Router.sol";

/// @notice sushiswapV3, uniswapV3, pancakeV3 router
abstract contract UniswapV3Executor {
    using SafeERC20 for IERC20;

    function swapUniswapV3(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory data) internal {
        Utils.UniswapV3Data memory arg = abi.decode(data, (Utils.UniswapV3Data));
        bool zeroForOne = fromToken < toToken;
        // approve
        IERC20(fromToken).forceApprove(arg.router, fromTokenAmount);
        // execute
        IUniswapV3Router(arg.router).exactInputSingle(
            IUniswapV3Router.ExactInputSingleParams02({
                tokenIn: fromToken,
                tokenOut: toToken,
                fee: arg.fee,
                recipient: address(this),
                amountIn: fromTokenAmount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: arg.sqrtX96 == 0
                    ? (zeroForOne ? UniswapV3Lib.MIN_SQRT_RATIO + 1 : UniswapV3Lib.MAX_SQRT_RATIO - 1)
                    : arg.sqrtX96
            })
        );
    }
}
