/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../interface/IUniswapV2Pair.sol";

library UniswapV2Lib {
    bytes32 internal constant POOL_INIT_CODE_HASH = 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;
    
    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address, address) {
        return (tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address pair, address tokenA, address tokenB)
        internal
        view
        returns (address token0, uint256 reserveA, uint256 reserveB)
    {
        (token0,) = sortTokens(tokenA, tokenB);
        (uint256 reserve0, uint256 reserve1,) = IUniswapV2Pair(pair).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 fee, // v2 is 3
        uint256 denFee // v2 is 1000
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        // denFee - fee
        uint256 amountInWithFee = amountIn * (denFee - fee);
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = reserveIn * denFee + amountInWithFee;
        amountOut = numerator / denominator;
    }
}
