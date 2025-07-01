/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../../executor/algebra/AlgebraV3Executor.sol";
import "../../executor/uniswap/UniswapV2Executor.sol";
import "../../executor/uniswap/UniswapV3Executor.sol";
import "../../executor/uniswap/UniswapV4Executor.sol";
import "../../executor/uniswap/UniswapV3ForkExecutor.sol";
import "../../executor/velodrome/VelodromeExecutor.sol";
import "../../executor/makerpsm/MakerPsmExecutor.sol";
import "../../executor/curve/CurveV1Executor.sol";
import "../../executor/curve/CurveV2Executor.sol";
import "../../executor/balancer/BalancerV1Executor.sol";
import "../../executor/balancer/BalancerV2Executor.sol";
import "../../executor/weth/WethExecutor.sol";
import "../../interface/IAdapter.sol";

contract Adapter1 is
    IAdapter,
    AlgebraV3Executor,
    UniswapV2Executor,
    MakerPsmExecutor,
    CurveV1Executor,
    CurveV2Executor,
    UniswapV3Executor,
    BalancerV1Executor,
    BalancerV2Executor,
    UniswapV3ForkExecutor,
    VelodromeExecutor,
    WethExecutor,
    UniswapV4Executor
{
    using UniversalERC20 for IERC20;
    using SignedDecimalMath for uint256;

    constructor(address _dai, address _weth, address _permit2)
        MakerPsmExecutor(_dai)
        WethExecutor(_weth)
        UniswapV4Executor(_permit2)
    {}

    /**
     * @notice Execute a simple swap
     * @param fromToken The address of the token to swap from
     * @param toToken The address of the token to swap to
     * @param fromTokenAmount The amount of the token to swap from
     * @param swaps The array of swaps to execute
     */
    function executeSimpleSwap(
        address fromToken,
        address toToken,
        uint256 fromTokenAmount,
        Utils.SimpleSwap[] memory swaps
    ) external payable {
        uint256 totalPercent;
        for (uint256 i = 0; i < swaps.length; i++) {
            Utils.SimpleSwap memory swap = swaps[i];
            totalPercent += swap.percent;
            if (swap.swapType == 1) {
                swapUniswapV2(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 2) {
                swapMakerPsm(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 3) {
                swapCurveV1(fromToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 4) {
                swapCurveV2(fromToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 5) {
                swapUniswapV3(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 6) {
                swapVelodrome(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 7) {
                swapBalancerV1(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 8) {
                swapBalancerV2(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 9) {
                swapAlgebraV3(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 10) {
                swapUniswapV3Fork(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else if (swap.swapType == 11) {
                swapOnWeth(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent));
            } else if (swap.swapType == 12) {
                swapUniswapV4(fromToken, toToken, fromTokenAmount.decimalMul(swap.percent), swap.data);
            } else {
                revert("Executor: Invalid swap type");
            }
        }
        require(totalPercent == SignedDecimalMath.ONE, "Adaptor: Invalid total percent");
    }

    receive() external payable {}
}
