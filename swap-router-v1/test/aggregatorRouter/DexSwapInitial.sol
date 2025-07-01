/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../src/aggregatorRouter/DexSwap.sol";
import "../../src/aggregatorRouter/adapter/OneinchAdapter.sol";
import "../../src/aggregatorRouter/adapter/MagpieAdapter.sol";
import "../../src/aggregatorRouter/adapter/MachaV2Adapter.sol";
import "../../src/aggregatorRouter/adapter/KyberAdapter.sol";
import "../../src/aggregatorRouter/adapter/ParaswapAdapter.sol";
import "../../src/aggregatorRouter/adapter/UniAdapter.sol";

interface Cheats {
    function expectRevert() external;

    function expectRevert(bytes calldata) external;
}

contract DexSwapInitial is Test {
    // add this to be excluded from coverage report
    function test() public {}

    using SafeERC20 for IERC20;

    Cheats internal constant cheats = Cheats(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    DexSwap public dexSwap;
    OneinchAdapter public oneinchAdapter;
    MagpieAdapter public magpieAdapter;
    MachaV2Adapter public machaV2Adapter;
    KyberAdapter public kyberAdapter;
    UniAdapter public uniAdapter;
    ParaswapAdapter public paraAdapter;

    address public feeReceiver = 0x5D7c30c04c6976D4951209E55FB158DBF9F8F287;
    address[3] public admins =
        [0xE472e1083bd428dC168413840a4949E372086167, address(this), 0x4049C0A9a11816c79c35dC7206bd48301878A735];

    function setUp() public {
        dexSwap = new DexSwap(admins, 1e16);
        oneinchAdapter = new OneinchAdapter(0x111111125421cA6dc452d289314280a0f8842A65, 0x111111125421cA6dc452d289314280a0f8842A65);
        dexSwap.setAdapter("oneinch", address(oneinchAdapter), OneinchAdapter.swapOnAdapter.selector);
        magpieAdapter = new MagpieAdapter(0xA6E941eaB67569ca4522f70d343714fF51d571c4, 0xA6E941eaB67569ca4522f70d343714fF51d571c4);
        dexSwap.setAdapter("magpie", address(magpieAdapter), MagpieAdapter.swapOnAdapter.selector);
        machaV2Adapter = new MachaV2Adapter(0x0000000000001fF3684f28c67538d4D072C22734, 0x0000000000001fF3684f28c67538d4D072C22734);
        dexSwap.setAdapter("machaV2", address(machaV2Adapter), MachaV2Adapter.swapOnAdapter.selector);
        uniAdapter = new UniAdapter(0x000000000022D473030F116dDEE9F6B43aC78BA3, 0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD);
        dexSwap.setAdapter("uni", address(uniAdapter), UniAdapter.swapOnAdapter.selector);
        paraAdapter = new ParaswapAdapter(0x6A000F20005980200259B80c5102003040001068, 0x6A000F20005980200259B80c5102003040001068);
        dexSwap.setAdapter("para", address(paraAdapter), ParaswapAdapter.swapOnAdapter.selector);
        kyberAdapter = new KyberAdapter(0x6131B5fae19EA4f9D964eAc0408E4408b66337b5, 0x6131B5fae19EA4f9D964eAc0408E4408b66337b5);
        dexSwap.setAdapter("kyber", address(kyberAdapter), KyberAdapter.swapOnAdapter.selector);
    }

    receive() external payable {}
}
