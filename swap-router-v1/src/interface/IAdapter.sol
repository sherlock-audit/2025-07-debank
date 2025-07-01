/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../library/Utils.sol";

interface IAdapter {
    function executeSimpleSwap(
        address fromToken,
        address toToken,
        uint256 fromTokenAmount,
        Utils.SimpleSwap[] memory swaps
    ) external payable;
}
