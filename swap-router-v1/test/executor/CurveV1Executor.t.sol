/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";

contract CurveV1ExecutorTest is InitialTest {
    function testCurveV1ExecutorFromDAIToUSDC() public {
        CurveV1SwapArg memory arg = CurveV1SwapArg(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7, 0, 1, 0);

        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 3, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;
        deal(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(this), 100e18);
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(router), 100 ether);

        uint256 usdcBalanceBefore = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        router.swap(
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            100 ether,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            99e6,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.log("usdcBalanceAfter: ", usdcBalanceAfter);
        assertTrue(usdcBalanceAfter > usdcBalanceBefore, "usdcBalance should be greater than usdcBalanceBefore");
    }

    function testCurveV1ExecutorFromDAIToUSDCUnderlying() public {
        CurveV1SwapArg memory arg = CurveV1SwapArg(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD, 0, 1, 1);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 3, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(this), 100e18);
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(router), 100 ether);
        router.swap(
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            100 ether,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            99e6,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 daiBalanceAfter = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(address(this));
        uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.log("daiBalanceAfter: ", daiBalanceAfter);
        console.log("usdcBalanceAfter: ", usdcBalanceAfter);
        assertEq(daiBalanceAfter, 0);
    }

    function testCurveV1ExecutorWrongType() public {
        CurveV1SwapArg memory arg = CurveV1SwapArg(0xA5407eAE9Ba41422680e2e00537571bcC53efBfD, 0, 1, 3);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 3, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(this), 100e18);
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(router), 100 ether);
        cheats.expectRevert("CurveV1Executor: Invalid swap type");
        router.swap(
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            100 ether,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            99e6,
            false,
            0,
            feeReceiver,
            multiPaths
        );
    }
}
