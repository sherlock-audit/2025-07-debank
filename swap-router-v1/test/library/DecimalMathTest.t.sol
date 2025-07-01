/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/

import "../../src/library/SignedDecimalMath.sol";
import "forge-std/Test.sol";

pragma solidity ^0.8.25;

// Check dealer's internal library
contract InternalLibraryTest {

    // add this to be excluded from coverage report
    function test() public {}
    
    function mul(int256 a, int256 b) public pure {
        SignedDecimalMath.decimalMul(a, b);
    }

    function div(int256 a, int256 b) public pure {
        SignedDecimalMath.decimalDiv(a, b);
    }

    function divUint(uint256 a, uint256 b) public pure {
        SignedDecimalMath.decimalDiv(a, b);
    }

    function mulUint(uint256 a, uint256 b) public pure {
        SignedDecimalMath.decimalMul(a, b);
    }

    function abs(int256 a) public pure {
        SignedDecimalMath.abs(a);
    }

    function Remainder(uint256 a, uint256 b) public pure {
        SignedDecimalMath.decimalRemainder(a, b);
    }
}

contract DecimalMathTest is Test {
    InternalLibraryTest public helper;

    function setUp() public {
        helper = new InternalLibraryTest();
    }

    function testMul() public view {
        helper.mul(-2, -2e18);
        helper.mulUint(1, 1e18);
    }

    function testDiv() public view {
        helper.div(-2, -2e18);
        helper.divUint(1, 1e18);
    }

    function testAbs() public view {
        helper.abs(-2);
    }

    function testRemainder() public view {
        helper.Remainder(3, 4);
    }

    function testRemainder2() public view {
        helper.Remainder(3, 4e18);
    }
}
