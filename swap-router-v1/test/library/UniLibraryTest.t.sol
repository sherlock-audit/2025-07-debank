/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/

import "../../src/library/UniswapV2Lib.sol";
import "../../src/library/UniswapV3Lib.sol";
import "forge-std/Test.sol";

pragma solidity ^0.8.25;

// Check dealer's internal library
contract InternalLibraryTest {
    // add this to be excluded from coverage report
    function test() public {}
    function getUniV2AmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint256 fee, // v2 is 3
        uint256 denFee // v2 is 1000
    ) public pure {
        UniswapV2Lib.getAmountOut(amountIn, reserveIn, reserveOut, fee, denFee);
    }
}

interface Cheats {
    function expectRevert() external;

    function expectRevert(bytes calldata) external;
}

contract UniswapTest is Test {
    // add this to be excluded from coverage report
    function test() public {}

    Cheats internal constant cheats = Cheats(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    InternalLibraryTest public helper;

    function setUp() public {
        helper = new InternalLibraryTest();
    }

    function testGetAmountOut() public {
        cheats.expectRevert("UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        helper.getUniV2AmountOut(0, 1, 1, 3, 1000);

        cheats.expectRevert("UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        helper.getUniV2AmountOut(1, 0, 0, 3, 1000);
    }
}
