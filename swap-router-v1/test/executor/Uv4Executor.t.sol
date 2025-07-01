/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";
/// @notice ETH mainnet test

contract Uv4ExecutorTest is InitialTest {
    using SafeERC20 for IERC20;

    function testFromEthToUSDCV4() public {
        // eth -> usdc 100%
        Utils.MultiPath memory multiPath0;
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        {
            Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
            PoolKey memory poolKey = PoolKey({
                currency0: Currency.wrap(0x0000000000000000000000000000000000000000),
                currency1: Currency.wrap(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),
                fee: 3000,
                tickSpacing: 60,
                hooks: IHooks(0x0000000000000000000000000000000000000000)
            });
            UniswapV4Data memory arg = UniswapV4Data(0x66a9893cC07D91D95644AEDD05D03f95e1dBA8Af, poolKey, "");
            bytes memory payload = abi.encode(arg);
            Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 12, payload);
            swaps[0] = simpleSwap;
            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
            adapters[0] = adapter;
            Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
            singlePaths[0] = singlePath0;
        }
        multiPath0 = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath0;
        vm.deal(address(this), 1 ether);

        router.swap{value: 1 ether}(
            0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
            1 ether,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            1000e6,
            true,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 ethBalance = (address(this)).balance;
        console.logUint(ethBalance);
        uint256 usdcBalance = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        console.logUint(usdcBalance);
        assertTrue(usdcBalance > 1000e6);
    }

    function testFromUSDCToWethV4() public {
        // usdc -> weth 100%
        Utils.MultiPath memory multiPath0;
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](2);
        {
            Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
            PoolKey memory poolKey = PoolKey({
                currency0: Currency.wrap(0x0000000000000000000000000000000000000000),
                currency1: Currency.wrap(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),
                fee: 500,
                tickSpacing: 10,
                hooks: IHooks(0x0000000000000000000000000000000000000000)
            });
            UniswapV4Data memory arg = UniswapV4Data(0x66a9893cC07D91D95644AEDD05D03f95e1dBA8Af, poolKey, "");
            bytes memory payload = abi.encode(arg);
            Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 12, payload);
            swaps[0] = simpleSwap;
            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
            adapters[0] = adapter;
            Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, adapters);
            singlePaths[0] = singlePath0;
        }
        {
            Utils.SimpleSwap[] memory wethSwaps = new Utils.SimpleSwap[](1);
            Utils.SimpleSwap memory wethSimpleSwap = Utils.SimpleSwap(1e18, 11, "");
            wethSwaps[0] = wethSimpleSwap;
            Utils.Adapter[] memory wethAdapters = new Utils.Adapter[](1);
            Utils.Adapter memory wethAdapter = Utils.Adapter(payable(adapter1), 1e18, wethSwaps);
            wethAdapters[0] = wethAdapter;
            Utils.SinglePath memory wethSinglePath =
                Utils.SinglePath(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, wethAdapters);
            singlePaths[1] = wethSinglePath;
        }
        multiPath0 = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath0;
        deal(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(this), 2000e6);
        IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).approve(address(router), 2000e6);

        router.swap(
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            2000e6,
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            5e17,
            true,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 wethBalance = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balanceOf(address(this));
        assertTrue(wethBalance > 5e17);
    }

    function testFromUSDTToUSDCV4() public {
        // usdt -> usdc 100%
        Utils.MultiPath memory multiPath0;
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        {
            Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
            PoolKey memory poolKey = PoolKey({
                currency0: Currency.wrap(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),
                currency1: Currency.wrap(0xdAC17F958D2ee523a2206206994597C13D831ec7),
                fee: 10,
                tickSpacing: 1,
                hooks: IHooks(0x0000000000000000000000000000000000000000)
            });
            UniswapV4Data memory arg = UniswapV4Data(0x66a9893cC07D91D95644AEDD05D03f95e1dBA8Af, poolKey, "");
            bytes memory payload = abi.encode(arg);
            Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 12, payload);
            swaps[0] = simpleSwap;
            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
            adapters[0] = adapter;
            Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
            singlePaths[0] = singlePath0;
        }
        multiPath0 = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath0;
        deal(0xdAC17F958D2ee523a2206206994597C13D831ec7, address(this), 2000e6);
        IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).forceApprove(address(router), 2000e6);

        router.swap(
            0xdAC17F958D2ee523a2206206994597C13D831ec7,
            2000e6,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            1999e6,
            true,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 usdcBalance = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).balanceOf(address(this));
        assertTrue(usdcBalance > 1999e6);
    }
}
