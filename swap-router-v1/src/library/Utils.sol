/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

library Utils {
    // @dev MultiPath represent A->B->C..->D swap. That is, through multiple SinglePath
    struct MultiPath {
        uint256 percent;
        SinglePath[] paths;
    }

    // @dev SinglePath Represents a swap from A->B, which does not involve an intermediate path, but may split the funds and use multiple dex
    // fromToken is obtained through MultiPath
    struct SinglePath {
        address toToken;
        Adapter[] adapters;
    }

    struct Adapter {
        address payable adapter;
        uint256 percent;
        SimpleSwap[] swaps; // They are all swaps from A->B, but different dex
    }

    // @dev SimpleSwap Represents a swap from A->B through a specific dex, without involving intermediate paths.
    struct SimpleSwap {
        uint256 percent;
        uint256 swapType;
        bytes data;
    }

    struct UniswapV3Data {
        address router;
        uint160 sqrtX96;
        uint24 fee;
    }
}
