/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../interface/IMakerPSM.sol";
import "../../library/SignedDecimalMath.sol";

abstract contract MakerPsmExecutor {
    using SafeERC20 for IERC20;
    using SignedDecimalMath for uint256;

    struct MakerPsmData {
        address sellGemApproveAddress; // in litePsm, it is the same as psm; in orginal psm, it is the address of gemJoin
        address psm; 
        uint256 toll; // as maker psm tout
        uint256 to18ConversionFactor;
    }

    address public immutable dai;

    constructor(address _dai) {
        dai = _dai;
    }

    function swapMakerPsm(address fromToken, address toToken, uint256 fromTokenAmount, bytes memory data) internal {
        MakerPsmData memory psmData = abi.decode(data, (MakerPsmData));
        if (toToken == dai) {
            // usdc to buy dai
            IERC20(fromToken).forceApprove(psmData.sellGemApproveAddress, fromTokenAmount);
            IMakerPSM(psmData.psm).sellGem(address(this), fromTokenAmount);
        } else if (fromToken == dai) {
            // dai buy usdc
            IERC20(fromToken).forceApprove(psmData.psm, fromTokenAmount);
            uint256 gemAmt =
                fromTokenAmount.decimalDiv((SignedDecimalMath.ONE + psmData.toll) * psmData.to18ConversionFactor);
            IMakerPSM(psmData.psm).buyGem(address(this), gemAmt);
        } else {
            revert("MakerPsmExecutor: Invalid token");
        }
    }
}
