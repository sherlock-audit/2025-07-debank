# DexSwap Aggregator Router

the code is in src/aggregatorRouter

## Overview
DexSwap is a DEX (Decentralized Exchange) router that enables efficient token swaps across multiple aggregators. It implements a flexible adapter pattern to support various DEX aggregators while maintaining the fee management capabilities.

## Key Features
- **Multi-Aggregator Support**: Integrates multiple DEX aggregators through a flexible adapter pattern
- **Fee Management**: Configurable fee system supporting both input and output token fee collection
- **Token Support**: Handles both ERC20 tokens and native ETH transactions
- **Security Features**:
  - Reentrancy protection
  - Admin-controlled system with pause mechanism
  - Slippage protection
  - Comprehensive input validation

## Core Components

### DexSwap Contract
address `0x5e99240175e6336795bffa62b14fa32922263cdd`

SwapParams
```solidity
struct SwapParams {
    string aggregatorId;
    address fromToken;
    uint256 fromTokenAmount;
    address toToken;
    uint256 minAmountOut;
    uint256 feeRate;
    bool feeOnFromToken;
    address feeReceiver;
    bytes data;
}
```
The main contract that handles:
- Swap execution and routing
- Fee calculation and collection
- Adapter management

### Spender Contract
address `0xf8a2395604296cc320069fdd81414648e17df503`

A dedicated contract for:
- Executing delegatecall operations to adapters

### Adapter Overview
The system currently supports 6 major DEX aggregators:
- 1inch
- Uniswap Universal Router
- Paraswap
- KyberSwap
- MachaV2
- Magpie

All adapters follow a unified interface pattern and share common functionality:
- Standard `swapOnAdapter` interface for token swaps
- Support for both ERC20 and native ETH
- Built-in security features with ReentrancyGuard
- Automatic token approval management

## Main Functions

### Admin Functions
- `setAdapter`: Register new aggregator adapters
- `removeAdapter`: Remove existing adapters
- `getAdapters`: Retrieve list of registered adapters

### User Functions
- `swap`: Execute token swaps with specified parameters

## Swap Flow
1. Parameter validation
2. Input fee collection (if configured)
3. Token transfer handling
4. Swap execution through adapter
5. Slippage verification
6. Output fee collection (if configured)
7. Final token transfer to user
