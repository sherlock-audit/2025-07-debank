/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

interface ICurveV2Pool {
    function exchange_underlying(uint256 i, uint256 j, uint256 dx, uint256 minDy) external;

    function exchange(uint256 i, uint256 j, uint256 dx, uint256 minDy) external;
    function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount) external;
    // Approval is required before joining liquidity，amounts: The amount to be added to the liquidity
    function add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount) external;
    function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external;
    function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external;
}

interface IGenericFactoryZap {
    function exchange(address _pool, uint256 i, uint256 j, uint256 _dx, uint256 _min_dy) external;
}
