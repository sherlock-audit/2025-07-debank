from web3 import Web3
import eth_abi
import json

with open("Router.json") as f:
    info_json = json.load(f)

router_abi = info_json["abi"]
router_address = "0x8078cbc8E705097B726C9B951BFE7C29c65b4a8F"

rpc = "https://mainnet.infura.io/v3/e817d5135325477da6c9b063d4de74a3"

web3 = Web3(Web3.HTTPProvider(rpc))

router = web3.eth.contract(address=router_address, abi=router_abi)

executor = "0xe6ECaf3E2b9DE4a7f8084061F3a6E17b4564fF31"

adapter = "0xE411F6C9aEae5Af6194555c2439a9fa07d6Cc2C9"

### 换1000 gwei eth到usdt
# 整个swap的from_token
# 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE 代表eth
from_token = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE" 
# eth数量 
from_token_amount = web3.to_wei(1000, 'gwei') 
# usdt地址
to_token = "0xdAC17F958D2ee523a2206206994597C13D831ec7"
# 最小获得的usdt数量
min_amount_out = 0
# 交易手续费 n/1e18
fee_rate = 0  
# 交易手续费接收地址, 按 to token 收取
fee_receiver = "0x5D7c30c04c6976D4951209E55FB158DBF9F8F287"

# 交易路径
e18 = 1000000000000000000

multi_path = (e18,[])
# path0 eth -> usdt , uniswap v3 pool
eth_usdt_swaparg = {
    'fromToken' : "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    'toToken' : "0xdAC17F958D2ee523a2206206994597C13D831ec7",
    'pool' : "0xc7bbec68d12a0d1830360f8ec58fa599ba1b0e9b",
    'sqrtX96' : 0,
    'fee' : 100,
}
data = eth_abi.abi.encode(('address', 'address', 'address','uint160', 'uint24'), [eth_usdt_swaparg['fromToken'], eth_usdt_swaparg['toToken'], eth_usdt_swaparg['pool'],eth_usdt_swaparg['sqrtX96'], eth_usdt_swaparg['fee']])

simple_swap = (e18,5,data) # e18 是percent,n/1e18, 5 是swapType, data 是data

adapter = (adapter,e18,[simple_swap])

single_path = ("0xdAC17F958D2ee523a2206206994597C13D831ec7",[adapter]) 

multi_path = (e18,[single_path])

result = router.functions.swap(
    executor,
    from_token,
    from_token_amount,
    to_token,
    min_amount_out,
    False,
    fee_rate,
    fee_receiver,
    [multi_path]
).estimate_gas({'from': '0xfdA4cCC8dCE3f4b9ACE21d030Ed345e975b8a7B8','value':web3.to_wei(1000, 'gwei') })

print(result)