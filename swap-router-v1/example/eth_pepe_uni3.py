from web3 import Web3
import eth_abi
import json

with open("Router.json") as f:
    info_json = json.load(f)

router_abi = info_json["abi"]
router_address = "0x7FD9CfEEf127451918c688C49e9905e47DA3E985"

rpc = "https://mainnet.infura.io/v3/e817d5135325477da6c9b063d4de74a3"

web3 = Web3(Web3.HTTPProvider(rpc))

router = web3.eth.contract(address=router_address, abi=router_abi)

executor = "0xFCfc4C87dFc6A42f4cF081477bc9E24Ce249a0Ff"

adapter = "0x651136993aF017Fc242A617D8bF8d4817c0c49A1"

### 换 1eth 到 pepe
# 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE 代表eth
from_token = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE" 

# pepe地址
to_token = "0x6982508145454Ce325dDbE47a25d4ec3d2311933"
# 最小获得的pepe数量
min_amount_out = 10
# 交易手续费 n/1e18
fee_rate = 0  
# 交易手续费接收地址, 按 to token 收取
fee_receiver = "0x5D7c30c04c6976D4951209E55FB158DBF9F8F287"

# 交易路径

e18 = 1000000000000000000
# path0 eth -> pepe , uniswap v3 pool
eth_pepe_swaparg = {
    'router' : "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45",
    'sqrtX96' : 0, 
    'fee' : 3000,
}
data = eth_abi.abi.encode(('address', 'uint160', 'uint24'), [eth_pepe_swaparg['router'], eth_pepe_swaparg['sqrtX96'], eth_pepe_swaparg['fee']])

simple_swap = (e18,5,data) # e18 是percent,n/1e18, 5 是swapType, data 是data

adapter = (adapter,e18,[simple_swap])

single_path = ("0x6982508145454Ce325dDbE47a25d4ec3d2311933",[adapter]) # 0x6982508145454Ce325dDbE47a25d4ec3d2311933 是toToken地址,

multi_path = (e18,[single_path])

result = router.functions.swap(
    executor,
    from_token,
    e18,
    to_token,
    min_amount_out,
    True,
    fee_rate,
    fee_receiver,
    [multi_path]
).estimate_gas({'from': '0xfdA4cCC8dCE3f4b9ACE21d030Ed345e975b8a7B8','value':e18 })

print(result)