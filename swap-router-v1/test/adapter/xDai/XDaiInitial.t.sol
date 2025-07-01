/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../../src/router/Router.sol";
import "../../../src/executor/Executor.sol";
import "../../../src/adapter/xDai/Adapter1.sol";

interface Cheats {
    function expectRevert() external;

    function expectRevert(bytes calldata) external;
}

contract XDaiInitialTest is Test {
    // add this to be excluded from coverage report
    function test() public {}

    using SafeERC20 for IERC20;

    Cheats internal constant cheats = Cheats(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    Executor public executor;
    Router public router;
    Adapter1 public adapter1;
    address public feeReceiver = 0x5D7c30c04c6976D4951209E55FB158DBF9F8F287;
    address[3] public admins =
        [0xE472e1083bd428dC168413840a4949E372086167, address(this), 0x4049C0A9a11816c79c35dC7206bd48301878A735];

    function setUp() public {
        router = new Router(
            // owner
            admins,
            // maxFeeRate
            1e16
        );
        adapter1 = new Adapter1(0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1, 0x000000000022D473030F116dDEE9F6B43aC78BA3);
        router.updateAdaptor(address(adapter1), true);
    }

    receive() external payable {}
}
