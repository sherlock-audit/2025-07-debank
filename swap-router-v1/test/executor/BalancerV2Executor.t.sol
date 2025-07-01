/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../Initial.t.sol";

contract BalancerV2ExecutorTest is InitialTest {
    using SafeERC20 for IERC20;

    function testBalancerV2WethToCow() public {
        BalancerV2Param memory arg = BalancerV2Param(
            0xde8c195aa41c11a0c4787372defbbddaa31306d2000200000000000000000181,
            0xBA12222222228d8Ba445958a75a0704d566BF2C8
        );
        bytes memory payload = abi.encode(arg);
        Utils.SimpleSwap[] memory swaps = new Utils.SimpleSwap[](1);
        Utils.SimpleSwap memory simpleSwap = Utils.SimpleSwap(1e18, 8, payload);
        swaps[0] = simpleSwap;
        Utils.Adapter[] memory adapters = new Utils.Adapter[](1);
        Utils.Adapter memory adapter = Utils.Adapter(payable(adapter1), 1e18, swaps);
        adapters[0] = adapter;
        Utils.SinglePath memory singlePath0 = Utils.SinglePath(0xDEf1CA1fb7FBcDC777520aa7f396b4E015F497aB, adapters);
        Utils.SinglePath[] memory singlePaths = new Utils.SinglePath[](1);
        singlePaths[0] = singlePath0;
        Utils.MultiPath memory multiPath = Utils.MultiPath(1e18, singlePaths);
        Utils.MultiPath[] memory multiPaths = new Utils.MultiPath[](1);
        multiPaths[0] = multiPath;

        deal(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this), 5e17);
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).forceApprove(address(router), 5e17);
        uint256 cowBalanceBefore = IERC20(0xDEf1CA1fb7FBcDC777520aa7f396b4E015F497aB).balanceOf(address(this));
        console.log("cowBalanceBefore: ", cowBalanceBefore);
        router.swap(
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            5e17,
            0xDEf1CA1fb7FBcDC777520aa7f396b4E015F497aB,
            2000e18,
            false,
            0,
            feeReceiver,
            multiPaths
        );
        uint256 cowBalanceAfter = IERC20(0xDEf1CA1fb7FBcDC777520aa7f396b4E015F497aB).balanceOf(address(this));
        uint256 ethBalanceAfter = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balanceOf(address(this));
        console.log("cowBalanceAfter: ", cowBalanceAfter);
        console.log("ethBalanceAfter: ", ethBalanceAfter);
        assertEq(ethBalanceAfter, 0);
    }
}
