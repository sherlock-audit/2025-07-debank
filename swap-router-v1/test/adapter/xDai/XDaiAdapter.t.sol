// /*
//     Copyright Debank
//     SPDX-License-Identifier: BUSL-1.1
// */
// pragma solidity ^0.8.25;

// import "./XDaiInitial.t.sol";

// contract XDaiAdapterTest is XDaiInitialTest {
//     function testSushiSwapV2WethToBtc() public {
//         uint256 btcBeforeBalance = IERC20(0x8e5bBbb09Ed1ebdE8674Cda39A0c169401db4252).balanceOf(address(this));
//         UniswapV2SwapArg memory arg = UniswapV2SwapArg(0xe21F631f47bFB2bC53ED134E83B8cff00e0EC054, 3, 1000);
//         Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
//         bytes memory payload = abi.encode(arg);
//         Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 1, payload);
//         swaps[0] = simpleSwap;
//         Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
//         Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
//         adapters[0] = adapter;
//         Utils.SinglePath memory singlePath0 = Utils.SinglePath(0x8e5bBbb09Ed1ebdE8674Cda39A0c169401db4252, adapters);
//         Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
//         singlePaths[0] = singlePath0;
//         Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
//         Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
//         multiPaths[0] = multiPath;
//         deal(0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1, address(this), 1e18);
//         IERC20(0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1).approve(address(router), 1e18);

//         router.swap(
//             0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1,
//             1 ether,
//             0x8e5bBbb09Ed1ebdE8674Cda39A0c169401db4252,
//             1e6,
//             false,
//             0,
//             feeReceiver,
//             multiPaths
//         );
//         uint256 btcBalance = IERC20(0x8e5bBbb09Ed1ebdE8674Cda39A0c169401db4252).balanceOf(address(this));
//         console.log(btcBalance - btcBeforeBalance);
//     }

//     function testSwaprV2WethToWxdai() public {
//         UniswapV2SwapArg memory arg = UniswapV2SwapArg(0x1865d5445010E0baf8Be2eB410d3Eae4A68683c2, 3, 1000);
//         Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
//         bytes memory payload = abi.encode(arg);
//         Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 1, payload);
//         swaps[0] = simpleSwap;
//         Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
//         Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
//         adapters[0] = adapter;
//         Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d, adapters);
//         Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
//         singlePaths[0] = singlePath0;
//         Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
//         Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
//         multiPaths[0] = multiPath;
//         deal(0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1, address(this), 1e18);
//         IERC20(0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1).approve(address(router), 1e18);

//         router.swap(
//             // weth
//             0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1,
//             1 ether,
//             // wxdai
//             0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d,
//             1300e18,
//             false,
//             0,
//             feeReceiver,
//             multiPaths
//         );
//         uint256 wxdaiBalance = IERC20(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d).balanceOf(address(this));
//         console.log(wxdaiBalance);
//     }

//     function testXDaiCurveV1ExecutorFromDAIToUSDC() public {
//         CurveV1SwapArg memory arg = CurveV1SwapArg(0x7f90122BF0700F9E7e1F688fe926940E8839F353, 0, 1, 0);
//         Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
//         bytes memory payload = abi.encode(arg);
//         Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 3, payload);
//         swaps[0] = simpleSwap;
//         Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
//         Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
//         adapters[0] = adapter;
//         Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83, adapters);
//         Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
//         singlePaths[0] = singlePath0;
//         Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
//         Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
//         multiPaths[0] = multiPath;
//         deal(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d, address(this), 100e18);
//         IERC20(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d).approve(address(router), 100 ether);

//         uint256 usdcBalanceBefore = IERC20(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83).balanceOf(address(this));
//         router.swap(
//             // xdai
//             0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d,
//             100 ether,
//             // usdc
//             0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83,
//             99e6,
//             false,
//             0,
//             feeReceiver,
//             multiPaths
//         );
//         uint256 usdcBalanceAfter = IERC20(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83).balanceOf(address(this));
//         console.log("usdcBalanceAfter: ", usdcBalanceAfter - usdcBalanceBefore);
//     }

//     function testXDaiCurveV2ExecutorFromCrvToEur() public {
//         CurveV2SwapArg memory arg = CurveV2SwapArg(0x592878b920101946Fb5915aB97961bC546f211CC, 1, 0, address(0), 0, 0);
//         Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
//         bytes memory payload = abi.encode(arg);
//         Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 4, payload);
//         swaps[0] = simpleSwap;
//         Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
//         Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
//         adapters[0] = adapter;
//         Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xcB444e90D8198415266c6a2724b7900fb12FC56E, adapters);
//         Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
//         singlePaths[0] = singlePath0;
//         Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
//         Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
//         multiPaths[0] = multiPath;
//         deal(0x712b3d230F3C1c19db860d80619288b1F0BDd0Bd, address(this), 100e18);
//         IERC20(0x712b3d230F3C1c19db860d80619288b1F0BDd0Bd).approve(address(router), 100 ether);

//         uint256 eurBalanceBefore = IERC20(0xcB444e90D8198415266c6a2724b7900fb12FC56E).balanceOf(address(this));
//         router.swap(
//             // crv
//             0x712b3d230F3C1c19db860d80619288b1F0BDd0Bd,
//             100 ether,
//             // eur
//             0xcB444e90D8198415266c6a2724b7900fb12FC56E,
//             50e18,
//             false,
//             0,
//             feeReceiver,
//             multiPaths
//         );
//         uint256 eurBalanceAfter = IERC20(0xcB444e90D8198415266c6a2724b7900fb12FC56E).balanceOf(address(this));
//         console.log("eurBalanceAfter: ", eurBalanceAfter - eurBalanceBefore);
//     }

//     function testXDaiBalancerV2SdaiToWsteth() public {
//         BalancerV2Param memory arg = BalancerV2Param(
//             // poolId
//             0xbc2acf5e821c5c9f8667a36bb1131dad26ed64f9000200000000000000000063,
//             // pool
//             0xBA12222222228d8Ba445958a75a0704d566BF2C8
//         );
//         bytes memory payload = abi.encode(arg);
//         Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
//         Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 8, payload);
//         swaps[0] = simpleSwap;
//         Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
//         Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
//         adapters[0] = adapter;
//         Utils.SinglePath memory singlePath0 = Utils.SinglePath(0x6C76971f98945AE98dD7d4DFcA8711ebea946eA6, adapters);
//         Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
//         singlePaths[0] = singlePath0;
//         Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
//         Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
//         multiPaths[0] = multiPath;

//         deal(0xaf204776c7245bF4147c2612BF6e5972Ee483701, address(this), 1000e18);
//         IERC20(0xaf204776c7245bF4147c2612BF6e5972Ee483701).approve(address(router), 1000e18);
//         uint256 wstEthBalanceBefore = IERC20(0x6C76971f98945AE98dD7d4DFcA8711ebea946eA6).balanceOf(address(this));
//         console.log("wstEthBalanceBefore: ", wstEthBalanceBefore);
//         router.swap(
//             0xaf204776c7245bF4147c2612BF6e5972Ee483701,
//             1000e18,
//             0x6C76971f98945AE98dD7d4DFcA8711ebea946eA6,
//             2e17,
//             false,
//             0,
//             feeReceiver,
//             multiPaths
//         );
//         uint256 wstEthBalanceAfter = IERC20(0x6C76971f98945AE98dD7d4DFcA8711ebea946eA6).balanceOf(address(this));
//         console.log("wstEthBalanceAfter: ", wstEthBalanceAfter - wstEthBalanceBefore);
//     }

//     function testSwaprV3WethToWxdai() public {
//         AlgebraV3Executor.AlgebraV3Data memory arg = AlgebraV3Executor.AlgebraV3Data(
//             // router
//             0xfFB643E73f280B97809A8b41f7232AB401a04ee1,
//             0
//         );
//         Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
//         bytes memory payload = abi.encode(arg);
//         Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 9, payload);
//         swaps[0] = simpleSwap;
//         Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
//         Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
//         adapters[0] = adapter;
//         Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d, adapters);
//         Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
//         singlePaths[0] = singlePath0;
//         Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
//         Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
//         multiPaths[0] = multiPath;
//         deal(0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1, address(this), 1e18);
//         IERC20(0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1).approve(address(router), 1e18);

//         router.swap(
//             // weth
//             0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1,
//             1 ether,
//             // wxdai
//             0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d,
//             1500e18,
//             false,
//             0,
//             feeReceiver,
//             multiPaths
//         );
//         uint256 wxdaiBalance = IERC20(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d).balanceOf(address(this));
//         console.log(wxdaiBalance);
//     }

//     function testXDaiSushiV3UsdcToWxdai() public {
//         Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(
//             // router
//             0x4F54dd2F4f30347d841b7783aD08c050d8410a9d,
//             0,
//             100
//         );
//         Utils.MultiPath memory multiPath0;
//         Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
//         bytes memory payload = abi.encode(arg);

//         Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 10, payload);
//         swaps[0] = simpleSwap;
//         Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
//         Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
//         adapters[0] = adapter;
//         Utils.SinglePath memory singlePath = Utils.SinglePath(
//             // toToken
//             0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d,
//             adapters
//         );
//         Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
//         singlePaths[0] = singlePath;
//         multiPath0 = Utils.MultiPath(1e18, singlePaths);

//         Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
//         multiPaths[0] = multiPath0;
//         deal(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83, address(this), 100e6);
//         IERC20(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83).approve(address(router), 100e6);

//         router.swap(
//             0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83,
//             100e6,
//             0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d,
//             80e18,
//             false,
//             0,
//             feeReceiver,
//             multiPaths
//         );
//         //     uint256 wxDaiBalance = IERC20(0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d).balanceOf(address(this));
//         //     console.log(wxDaiBalance);
//         //     assertTrue(wxDaiBalance > 0, "wxDaiBalance should be greater than 0");
//     }
// }
