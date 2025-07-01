/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "./Initial.t.sol";

contract RouterTest is InitialTest {
    function testFromWethToPEPERevert() public {
        // weth -> pepe 60%
        Utils.MultiPath memory multiPath0;
        {
            Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](2);
            // u2 50%
            {
                UniswapV2SwapArg memory arg = UniswapV2SwapArg(0xA43fe16908251ee70EF74718545e4FE6C5cCEc9f, 3, 1000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 1, payload);
                paths[0] = path;
            }
            // u3 50%
            {
                Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(
                    // router
                    0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45,
                    0,
                    3000
                );
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 5, payload);
                paths[1] = path;
            }

            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
            adapters[0] = adapter;

            Utils.SinglePath memory singlePath0 = Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
            singlePaths[0] = singlePath0;
            multiPath0 = Utils.MultiPath(6e17, singlePaths);
        }

        // weth -> usdc -> pepe u3 40%
        Utils.MultiPath memory multiPath1;
        {
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](2);
            {
                Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);

                Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 500);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                paths[0] = path;

                Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                adapters[0] = adapter;
                Utils.SinglePath memory singlePath =
                    Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
                singlePaths[0] = singlePath;
            }
            {
                Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);
                Utils.UniswapV3Data memory arg =
                    Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 10000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                paths[0] = path;
                Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                adapters[0] = adapter;
                Utils.SinglePath memory singlePath =
                    Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
                singlePaths[1] = singlePath;
            }
            multiPath1 = Utils.MultiPath(4e17, singlePaths);
        }

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](2);
        multiPaths[0] = multiPath0;
        multiPaths[1] = multiPath1;
        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 1 ether);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).approve(address(router), 1 ether);

        cheats.expectRevert("Router: Fee Rate is too big");
        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            2.155474451e26,
            true,
            1e17,
            feeReceiver,
            multiPaths
        );


        cheats.expectRevert("Router: fromToken and toToken cannot be the same");
        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            2.155474451e26,
            true,
            1e17,
            feeReceiver,
            multiPaths
        );
    }

    function testFromWethToPEPE() public {
        // weth -> pepe 60%
        Utils.MultiPath memory multiPath0;
        {
            Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](2);
            // u2 50%
            {
                UniswapV2SwapArg memory arg = UniswapV2SwapArg(0xA43fe16908251ee70EF74718545e4FE6C5cCEc9f, 3, 1000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 1, payload);
                paths[0] = path;
            }
            // u3 50%
            {
                Utils.UniswapV3Data memory arg =
                    Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 3000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 5, payload);
                paths[1] = path;
            }

            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
            adapters[0] = adapter;

            Utils.SinglePath memory singlePath0 = Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
            singlePaths[0] = singlePath0;
            multiPath0 = Utils.MultiPath(6e17, singlePaths);
        }

        // weth -> usdc -> pepe u3 40%
        Utils.MultiPath memory multiPath1;
        {
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](2);
            {
                Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);

                Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 500);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                paths[0] = path;

                Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                adapters[0] = adapter;
                Utils.SinglePath memory singlePath =
                    Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
                singlePaths[0] = singlePath;
            }
            {
                Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);
                Utils.UniswapV3Data memory arg =
                    Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 10000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                paths[0] = path;
                Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                adapters[0] = adapter;
                Utils.SinglePath memory singlePath =
                    Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
                singlePaths[1] = singlePath;
            }
            multiPath1 = Utils.MultiPath(4e17, singlePaths);
        }

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](2);
        multiPaths[0] = multiPath0;
        multiPaths[1] = multiPath1;
        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 1 ether);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).approve(address(router), 1 ether);

        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            158000000e18,
            true,
            1e15,
            feeReceiver,
            multiPaths
        );
        uint256 pepebalance = IERC20(0x6982508145454Ce325dDbE47a25d4ec3d2311933).balanceOf(address(this));
        console.log("pepe balance", pepebalance);
        uint256 pepeFeebalance = IERC20(0x6982508145454Ce325dDbE47a25d4ec3d2311933).balanceOf(feeReceiver);
        console.log("pepe fee balance", pepeFeebalance);
        uint256 wethbalance = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balanceOf(address(this));
        console.log("weth balance", wethbalance);
        uint256 wethFeebalance = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balanceOf(feeReceiver);
        console.log("weth fee balance", wethFeebalance);
        assertEq(wethFeebalance, 1e15);
        assertEq(pepeFeebalance, 0);
    }

    function testFromEthToPEPE() public {
        // eth -> weth -> pepe 60%
        Utils.MultiPath memory multiPath0;
        {
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](2);
            {
                Utils.SimpleSwap[] memory wethSwaps = new Utils.SimpleSwap[](1);
                Utils.SimpleSwap memory wethSimpleSwap = Utils.SimpleSwap(1e18, 11, "");
                wethSwaps[0] = wethSimpleSwap;
                Utils.Adapter[] memory wethAdapters = new Utils.Adapter[](1);
                Utils.Adapter memory wethAdapter = Utils.Adapter(payable(adapter1), 1e18, wethSwaps);
                wethAdapters[0] = wethAdapter;
                Utils.SinglePath memory wethSinglePath =
                    Utils.SinglePath(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, wethAdapters);
                singlePaths[0] = wethSinglePath;
            }

            {
                Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](2);
                // u2 50%
                {
                    UniswapV2SwapArg memory arg = UniswapV2SwapArg(0xA43fe16908251ee70EF74718545e4FE6C5cCEc9f, 3, 1000);
                    bytes memory payload = abi.encode(arg);
                    Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 1, payload);
                    paths[0] = path;
                }
                // u3 50%
                {
                    Utils.UniswapV3Data memory arg =
                        Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 3000);
                    bytes memory payload = abi.encode(arg);
                    Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 5, payload);
                    paths[1] = path;
                }

                Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                adapters[0] = adapter;

                Utils.SinglePath memory singlePath1 =
                    Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
                singlePaths[1] = singlePath1;
            }
            multiPath0 = Utils.MultiPath(6e17, singlePaths);
        }

        // eth -> weth -> usdc -> pepe u3 40%
        Utils.MultiPath memory multiPath1;
        {
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](3);
            {
                {
                    Utils.SimpleSwap[] memory wethSwaps = new Utils.SimpleSwap[](1);
                    Utils.SimpleSwap memory wethSimpleSwap = Utils.SimpleSwap(1e18, 11, "");
                    wethSwaps[0] = wethSimpleSwap;
                    Utils.Adapter[] memory wethAdapters = new Utils.Adapter[](1);
                    Utils.Adapter memory wethAdapter = Utils.Adapter(payable(adapter1), 1e18, wethSwaps);
                    wethAdapters[0] = wethAdapter;
                    Utils.SinglePath memory wethSinglePath =
                        Utils.SinglePath(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, wethAdapters);
                    singlePaths[0] = wethSinglePath;
                }
                {
                    Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);

                    Utils.UniswapV3Data memory arg =
                        Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 500);
                    bytes memory payload = abi.encode(arg);
                    Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                    paths[0] = path;

                    Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                    Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                    adapters[0] = adapter;
                    Utils.SinglePath memory singlePath =
                        Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
                    singlePaths[1] = singlePath;
                }
                {
                    Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);
                    Utils.UniswapV3Data memory arg =
                        Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 10000);
                    bytes memory payload = abi.encode(arg);
                    Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                    paths[0] = path;
                    Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                    Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                    adapters[0] = adapter;
                    Utils.SinglePath memory singlePath =
                        Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
                    singlePaths[2] = singlePath;
                }
            }
            multiPath1 = Utils.MultiPath(4e17, singlePaths);
        }

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](2);
        multiPaths[0] = multiPath0;
        multiPaths[1] = multiPath1;
        vm.deal(address(this), 1 ether);
        uint256 ethFeebalanceBefore = feeReceiver.balance;
        router.swap{value: 1 ether}(
            0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
            1 ether,
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            158000000e18,
            true,
            1e15,
            feeReceiver,
            multiPaths
        );
        uint256 pepebalance = IERC20(0x6982508145454Ce325dDbE47a25d4ec3d2311933).balanceOf(address(this));
        console.log("pepe balance", pepebalance);
        uint256 pepeFeebalance = IERC20(0x6982508145454Ce325dDbE47a25d4ec3d2311933).balanceOf(feeReceiver);
        console.log("pepe fee balance", pepeFeebalance);
        uint256 ethbalance = address(this).balance;
        console.log("eth balance", ethbalance);
        // fee charge in eth
        uint256 ethFeebalance = feeReceiver.balance;
        console.log("eth fee balance", ethFeebalance);
        assertEq(ethFeebalance - ethFeebalanceBefore, 1e15);
        assertEq(pepeFeebalance, 0);
    }

    function testAdminFunction() public {
        // weth -> pepe 60%
        Utils.MultiPath memory multiPath0;
        {
            Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](2);
            // u2 50%
            {
                UniswapV2SwapArg memory arg = UniswapV2SwapArg(0xA43fe16908251ee70EF74718545e4FE6C5cCEc9f, 3, 1000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 1, payload);
                paths[0] = path;
            }
            // u3 50%
            {
                Utils.UniswapV3Data memory arg =
                    Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 3000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(5e17, 5, payload);
                paths[1] = path;
            }

            Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
            Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
            adapters[0] = adapter;

            Utils.SinglePath memory singlePath0 = Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
            singlePaths[0] = singlePath0;
            multiPath0 = Utils.MultiPath(6e17, singlePaths);
        }

        // weth -> usdc -> pepe u3 40%
        Utils.MultiPath memory multiPath1;
        {
            Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](2);
            {
                Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);

                Utils.UniswapV3Data memory arg = Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 500);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                paths[0] = path;

                Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                adapters[0] = adapter;
                Utils.SinglePath memory singlePath =
                    Utils.SinglePath(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, adapters);
                singlePaths[0] = singlePath;
            }
            {
                Utils.SimpleSwap[] memory paths = new Utils.SimpleSwap[](1);
                Utils.UniswapV3Data memory arg =
                    Utils.UniswapV3Data(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45, 0, 10000);
                bytes memory payload = abi.encode(arg);
                Utils.SimpleSwap memory path = Utils.SimpleSwap(1e18, 5, payload);
                paths[0] = path;
                Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
                Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, paths);
                adapters[0] = adapter;
                Utils.SinglePath memory singlePath =
                    Utils.SinglePath(0x6982508145454Ce325dDbE47a25d4ec3d2311933, adapters);
                singlePaths[1] = singlePath;
            }
            multiPath1 = Utils.MultiPath(4e17, singlePaths);
        }

        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](2);
        multiPaths[0] = multiPath0;
        multiPaths[1] = multiPath1;
        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 1 ether);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).approve(address(router), 1 ether);
        // pause router
        router.pause();
        cheats.expectRevert("Admin: paused");
        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            158000000e18,
            true,
            1e15,
            feeReceiver,
            multiPaths
        );
        router.unpause();

        cheats.expectRevert("Admin: not paused");
        router.unpause();

        // test updateAdmins
        cheats.expectRevert("Admin: new admin cannot be zero address");
        router.updateAdmins(address(0));
        cheats.expectRevert("Admin: new admin already exists");
        router.updateAdmins(address(this));
        router.pause();
        cheats.expectRevert("Admin: must unpause before updating admin");
        router.updateAdmins(0x5D7c30c04c6976D4951209E55FB158DBF9F8F287);
        router.unpause();

        // test updateAdmins by admin
        vm.startPrank(admins[0]);
        router.updateAdmins(0x5D7c30c04c6976D4951209E55FB158DBF9F8F287);
        cheats.expectRevert("Admin: caller is not admin");
        router.pause();
        vm.stopPrank();
        vm.startPrank(0x5D7c30c04c6976D4951209E55FB158DBF9F8F287);
        router.pause();
        vm.stopPrank();

        vm.startPrank(admins[2]);
        router.pause();
        vm.stopPrank();

        // // test pasued by multiple admins
        cheats.expectRevert("Admin: cannot unpause when multiple admins paused");
        router.unpause();
        bool[3] memory adminPauseStates = router.getAdminPauseStates();
        assertEq(adminPauseStates[0], true);
        assertEq(adminPauseStates[1], false);
        assertEq(adminPauseStates[2], true);

        router.updateAdaptor(address(adapter1), false);
        address[] memory activeAdapters = router.executor().getAdapters();
        assertEq(activeAdapters.length, 0);

        router.getAdmins();
    }

    function testIncorrectMsgValue() public {
        // Test with ETH as fromToken
        vm.deal(address(this), 1 ether);
        vm.expectRevert("Router: Incorrect msg.value");
        router.swap{value: 0.5 ether}(
            UniversalERC20.ETH,
            1 ether,
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            0,
            true,
            0,
            feeReceiver,
            new Utils.MultiPath[](0)
        );

        // Test with ERC20 as fromToken
        vm.expectRevert("Router: Incorrect msg.value");
        router.swap{value: 1 ether}(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            1 ether,
            0x6982508145454Ce325dDbE47a25d4ec3d2311933,
            0,
            true,
            0,
            feeReceiver,
            new Utils.MultiPath[](0)
        );
    }
}
