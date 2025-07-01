/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../interface/IBalancerV2.sol";

struct BalancerV2Param {
    bytes32 poolId;
    address pool;
}

abstract contract BalancerV2Executor {
    using SafeERC20 for IERC20;

    function swapBalancerV2(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory payload)
        internal
    {
        BalancerV2Param memory arg = abi.decode(payload, (BalancerV2Param));
        IBalancerV2.SingleSwap memory singleSwap =
            IBalancerV2.SingleSwap(arg.poolId, IBalancerV2.SwapKind.GIVEN_IN, fromToken, toToken, fromTokenAmount, "");
        IBalancerV2.FundManagement memory funds =
            IBalancerV2.FundManagement(address(this), false, payable(address(this)), false);

        IERC20(fromToken).forceApprove(arg.pool, fromTokenAmount);
        IBalancerV2(arg.pool).swap(singleSwap, funds, 1, block.timestamp + 1);
    }
}
