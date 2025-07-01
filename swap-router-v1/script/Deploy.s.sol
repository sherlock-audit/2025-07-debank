// /*
//     Copyright Debank
//     SPDX-License-Identifier: BUSL-1.1
// */
// pragma solidity ^0.8.25;

// import {Script, console} from "forge-std/Script.sol";
// import {Router} from "../src/Router.sol";
// import {Executor} from "../src/executor/Executor.sol";
// // import {XDaiAdapter1} from "../src/adapter/XDai/Adapter1.sol";
// import {Adapter1} from "../src/adapter/mainnet/Adapter1.sol";
// // import {Adapter1} from "../src/adapter/unichain/Adapter1.sol";

// contract Deploy is Script {
//     // add this to be excluded from coverage report
//     function test() public {}

//     modifier broadcast() {
//         vm.startBroadcast(msg.sender);
//         _;
//         vm.stopBroadcast();
//     }

//     function deployRouter(address _weth) public broadcast returns (address addr_) {
//         address[3] memory admins = [
//             address(msg.sender),
//             0x6De8148Dad080548bd2D0C5a294549438aD5EFfD,
//             0xfdA4cCC8dCE3f4b9ACE21d030Ed345e975b8a7B8
//         ];
//         console.log("Deploying Router");
//         Router router = new Router(admins, _weth, 8.75e15);
//         addr_ = address(router);
//     }

//     function routerAddExecutorAndAdaptor(address router, address executor, address adapter) public broadcast {
//         console.log("Adding Executor to Router");
//         Router(payable(router)).updateExecutor(executor, true);
//         Router(payable(router)).updateAdaptor(executor, address(adapter), true);
//     }

//     function deployExector(address router) public broadcast returns (address addr_) {
//         console.log("Deploying Exector");
//         Executor executor = new Executor(address(router));
//         addr_ = address(executor);
//     }

//     // function deployXDaiAdaptor() public broadcast returns (address addr_) {
//     //     console.log("Deploying XDai Adaptor");
//     //     Adapter1 adapter1 = new Adapter1();
//     //     addr_ = address(adapter1);
//     // }

//     function deployETHAdaptor(address dai) public broadcast returns (address addr_) {
//         console.log("Deploying ETH Adaptor");
//         Adapter1 adapter1 = new Adapter1(dai);
//         addr_ = address(adapter1);
//     }

//     // function deployUnichainAdaptor() public broadcast returns (address addr_) {
//     //     console.log("Deploying Unichain Adaptor");
//     //     Adapter1 adapter1 = new Adapter1();
//     //     addr_ = address(adapter1);
//     // }

//     function deploy() public {
//         address router = deployRouter(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
//         address executor = deployExector(router);
//         address adapter = deployETHAdaptor(0x6B175474E89094C44Da98b954EedeAC495271d0F);
//         routerAddExecutorAndAdaptor(router, executor, adapter);
//     }
// }
