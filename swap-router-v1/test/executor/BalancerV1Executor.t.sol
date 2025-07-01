/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";

contract BalancerV1ExecutorTest is InitialTest {
    using SafeERC20 for IERC20;

    function testBalancerV1USDCToAMPL() public {
        bytes memory payload = abi.encode(0x7860E28ebFB8Ae052Bfe279c07aC5d94c9cD2937);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 7, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xD46bA6D942050d489DBd938a2C909A5d5039A161, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(this), 100e6);
        IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).forceApprove(address(router), 100e6);
        uint256 amplBalanceBefore = IERC20(0xD46bA6D942050d489DBd938a2C909A5d5039A161).balanceOf(address(this));
        console.log("amplBalanceBefore: ", amplBalanceBefore);
        router.swap(
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            100e6,
            0xD46bA6D942050d489DBd938a2C909A5d5039A161,
            99e6,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 amplBalanceAfter = IERC20(0xD46bA6D942050d489DBd938a2C909A5d5039A161).balanceOf(address(this));
        uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.log("amplBalanceAfter: ", amplBalanceAfter);
        console.log("usdcBalanceAfter: ", usdcBalanceAfter);
        assertEq(usdcBalanceAfter, 0);
    }
}
