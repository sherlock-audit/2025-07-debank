/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@v4-core/contracts/types/PoolKey.sol";

interface IUniversalRouter {
    struct ExactInputSingleParams {
        PoolKey poolKey;
        bool zeroForOne;
        uint128 amountIn;
        uint128 amountOutMinimum;
        bytes hookData;
    }

    function execute(bytes calldata commands, bytes[] calldata inputs, uint256 deadline) external payable;
}
