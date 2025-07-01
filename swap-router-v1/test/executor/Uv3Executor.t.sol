/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";

/// @notice ETH mainnet test
contract Uv3ExecutorTest is InitialTest {
    using SafeERC20 for IERC20;

    function testUv3ExecutorFromWethToPePe() public {
        Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(
            // router
            0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45,
            0,
            3000
        );
        Utils.MultiPath memory multiPath0;
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);

        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 5, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath = Utils.SinglePath(
            // toToken
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            adapters
        );
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath;
        multiPath0 = Utils.MultiPath(1e18, singlePaths);

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath0;
        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 1 ether);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).approve(address(router), 1 ether);

        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            158000000e18,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 pepeBalance = IERC20(0x6982508145454Ce325dDbE47a25d4ec3d2311933).balanceOf(address(this));
        console.log(pepeBalance);
        assertTrue(pepeBalance > 0, "pepeBalance should be greater than 0");
    }

    function testUv3ExecutorFromPepeToWeth() public {
        uint256 wethBalanceBefore = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balanceOf(address(this));
        Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(
            // router
            0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45,
            0,
            3000
        );
        Utils.MultiPath memory multiPath0;
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);

        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 5, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath = Utils.SinglePath(
            // toToken
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            adapters
        );
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath;
        multiPath0 = Utils.MultiPath(1e18, singlePaths);

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath0;
        deal(0x6982508145454Ce325dDbE47a25d4ec3d2311933, address(this), 158000000e18);
        IERC20(0x6982508145454Ce325dDbE47a25d4ec3d2311933).approve(address(router), 158000000e18);

        router.swap(
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            158000000e18,
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            3e17,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 wethBalance = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balanceOf(address(this));
        console.log(wethBalance - wethBalanceBefore);
        assertTrue(wethBalance - wethBalanceBefore > 0, "pepeBalance should be greater than 0");
    }

    function testUv3ForkExecutorFromUSDTToUSDC() public {
        Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(
            // router
            0x2E6cd2d30aa43f40aa81619ff4b6E0a41479B13F,
            0,
            100
        );
        Utils.MultiPath memory multiPath0;
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);

        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 10, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath = Utils.SinglePath(
            // toToken
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            adapters
        );
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath;
        multiPath0 = Utils.MultiPath(1e18, singlePaths);

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath0;
        deal(0xdAC17F958D2ee523a2206206994597C13D831ec7, address(this), 100e6);
        IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).forceApprove(address(router), 100e6);

        router.swap(
            0xdAC17F958D2ee523a2206206994597C13D831ec7,
            100e6,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            99e6,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 usdcBalance = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.log(usdcBalance);
        assertTrue(usdcBalance > 0, "usdcBalance should be greater than 0");
    }
}
