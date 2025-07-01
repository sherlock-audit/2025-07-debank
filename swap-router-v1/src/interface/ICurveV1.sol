/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

interface ICurveV1Pool {
    /**
     * @notice Exchange tokens using the underlying tokens
     * @param i The index of the input token (token to sell)
     * @param j The index of the output token (token to buy)
     * @param dx The amount of the input token to sell
     * @param minDy The minimum amount of the output token to buy
     */
    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 minDy) external;

    function exchange(int128 i, int128 j, uint256 dx, uint256 minDy) external;

    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount) external;
}
