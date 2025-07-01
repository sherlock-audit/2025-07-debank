# DEX Aggregator

This is our self-developed DEX aggregator that will be integrated into the DexSwap system as one of its supported aggregators. While DexSwap serves as a high-level router supporting multiple third-party aggregators (like 1inch, Paraswap, etc.), this aggregator provides our own optimized routing solution with direct DEX integrations.

## Introduction
The DEX Aggregator is a smart contract system designed to optimize decentralized trading by finding and executing the best trading routes across multiple decentralized exchanges (DEXs). It splits orders across different DEXs to achieve better prices and lower slippage for traders.

## Key Features
- **Smart Route Optimization**: Automatically finds the most efficient trading paths across multiple DEXs
- **Split Orders**: Divides large trades across multiple DEXs to minimize price impact
- **Price Protection**: Implements slippage protection mechanisms
- **Multi-DEX Support**: Integrates with major DEXs including:
  - Uniswap V2/V3/V4,V3 fork
  - Curve V1/V2
  - Balancer V1/V2
  - Velodrome, AlgebraV3
  - psm

## Architecture
The aggregator consists of three main components:
1. **Router Contract**: Manages trade execution and fund distribution
2. **Adapter Layer**: Standardizes interactions with different DEX protocols
3. **Executor**: Calculates optimal trading routes and split ratios

## How It Works
1. User submits a trade request (fromToken -> toToken)
2. System calculates the best route splitting across multiple DEXs
3. Smart contract executes the trades in optimal order
4. Tokens are returned to the user with the best possible rate

## Testing
```bash
forge test -f https://eth-mainnet.g.alchemy.com/v2/bCFoydH4fM5Ks1F7SGw0Ev8261x_cldj -vvv
```

## Deployment
```bash
forge script script/Deploy.s.sol --sig "deploy()"  --rpc-url https://eth-mainnet.g.alchemy.com/v2/bCFoydH4fM5Ks1F7SGw0Ev8261x_cldj  --private-key <key> --broadcast -vvvv 
```

## Router Addresses
Eth: `0x58bb067D621E6b7DF3Aae64c0975388eDCEa16De`

## Router Entry Parameters
All ETH swaps are converted to WETH at the top level, so the underlying SimpleSwap operations are all WETH swaps. The system will determine whether to unwrap/wrap based on the circumstances.

```solidity
    // @dev MultiPath represents a swap from A->B->C..->D, going through multiple SinglePaths
    struct MultiPath {
        uint256 percent; // based 1e18
        SinglePath[] paths;
    }

    // @dev SinglePath represents a swap from A->B, without intermediate paths
    // but can split funds to use multiple DEXes
    // fromToken is obtained through MultiPath
    struct SinglePath {
        address toToken;
        Adapter[] adapters;
    }

    struct Adapter {
        address payable adapter;
        uint256 percent; // based 1e18
        SimpleSwap[] swaps; // All are A->B swaps but through different DEXes
    }

    // @dev SimpleSwap represents a single A->B swap through a specific DEX
    struct SimpleSwap {
        uint256 percent; // based 1e18
        uint256 swapType;
        bytes data; // dex swap data
    }

    function swap(
        address fromToken, // Source token
        uint256 fromTokenAmount, // Amount of source token
        address toToken, // Destination token
        uint256 minAmountOut, // Minimum output amount
        bool feeOnFromToken, // Whether fee is taken from source token
        uint256 feeRate, // Fee rate based on 1e18
        address feeReceiver, // Fee recipient address
        MultiPath[] calldata paths // Swap paths
    ) external payable
```

## Executor Addresses
ETH: `0x702Fb35940FDd450d4b07EbB3EfFAC7A6a106D16`

## Adapter Addresses
ETH: `0xA637e63d8a8b4c77523424dE638E03D148084803`

## SimpleSwap Construction

Currently supported exchanges:
swapType remains consistent across different chains.

### Uniswap V2
* swapType==1
```solidity
struct UniswapV2SwapArg {
    address pool; // Uniswap V2 pool address
    uint256 fee; // Fee numerator, default 3 for Uniswap V2
    uint256 denFee; // Fee denominator, default 1000 for Uniswap V2 (0.3% fee)
}
```
For Uniswap V2, a pool is determined by fromToken-toToken pair

### MakerPSM
* swapType==2, Stablecoin swap without slippage
```solidity
struct MakerPsmData {
    address sellGemApproveAddress; // Approval address before calling sellGem. For litePsm, this is the PSM address; for regular PSM, this is the gemJoin address
    address psm; // PSM address
    uint256 toll; // toll as maker psm tout
    uint256 to18ConversionFactor; // 1e12
}
```
Currently only supports USDC-DAI fixed-rate swaps. fromToken and toToken must be either DAI or USDC

### CurveV1
* swapType==3
```solidity
struct CurveV1SwapArg {
    address pool; // Curve V1 pool address
    int128 i; // fromToken index in pool, for curveV1SwapType = 2, i represents toToken index
    int128 j; // toToken index in pool
    uint8 curveV1SwapType; // 0: exchange, 1: exchange_underlying, 2: remove_liquidity_one_coin
}
```

### CurveV2
* swapType==4
```solidity
struct CurveV2SwapArg {
    address pool; // Curve V2 pool address
    uint256 i; // fromToken index in pool, for curveV2SwapType = 3, i represents toToken index; for curveV2SwapType = 4, i represents the index of token to add in amounts array
    uint256 j; // toToken index in pool
    address originalPoolAddress; // for GenericFactoryZap
    uint8 curveV2SwapType; // 0: exchange, 1: exchange_underlying, 2: GenericFactoryZap, 3: remove_liquidity_one_coin, 4: add_liquidity
    uint8 N_COINS;
}
```

### Uniswap V3
* swapType==5
```solidity
struct UniswapV3Data {
    address router; // Router02 address
    uint160 sqrtX96; // Can be 0, uses default if 0
    uint24 fee; // Fee
}
```
For Uniswap V3, a pool is determined by fromToken-toToken-fee

### Velodrome
* swapType==11
```solidity
struct VelodromeData {
    address router;
    uint160 sqrtX96;
    int24 tickSpacing;
}
```

### BalancerV1
* swapType==7
SimpleSwap.data only needs pool address

### BalancerV2
* swapType==8
```solidity
struct BalancerV2Param {
    bytes32 poolId;
    address pool;
}
```

### AlgebraV3
* swapType==9
```solidity
struct AlgebraV3Data {
    address router;
    uint160 sqrtX96;
}
```

### Uniswap V3 Fork
* swapType==10
```solidity
struct UniswapV3Data {
    address router; // Router address
    uint160 sqrtX96; // Can be 0, uses default if 0
    uint24 fee; // Fee
}
```

### Weth wrap and unwrap
* swapType==11
Do not need to pass SimpleSwap.data

### UniswapV4
* swapType==12
```solidity
struct UniswapV4Data {
    address router; // router of uniswap, UniversalRouter
    PoolKey poolKey;
    bytes hookData;
}
struct PoolKey {
    /// @notice The lower currency of the pool, sorted numerically
    Currency currency0;
    /// @notice The higher currency of the pool, sorted numerically
    Currency currency1;
    /// @notice The pool LP fee, capped at 1_000_000. If the highest bit is 1, the pool has a dynamic fee and must be exactly equal to 0x800000
    uint24 fee;
    /// @notice Ticks that involve positions must be a multiple of tick spacing
    int24 tickSpacing;
    /// @notice The hooks of the pool
    IHooks hooks;
}
```



## Examples
### test/Router.sol
[test/Router.sol](test/Router.t.sol) is the test contract for the Router contract. It tests WETH -> PEPE swap, including:
* 60% WETH -> PEPE
    * 50% Uniswap V2
    * 50% Uniswap V3
* 40% WETH -> USDC -> PEPE

### Web3.py Example
[example/eth_pepe.py](example/eth_pepe.py) is an example showing how to construct a transaction

### Fee
feeReceiver = 0x5D7c30c04c6976D4951209E55FB158DBF9F8F287
