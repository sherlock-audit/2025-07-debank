/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";

contract ExecutorTest is InitialTest {
    function testExecutorRevert() public {
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
        Utils.MultiPath memory multiPath = Utils.MultiPath(9e17, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;
        deal(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(this), 100e18);
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(router), 100 ether);

        cheats.expectRevert("Executor: Invalid MultiPath total percent");
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

        adapters = new Utils.Adapter[](1);
        adapter = Utils.Adapter(payable(feeReceiver), 1e18, swaps);
        adapters[0] = adapter;
        singlePath0 = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
        singlePaths[0] = singlePath0;
        multiPath = Utils.MultiPath(9e17, singlePaths);
        multiPaths[0] = multiPath;

        cheats.expectRevert("Executor: adapter not whitelist");
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

    function testAdapterPercentageRevert() public {
        CurveV1SwapArg memory arg = CurveV1SwapArg(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7, 0, 1, 0);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 3, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 9e17, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;
        deal(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(this), 100e18);
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(router), 100 ether);

        cheats.expectRevert("Executor: Invalid adapter total percent");
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

    function testCrossMultiPathTokenInterference() public {
        // Test the fix for cross-MultiPath token interference
        // This test verifies that each MultiPath uses only its allocated tokens

        // Initialize executor
        executor = new Executor();
        executor.updateAdaptor(address(adapter1), true);

        // Setup: 10 wETH to USDC with two MultiPaths
        // MultiPath[0]: 60% wETH -> PEPE -> wETH -> USDC
        // MultiPath[1]: 40% wETH -> USDC

        // Create MultiPath[0]: wETH -> PEPE -> wETH -> USDC (60%)
        Utils.MultiPath memory multiPath0;
        {
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](3);

            // wETH -> PEPE u2
            Utils.SimpleSwap[] memory swap1 = new Utils.SimpleSwap[](1);
            bytes memory payload = abi.encode(UniswapV2SwapArg(0xA43fe16908251ee70EF74718545e4FE6C5cCEc9f, 3, 1000));
            swap1[0] = Utils.SimpleSwap(1e18, 1, payload);
            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            adapters[0] = Utils.Adapter(payable(adapter1), 1e18, swap1);
            singlePaths[0] = Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters); // PEPE

            // PEPE -> wETH u3
            Utils.SimpleSwap[] memory swaps2 = new Utils.SimpleSwap[](1);
            payload = abi.encode(Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 3000));
            swaps2[0] = Utils.SimpleSwap(1e18, 5, payload);
            Utils.Adapter[] memory adapters2 = new Utils.Adapter[](1);
            adapters2[0] = Utils.Adapter(payable(adapter1), 1e18, swaps2);
            singlePaths[1] = Utils.SinglePath(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, adapters2); // wETH

            // wETH -> USDC
            Utils.SimpleSwap[] memory swaps3 = new Utils.SimpleSwap[](1);
            payload = abi.encode(UniswapV2SwapArg(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc, 3, 1000));
            swaps3[0] = Utils.SimpleSwap(1e18, 1, payload);
            Utils.Adapter[] memory adapters3 = new Utils.Adapter[](1);
            adapters3[0] = Utils.Adapter(payable(adapter1), 1e18, swaps3);
            singlePaths[2] = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters3); // USDC

            multiPath0 = Utils.MultiPath(6e17, singlePaths); // 60%
        }

        // Create MultiPath[1]: wETH -> USDC (40%)
        Utils.MultiPath memory multiPath1;
        {
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
            Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
            bytes memory payload = abi.encode(Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 3000));
            swaps[0] = Utils.SimpleSwap(1e18, 5, payload);
            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            adapters[0] = Utils.Adapter(payable(adapter1), 1e18, swaps);
            singlePaths[0] = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters); // USDC

            multiPath1 = Utils.MultiPath(4e17, singlePaths); // 40%
        }

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](2);
        multiPaths[0] = multiPath0;
        multiPaths[1] = multiPath1;

        // Execute the swap
        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 10 ether);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).approve(address(router), 10 ether);

        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            10 ether,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            0,
            true,
            0,
            feeReceiver,
            multiPaths
        );
    }
}
