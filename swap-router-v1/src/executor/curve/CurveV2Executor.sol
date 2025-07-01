/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../../library/UniversalERC20.sol";
import "../../interface/ICurveV2.sol";

struct CurveV2SwapArg {
    address pool;
    // curveV2SwapType = 3，i represent toToken'index; curveV2SwapType = 4,i represents the subscript of the token that needs to be added in the amounts array.
    uint256 i;
    uint256 j;
    address originalPoolAddress; // for GenericFactoryZap
    // 0: exchange, 1: exchange_underlying, 2: GenericFactoryZap, 3: remove_liquidity_one_coin, 4: add_liquidity
    uint8 curveV2SwapType;
    uint8 N_COINS;
}

abstract contract CurveV2Executor {
    using SafeERC20 for IERC20;

    function swapCurveV2(address fromToken, uint256 fromTokenAmount, bytes memory payload) internal {
        CurveV2SwapArg memory arg = abi.decode(payload, (CurveV2SwapArg));
        address pool = arg.pool;
        uint256 i = arg.i;
        uint256 j = arg.j;
        address originalPoolAddress = arg.originalPoolAddress;
        uint8 curveV2SwapType = arg.curveV2SwapType;
        uint8 N_COINS = arg.N_COINS;

        IERC20(fromToken).forceApprove(pool, fromTokenAmount);

        if (curveV2SwapType == 0) {
            ICurveV2Pool(pool).exchange(i, j, fromTokenAmount, 0);
        } else if (curveV2SwapType == 1) {
            ICurveV2Pool(pool).exchange_underlying(i, j, fromTokenAmount, 0);
        } else if (curveV2SwapType == 2) {
            IGenericFactoryZap(pool).exchange(originalPoolAddress, i, j, fromTokenAmount, 0);
        } else if (curveV2SwapType == 3) {
            ICurveV2Pool(pool).remove_liquidity_one_coin(fromTokenAmount, i, 0);
        } else if (curveV2SwapType == 4 && N_COINS == 2) {
            uint256[2] memory inputAmount;
            inputAmount[i] = fromTokenAmount;
            ICurveV2Pool(pool).add_liquidity(inputAmount, 0);
        } else if (curveV2SwapType == 4 && N_COINS == 3) {
            uint256[3] memory inputAmount;
            inputAmount[i] = fromTokenAmount;
            ICurveV2Pool(pool).add_liquidity(inputAmount, 0);
        } else if (curveV2SwapType == 4 && N_COINS == 4) {
            uint256[4] memory inputAmount;
            inputAmount[i] = fromTokenAmount;
            ICurveV2Pool(pool).add_liquidity(inputAmount, 0);
        } else {
            revert("CurveV2Executor: Invalid swap type");
        }
    }
}
