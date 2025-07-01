// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../../src/executor/weth/WethExecutor.sol";
import "../../src/library/UniversalERC20.sol";

contract MockWethExecutor is WethExecutor {
    constructor(address _weth) WethExecutor(_weth) {}

    function testSwapOnWeth(address fromToken, address toToken, uint256 fromAmount) external {
        swapOnWeth(fromToken, toToken, fromAmount);
    }
}

contract WethExecutorTest is Test {
    MockWethExecutor public executor;
    address public weth;
    address public otherToken;

    function setUp() public {
        weth = makeAddr("weth");
        otherToken = makeAddr("otherToken");
        executor = new MockWethExecutor(weth);
    }

    function test_InvalidFromToken() public {
        vm.expectRevert("Invalid fromToken");
        executor.testSwapOnWeth(otherToken, UniversalERC20.ETH, 1 ether);
    }
}
