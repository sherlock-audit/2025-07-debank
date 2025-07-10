# DeBank contest details

- Join [Sherlock Discord](https://discord.gg/MABEWyASkp)
- Submit findings using the **Issues** page in your private contest repo (label issues as **Medium** or **High**)
- [Read for more details](https://docs.sherlock.xyz/audits/watsons)

# Q&A

### Q: On what chains are the smart contracts going to be deployed?
Ethereum, Optimism, Arbitrum, Fantom, Cronos, Polygon, BNB Smart Chain, Base, zkSync Era, Linea, Avalanche, Scroll, Blast, Mantle, Sonic, Berachain, Hyperliquid L1 

___

### Q: If you are integrating tokens, are you allowing only whitelisted tokens to work with the codebase or any complying with the standard? Are they assumed to have certain properties, e.g. be non-reentrant? Are there any types of [weird tokens](https://github.com/d-xo/weird-erc20) you want to integrate?
Consider a token to be valid if it has over 500,000 USDC in liquidity on any one of the following DEXs: Uniswap V2–V4, Balancer V1–V2, Curve V1–V2, Maker PSM, Velodrome, Algebra, 1inch V6, Matcha V2, Paraswap V6, KyberSwap, or Magpie V3. Including any weird token if they qualify for the liquidity requirement.
___

### Q: Are there any limitations on values set by admins (or other roles) in the codebase, including restrictions on array lengths?
The admin is considered trusted, but we want to make sure that, if the admin account/key were ever compromised, any resulting damage to the protocol would remain within controllable limits. If the malicious actor can steal users' hanging approvals (e.g. a user approved the in-scope code to spend type(uint256).max tokens, and the malicious actor can steal them after getting the admin's key/account), then it's considered a valid issue with Medium impact. Any other damage that the malicious actor can inflict on the protocol with compromised admin keys/accounts is considered acceptable.

___

### Q: Are there any limitations on values set by admins (or other roles) in protocols you integrate with, including restrictions on array lengths?
No
___

### Q: Is the codebase expected to comply with any specific EIPs?
ERC20
___

### Q: Are there any off-chain mechanisms involved in the protocol (e.g., keeper bots, arbitrage bots, etc.)? We assume these mechanisms will not misbehave, delay, or go offline unless otherwise specified.
We handle route finding off‑chain and perform settlement on‑chain; this part is considered trusted.
___

### Q: What properties/invariants do you want to hold even if breaking them has a low/unknown impact?
no
___

### Q: Please discuss any design choices you made.
1. Admin Pause Mechanism(Dexswap/Router):
 *    - Any admin can pause the contract independently
 *    - When one admin pauses, they can unpause later
 *    - If two or more admins pause, the contract cannot be unpaused
2.  Potential protocol fee revenue loss(Dexswap/Router):
-    We do not treat these two points as vulnerabilities. Allowing the caller to set feeRate (up to maxFeeRate) and choose any feeReceiver is an intentional part of the design: the protocol is meant to be used through our trusted front-end, which always supplies safe values. If someone bypasses the front-end and crafts their own calldata, that lies outside the guarantees we provide.
___

### Q: Please provide links to previous audits (if any) and all the known issues or acceptable risks.
1.Missing check on the fromToken parameter
In the Executor contracts, before performing an external token swap operation, the forceApprove function will be called first to authorize the external router contract for the tokens. However, before this, it does not check whether the incoming fromToken parameter is ETH. If fromToken is ETH, directly calling the forceApprove function for authorization will result in an error and a revert, preventing the token swap from proceeding normally.
Answer: We acknowledge this, but ETH swaps are handled in WethExecutor.sol.

2. The feeRate parameter in the swap function can be set arbitrarily. As long as it is smaller than the maximum value(maxFeeRate), it will be accepted. This enables users to always set the fee as low as possible (even zero), thus significantly reducing the fee income of the protocol.
Answer: We acknowledge this, but we do not consider it a valid issue.

3. In the Router contract, Each time the swap function is called for a token transaction, a portion of the handling fee is collected and given to the feeReceiver address. Normally, this address should be that of the protocol's official side. However, in the swap function, there is no check on the feeReceiver address, and it can be arbitrarily input from the outside. This means that users can input their own addresses to steal the handling fee income that should belong to the protocol.
Answer: We acknowledge this.

4. In the Admin contract, there are three administrators who can call the pause and unpause functions. Each time an administrator calls the pause function, the pauseCount is incremented. However, in the unpause function, the check can only pass and the function can only be called when the pauseCount is less than 2. This means that if two administrators call the pause function simultaneously(either without prior communication with each other or in case of permission theft), the unpause function can never be called to lift the contract's paused state, and the contract will be permanently paused and unusable.
Answer: We acknowledge this.

___

### Q: Please list any relevant protocol resources.
https://github.com/DeBankDeFi/swap-router-v1/blob/master/DEXSWAPREADME.md
https://github.com/DeBankDeFi/swap-router-v1/blob/master/ROUTERREADME.md


___

### Q: Additional audit information.
Contains two parts
1. https://github.com/DeBankDeFi/swap-router-v1/blob/master/src/aggregatorRouter/DexSwap.sol, this is dexSwap, similar to metamask swap, after constructing calldata off-chain, make any call to any aggregator to complete the swap transaction, each aggregator is in https://github.com/DeBankDeFi/swap-router-v1/tree/master/src/aggregatorRouter/adapter, readme: https://github.com/DeBankDeFi/swap-router-v1/blob/master/DEXSWAPREADME.md
2. This is our self-developed aggregator router (https://github.com/DeBankDeFi/swap-router-v1/blob/master/src/router/Router.sol ), which will be connected as the adapter of dexSwap later, involving executor and corresponding pool adapter, readme: https://github.com/DeBankDeFi/swap-router-v1/blob/master/ROUTERREADME.md


# Audit scope

[swap-router-v1 @ 5b133bfb0a774baf715559d423e6ae20554e2408](https://github.com/DeBankDeFi/swap-router-v1/tree/5b133bfb0a774baf715559d423e6ae20554e2408)
- [swap-router-v1/src/adapter/mainnet/Adapter1.sol](swap-router-v1/src/adapter/mainnet/Adapter1.sol)
- [swap-router-v1/src/adapter/xDai/Adapter1.sol](swap-router-v1/src/adapter/xDai/Adapter1.sol)
- [swap-router-v1/src/aggregatorRouter/DexSwap.sol](swap-router-v1/src/aggregatorRouter/DexSwap.sol)
- [swap-router-v1/src/aggregatorRouter/Spender.sol](swap-router-v1/src/aggregatorRouter/Spender.sol)
- [swap-router-v1/src/aggregatorRouter/adapter/KyberAdapter.sol](swap-router-v1/src/aggregatorRouter/adapter/KyberAdapter.sol)
- [swap-router-v1/src/aggregatorRouter/adapter/MachaV2Adapter.sol](swap-router-v1/src/aggregatorRouter/adapter/MachaV2Adapter.sol)
- [swap-router-v1/src/aggregatorRouter/adapter/MagpieAdapter.sol](swap-router-v1/src/aggregatorRouter/adapter/MagpieAdapter.sol)
- [swap-router-v1/src/aggregatorRouter/adapter/OneinchAdapter.sol](swap-router-v1/src/aggregatorRouter/adapter/OneinchAdapter.sol)
- [swap-router-v1/src/aggregatorRouter/adapter/ParaswapAdapter.sol](swap-router-v1/src/aggregatorRouter/adapter/ParaswapAdapter.sol)
- [swap-router-v1/src/aggregatorRouter/adapter/UniAdapter.sol](swap-router-v1/src/aggregatorRouter/adapter/UniAdapter.sol)
- [swap-router-v1/src/aggregatorRouter/error/RouterError.sol](swap-router-v1/src/aggregatorRouter/error/RouterError.sol)
- [swap-router-v1/src/executor/Executor.sol](swap-router-v1/src/executor/Executor.sol)
- [swap-router-v1/src/executor/algebra/AlgebraV3Executor.sol](swap-router-v1/src/executor/algebra/AlgebraV3Executor.sol)
- [swap-router-v1/src/executor/algebra/IAlgebraV3Router.sol](swap-router-v1/src/executor/algebra/IAlgebraV3Router.sol)
- [swap-router-v1/src/executor/balancer/BalancerV1Executor.sol](swap-router-v1/src/executor/balancer/BalancerV1Executor.sol)
- [swap-router-v1/src/executor/balancer/BalancerV2Executor.sol](swap-router-v1/src/executor/balancer/BalancerV2Executor.sol)
- [swap-router-v1/src/executor/curve/CurveV1Executor.sol](swap-router-v1/src/executor/curve/CurveV1Executor.sol)
- [swap-router-v1/src/executor/curve/CurveV2Executor.sol](swap-router-v1/src/executor/curve/CurveV2Executor.sol)
- [swap-router-v1/src/executor/makerpsm/MakerPsmExecutor.sol](swap-router-v1/src/executor/makerpsm/MakerPsmExecutor.sol)
- [swap-router-v1/src/executor/uniswap/IUniswapV3Router.sol](swap-router-v1/src/executor/uniswap/IUniswapV3Router.sol)
- [swap-router-v1/src/executor/uniswap/IUniversalRouter.sol](swap-router-v1/src/executor/uniswap/IUniversalRouter.sol)
- [swap-router-v1/src/executor/uniswap/UniswapV2Executor.sol](swap-router-v1/src/executor/uniswap/UniswapV2Executor.sol)
- [swap-router-v1/src/executor/uniswap/UniswapV3Executor.sol](swap-router-v1/src/executor/uniswap/UniswapV3Executor.sol)
- [swap-router-v1/src/executor/uniswap/UniswapV3ForkExecutor.sol](swap-router-v1/src/executor/uniswap/UniswapV3ForkExecutor.sol)
- [swap-router-v1/src/executor/uniswap/UniswapV4Executor.sol](swap-router-v1/src/executor/uniswap/UniswapV4Executor.sol)
- [swap-router-v1/src/executor/velodrome/IVelodromeRouter.sol](swap-router-v1/src/executor/velodrome/IVelodromeRouter.sol)
- [swap-router-v1/src/executor/velodrome/VelodromeExecutor.sol](swap-router-v1/src/executor/velodrome/VelodromeExecutor.sol)
- [swap-router-v1/src/executor/weth/WethAddress.sol](swap-router-v1/src/executor/weth/WethAddress.sol)
- [swap-router-v1/src/executor/weth/WethExecutor.sol](swap-router-v1/src/executor/weth/WethExecutor.sol)
- [swap-router-v1/src/library/Admin.sol](swap-router-v1/src/library/Admin.sol)
- [swap-router-v1/src/library/SignedDecimalMath.sol](swap-router-v1/src/library/SignedDecimalMath.sol)
- [swap-router-v1/src/library/UniswapV2Lib.sol](swap-router-v1/src/library/UniswapV2Lib.sol)
- [swap-router-v1/src/library/UniswapV3Lib.sol](swap-router-v1/src/library/UniswapV3Lib.sol)
- [swap-router-v1/src/library/UniversalERC20.sol](swap-router-v1/src/library/UniversalERC20.sol)
- [swap-router-v1/src/library/Utils.sol](swap-router-v1/src/library/Utils.sol)
- [swap-router-v1/src/router/Router.sol](swap-router-v1/src/router/Router.sol)


