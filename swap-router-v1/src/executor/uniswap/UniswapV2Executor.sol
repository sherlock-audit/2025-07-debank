/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../library/UniswapV2Lib.sol";
import "../../library/UniversalERC20.sol";
import "../../interface/IUniswapV2Pair.sol";

struct UniswapV2SwapArg {
    address pool;
    uint256 fee;
    uint256 denFee; // fee denominator
}

abstract contract UniswapV2Executor {
    using SafeERC20 for IERC20;
    using UniversalERC20 for IERC20;

    function swapUniswapV2(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory data) internal {
        UniswapV2SwapArg memory arg = abi.decode(data, (UniswapV2SwapArg));
        address pool = arg.pool;
        uint256 fee = arg.fee;
        uint256 denFee = arg.denFee;

        IERC20(fromToken).safeTransfer(pool, fromTokenAmount);
        // swap
        (address token0, uint256 reserveInput, uint256 reserveOutput) =
            UniswapV2Lib.getReserves(pool, fromToken, toToken);

        uint256 amountInActual = IERC20(fromToken).balanceOf(pool) - reserveInput;
        uint256 amountOutput = UniswapV2Lib.getAmountOut(amountInActual, reserveInput, reserveOutput, fee, denFee);

        (uint256 amount0Out, uint256 amount1Out) =
            fromToken == token0 ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
        IUniswapV2Pair(pool).swap(amount0Out, amount1Out, address(this), new bytes(0));
    }
}
