/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../interface/IBalancer.sol";

abstract contract BalancerV1Executor {
    using SafeERC20 for IERC20;

    /**
     * @notice Swap tokens using Balancer V1
     * @param fromToken The address of the token to swap from
     * @param toToken The address of the token to swap to
     * @param fromTokenAmount The amount of the token to swap from
     * @param payload The payload containing the pool address
     */
    function swapBalancerV1(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory payload)
        internal
    {
        address pool = abi.decode(payload, (address));

        IERC20(fromToken).forceApprove(pool, fromTokenAmount);
        IBalancer(pool).swapExactAmountIn(fromToken, fromTokenAmount, toToken, 1, type(uint256).max - 1);
    }
}
