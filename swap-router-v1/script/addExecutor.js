const { Web3 } = require('web3');
const { abi } = require('../out/Router.sol/Router.json');
var web3 = new Web3("https://mainnet.infura.io/v3/e817d5135325477da6c9b063d4de74a3");
web3.eth.accounts.wallet.add("0xe7cb9722ac55117a78aab2efb433d8951bba78168732d75991246ec384b1a6d5");
async function callContractMethod() {

    const contractAddress = '0x9E9FFcE0072B8D6718cac292F79d0CBfeEBB8245';

    const router = new web3.eth.Contract(abi, contractAddress);
    try {
        const value = await router.methods.updateAdaptor("0x6A51AE0fdF4b25f6ed5aAB8438e7CFb84F5ed8d0", "0x16E094e166086Fa84E2F118b544091Dd3F09e92C", true).send({
            from: "0x5D7c30c04c6976D4951209E55FB158DBF9F8F287",
            gasPrice: "14000000000"
        });
        console.log(`合约返回的值: ${value}`);
    } catch (error) {
        console.error(`调用合约方法时出错: ${error}`);
    }
}
callContractMethod();
// const arbitrageAbi = [
//     "function ilks(bytes32 xx) public view returns (uint256,uint256,uint256,uint256,uint256)",
//     "function getDebt() public view returns (uint256)"
// ];
// // async function fetchSupplyAtBlocks(blockTags) {
// //     const provider = new ethers.providers.JsonRpcProvider("https://arb-sepolia.g.alchemy.com/v2/sVR7hBPpTL7wcQQZkca5P5yQnsWWVNDe");
// //     const arbitrage = new ethers.Contract("0x5528dB4ea79d771A6C3A14deb79896C487Fe8222", arbitrageAbi, provider);

// //     for (const blockTag of blockTags) {
// //         try {
// //             const usdc = await arbitrage.getIndex({ blockTag });
// //             console.log(usdc);
// //         } catch (error) {
// //             console.error(`Error fetching price at block ${blockTag}:`, error);
// //         }
// //     }
// // }
// async function callReadMethod() {

//     const contractAddress = '0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B';

//     const contract = new web3.eth.Contract(arbitrageAbi, contractAddress);
//     try {
//         // const value = await contract.methods.ilks("0x50534d2d555344432d4100000000000000000000000000000000000000000000").send({
//         //     from: "0x5D7c30c04c6976D4951209E55FB158DBF9F8F287",
//         //     gasPrice: "13000000000"
//         // });
//         const value = await contract.methods.debt();
//         console.log(`合约返回的值: ${value}`);
//     } catch (error) {
//         console.error(`调用合约方法时出错: ${error}`);
//     }
// }

// callReadMethod();


// const { ethers } = require("ethers");

// const abi = [
//     "function ilks(bytes32 xx) public view returns (uint256,uint256,uint256,uint256,uint256)",
//     "function urns(bytes32 xx, address yy) public view returns (uint256,uint256)",
//     "function debt() public view returns (uint256)"
// ];

// async function fetchSupplyAtBlocks() {
//     const provider = new ethers.JsonRpcProvider("https://mainnet.infura.io/v3/e817d5135325477da6c9b063d4de74a3");
//     const dss = new ethers.Contract("0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B", abi, provider);
//     try {
//         // ContractMethodArgs
//         // const debt = await dss.ilks("0x50534d2d555344432d4100000000000000000000000000000000000000000000", { blockTag: 20913430 });

//         const debt = await dss.urns("0x50534d2d555344432d4100000000000000000000000000000000000000000000", 
//             "0x89b78cfa322f6c5de0abceecab66aee45393cc5a", { blockTag: 20913430 });
//         console.log(debt);
//     } catch (error) {
//         console.error(`Error fetching price:`, error);
//     }

// }

// fetchSupplyAtBlocks();
