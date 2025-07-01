/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";

contract MakerCurveV2ExecutorTest is InitialTest {
    using SafeERC20 for IERC20;

    function testCurveV2ExecutorFromWethToWbtc() public {
        CurveV2SwapArg memory arg = CurveV2SwapArg(0xD51a44d3FaE010294C616388b506AcdA1bfAAE46, 2, 1, address(0), 0, 0);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 4, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 1e18);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).approve(address(router), 1 ether);
        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
            150e4,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 wbtcBalanceAfter = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599).balanceOf(address(this));
        uint256 wethBalanceAfter = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balanceOf(address(this));
        console.log("wbtcBalanceAfter: ", wbtcBalanceAfter);
        console.log("wethBalanceAfter: ", wethBalanceAfter);
        assertEq(wethBalanceAfter, 0);
        assertTrue(wbtcBalanceAfter > 150e4);
    }

    function testCurveV2ExecutorAddLiquidity() public {
        CurveV2SwapArg memory arg = CurveV2SwapArg(0x52EA46506B9CC5Ef470C5bf89f17Dc28bB35D85C, 2, 0, address(0), 4, 3);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 4, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0x9fC689CCaDa600B6DF723D9E47D84d76664a1F23, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0xdAC17F958D2ee523a2206206994597C13D831ec7, address(this), 100e6);
        IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).forceApprove(address(router), 100e6);
        router.swap(
            0xdAC17F958D2ee523a2206206994597C13D831ec7,
            100e6,
            0x9fC689CCaDa600B6DF723D9E47D84d76664a1F23,
            0,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 curveFiBalanceAfter = IERC20(0x9fC689CCaDa600B6DF723D9E47D84d76664a1F23).balanceOf(address(this));
        uint256 usdtBalanceAfter = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).balanceOf(address(this));
        console.log("curveFiBalanceAfter: ", curveFiBalanceAfter);
        console.log("usdtBalanceAfter: ", usdtBalanceAfter);
    }

    function testCurveV2ExecutorRemoveLiquidity() public {
        CurveV2SwapArg memory arg = CurveV2SwapArg(0x3211C6cBeF1429da3D0d58494938299C92Ad5860, 1, 0, address(0), 3, 0);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 4, payload);
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

        deal(0xdf55670e27bE5cDE7228dD0A6849181891c9ebA1, address(this), 100e18);
        IERC20(0xdf55670e27bE5cDE7228dD0A6849181891c9ebA1).forceApprove(address(router), 100e18);
        router.swap(
            0xdf55670e27bE5cDE7228dD0A6849181891c9ebA1,
            100e18,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            0,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        // uint256 curveFiBalanceAfter = IERC20(0x3211C6cBeF1429da3D0d58494938299C92Ad5860).balanceOf(address(this));
        uint256 usdcBalanceAfter = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        // console.log("curveFiBalanceAfter: ", curveFiBalanceAfter);
        console.log("usdtBalanceAfter: ", usdcBalanceAfter);
    }

    function testCurveV2ExecutorFromETHToUSDTUnderlying() public {
        CurveV2SwapArg memory arg = CurveV2SwapArg(0x4eBdF703948ddCEA3B11f675B4D1Fba9d2414A14, 2, 0, address(0), 1, 0);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 4, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0xD533a949740bb3306d119CC777fa900bA034cd52, address(this), 10000 ether);
        IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52).forceApprove(address(router), 10000 ether);
        router.swap(
            0xD533a949740bb3306d119CC777fa900bA034cd52,
            10000 ether,
            0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E,
            0,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 crvBalanceAfter = IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52).balanceOf(address(this));
        uint256 crvUSDBalanceAfter = IERC20(0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E).balanceOf(address(this));
        console.log("crvBalanceAfter: ", crvBalanceAfter);
        console.log("crvUSDBalanceAfter: ", crvUSDBalanceAfter);
        assertEq(crvBalanceAfter, 0);
    }

    function testCurveV2ExecutorWrongSwapType() public {
        CurveV2SwapArg memory arg = CurveV2SwapArg(0x4eBdF703948ddCEA3B11f675B4D1Fba9d2414A14, 2, 0, address(0), 7, 0);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 4, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0xD533a949740bb3306d119CC777fa900bA034cd52, address(this), 10000 ether);
        IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52).forceApprove(address(router), 10000 ether);
        cheats.expectRevert("CurveV2Executor: Invalid swap type");
        router.swap(
            0xD533a949740bb3306d119CC777fa900bA034cd52,
            10000 ether,
            0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E,
            0,
            false,
            0,
            feeReceiver,
            multiPaths
        );
    }
}
