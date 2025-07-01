/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";

contract MakerPsmExecutorTest is InitialTest {
    function testMakerlitePsmExecutorFromDAIToUSDC() public {
        bytes memory payload =
            abi.encode(0xf6e72Db5454dd049d0788e411b06CfAF16853042, 0xf6e72Db5454dd049d0788e411b06CfAF16853042, 0, 1e12);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 2, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;
        uint256 usdcBalanceBefore = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        deal(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(this), 2333 ether);
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(router), 2333 ether);
        router.swap(
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            2333 ether,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            999e6,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 daiBalanceAfter = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(address(this));
        uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.log("daiBalanceAfter: ", daiBalanceAfter);
        console.log("usdcBalanceAfter: ", usdcBalanceAfter);
        assertEq(usdcBalanceAfter, usdcBalanceBefore + 2333e6);
        assertEq(daiBalanceAfter, 0);
    }

    // Do not use this test case, because the liquidity is not enough in the pool
    // function testMakerPsmExecutorFromDAIToUSDC() public {
    //     bytes memory payload =
    //         abi.encode(0x89B78CfA322F6C5dE0aBcEecab66Aee45393cC5A, 0x89B78CfA322F6C5dE0aBcEecab66Aee45393cC5A, 0, 1000000000000);
    //     Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
    //     Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 2, payload);
    //     swaps[0] = simpleSwap;
    //     Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
    //     Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
    //     adapters[0] = adapter;
    //     Utils.SinglePath memory singlePath = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
    //     Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
    //     singlePaths[0] = singlePath;
    //     Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
    //     Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
    //     multiPaths[0] = multiPath;
    //     uint256 usdcBalanceBefore = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
    //     deal(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(this), 0 ether);
    //     IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(router), 0 ether);
    //     router.swap(
    //         0x6B175474E89094C44Da98b954EedeAC495271d0F,
    //         0 ether,
    //         0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
    //         0,
    //         false,
    //         0,
    //         feeReceiver,
    //         multiPaths
    //     );
    //     uint256 daiBalanceAfter = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(address(this));
    //     uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
    //     console.log("daiBalanceAfter: ", daiBalanceAfter);
    //     console.log("usdcBalanceAfter: ", usdcBalanceAfter);
    //     assertEq(usdcBalanceAfter, usdcBalanceBefore + 2333e6);
    //     assertEq(daiBalanceAfter, 0);
    // }

    // function testMakerPsmExecutorFromUSDCToDAI() public {
    //     bytes memory payload = abi.encode(0x0A59649758aa4d66E25f08Dd01271e891fe52199, 0x89B78CfA322F6C5dE0aBcEecab66Aee45393cC5A, 0, 1e12);
    //     Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
    //     Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 2, payload);
    //     swaps[0] = simpleSwap;
    //     Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
    //     Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
    //     adapters[0] = adapter;
    //     Utils.SinglePath memory singlePath = Utils.SinglePath(0x6B175474E89094C44Da98b954EedeAC495271d0F, adapters);
    //     Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
    //     singlePaths[0] = singlePath;
    //     Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
    //     Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
    //     multiPaths[0] = multiPath;

    //     uint256 daiBalanceBefore = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(address(this));
    //     deal(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(this), 0);
    //     IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).approve(address(router), 0);
    //     router.swap(
    //         0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
    //         0,
    //         0x6B175474E89094C44Da98b954EedeAC495271d0F,
    //         0,
    //         false,
    //         0,
    //         feeReceiver,
    //         multiPaths
    //     );
    //     uint256 daiBalanceAfter = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(address(this));
    //     uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
    //     console.log("daiBalanceAfter: ", daiBalanceAfter);
    //     console.log("usdcBalanceAfter: ", usdcBalanceAfter);
    //     assertEq(daiBalanceAfter, daiBalanceBefore + 2333e18);
    //     assertEq(usdcBalanceAfter, 0);
    // }

    function testMakerlitePsmExecutorFromUSDCToDAI() public {
        bytes memory payload =
            abi.encode(0xf6e72Db5454dd049d0788e411b06CfAF16853042, 0xf6e72Db5454dd049d0788e411b06CfAF16853042, 0, 1e12);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 2, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath = Utils.SinglePath(0x6B175474E89094C44Da98b954EedeAC495271d0F, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        uint256 daiBalanceBefore = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(address(this));
        deal(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(this), 2333e6);
        IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).approve(address(router), 2333e6);
        router.swap(
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            2333e6,
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            999e18,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 daiBalanceAfter = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(address(this));
        uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.log("daiBalanceAfter: ", daiBalanceAfter);
        console.log("usdcBalanceAfter: ", usdcBalanceAfter);
        assertEq(daiBalanceAfter, daiBalanceBefore + 2333e18);
        assertEq(usdcBalanceAfter, 0);
    }

    function testMakerPsmExecutorWrongToken() public {
        bytes memory payload =
            abi.encode(0xf6e72Db5454dd049d0788e411b06CfAF16853042, 0xf6e72Db5454dd049d0788e411b06CfAF16853042, 0, 1e12);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 2, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;
        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 1 ether);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).approve(address(router), 1 ether);

        cheats.expectRevert("MakerPsmExecutor: Invalid token");
        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            999e6,
            false,
            0,
            feeReceiver,
            multiPaths
        );
    }
}
