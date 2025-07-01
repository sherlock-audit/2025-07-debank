/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../library/UniversalERC20.sol";
import "../../interface/ICurveV1.sol";

struct CurveV1SwapArg {
    address pool;
    int128 i;
    int128 j;
    // 0: exchange, 1: exchange_underlying, 2: remove_liquidity_one_coin,
    uint8 curveV1SwapType;
}

abstract contract CurveV1Executor {
    using SafeERC20 for IERC20;

    function swapCurveV1(address fromToken, uint256 fromTokenAmount, bytes memory payload) internal {
        CurveV1SwapArg memory arg = abi.decode(payload, (CurveV1SwapArg));
        address pool = arg.pool;
        int128 i = arg.i;
        int128 j = arg.j;
        uint8 curveV1SwapType = arg.curveV1SwapType;
        IERC20(fromToken).forceApprove(pool, fromTokenAmount);

        if (curveV1SwapType == 0) {
            ICurveV1Pool(pool).exchange(i, j, fromTokenAmount, 0);
        } else if (curveV1SwapType == 1) {
            ICurveV1Pool(pool).exchange_underlying(i, j, fromTokenAmount, 0);
        } else if (curveV1SwapType == 2) {
            ICurveV1Pool(pool).remove_liquidity_one_coin(fromTokenAmount, i, 0);
        } else {
            revert("CurveV1Executor: Invalid swap type");
        }
    }
}
