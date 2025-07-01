/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

interface IUniswapV3Pool {
    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);
}
