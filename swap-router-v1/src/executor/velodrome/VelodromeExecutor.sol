/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../library/UniswapV3Lib.sol";
import "../../library/Utils.sol";
import "./IVelodromeRouter.sol";

abstract contract VelodromeExecutor {
    using SafeERC20 for IERC20;

    struct VelodromeData {
        address router;
        uint160 sqrtX96;
        int24 tickSpacing;
    }

    function swapVelodrome(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory data) internal {
        VelodromeData memory arg = abi.decode(data, (VelodromeData));
        bool zeroForOne = fromToken < toToken;
        // approve
        IERC20(fromToken).forceApprove(arg.router, fromTokenAmount);
        // execute
        IVelodromeRouter(arg.router).exactInputSingle(
            IVelodromeRouter.ExactInputSingleParams({
                tokenIn: fromToken,
                tokenOut: toToken,
                tickSpacing: arg.tickSpacing,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: fromTokenAmount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: arg.sqrtX96 == 0
                    ? (zeroForOne ? UniswapV3Lib.MIN_SQRT_RATIO + 1 : UniswapV3Lib.MAX_SQRT_RATIO - 1)
                    : arg.sqrtX96
            })
        );
    }
}
