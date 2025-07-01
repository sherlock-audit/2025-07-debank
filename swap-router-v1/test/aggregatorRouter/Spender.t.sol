// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../../src/aggregatorRouter/Spender.sol";
import "../../src/aggregatorRouter/error/RouterError.sol";

contract MockAdapter {
    // add this to be excluded from coverage report
    function test() public {}
    function failWithoutData() external pure {
        revert();
    }
}

contract SpenderTest is Test {
    // add this to be excluded from coverage report
    function test() public {}

    Spender public spender;
    address public dexSwap;
    address public user;
    address public adapter;
    MockAdapter public mockAdapter;

    function setUp() public {
        dexSwap = makeAddr("dexSwap");
        user = makeAddr("user");
        adapter = makeAddr("adapter");
        mockAdapter = new MockAdapter();

        vm.prank(dexSwap);
        spender = new Spender();
    }

    function test_Swap_WithZeroAddressAdapter() public {
        bytes memory data = abi.encodeWithSignature("someFunction()");

        vm.prank(dexSwap);
        vm.expectRevert(RouterError.AdapterNotApproved.selector);
        spender.swap(address(0), data);
    }

    function test_Swap_WithValidAdapter() public {
        bytes memory data = abi.encodeWithSignature("someFunction()");

        vm.prank(dexSwap);
        spender.swap(adapter, data);
    }

    function test_Swap_WithEmptyRevertData() public {
        bytes memory data = abi.encodeWithSignature("failWithoutData()");

        vm.prank(dexSwap);
        vm.expectRevert("ADAPTER_DELEGATECALL_FAILED");
        spender.swap(address(mockAdapter), data);
    }
}
