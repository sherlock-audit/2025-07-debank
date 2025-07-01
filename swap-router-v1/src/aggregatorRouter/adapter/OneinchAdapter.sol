/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../../library/UniversalERC20.sol";

contract OneinchAdapter is ReentrancyGuard {
    address public immutable ONEInch_Approver;
    address public immutable ONEInch_Router;

    using UniversalERC20 for IERC20;
    using SafeERC20 for IERC20;
    using Address for address;
    using Address for address payable;

    constructor(address approver, address router) {
        ONEInch_Approver = approver;
        ONEInch_Router = router;
    }

    function swapOnAdapter(
        address fromToken,
        address toToken,
        address receipent,
        bytes memory data
    ) external payable nonReentrant {
        uint256 fromTokenAmount = IERC20(fromToken).universalBalanceOf(address(this));
        if (fromToken != UniversalERC20.ETH) {
            // approve
            IERC20(fromToken).forceApprove(ONEInch_Approver, fromTokenAmount);
            ONEInch_Router.functionCallWithValue(data, 0);
        } else {
            // For ETH, use fromTokenAmount instead of msg.value to handle fee deduction
            ONEInch_Router.functionCallWithValue(data, fromTokenAmount);
        }

        // transfer remaining fromTokens back to receipent
        uint256 fromTokenBalance = IERC20(fromToken).universalBalanceOf(address(this));
        if (fromTokenBalance > 0) {
            IERC20(fromToken).universalTransfer(payable(receipent), fromTokenBalance);
        }

        // transfer all received toTokens back to caller (Spender -> DexSwap)
        uint256 toTokenBalance = IERC20(toToken).universalBalanceOf(address(this));
        if (toTokenBalance > 0) {
            IERC20(toToken).universalTransfer(payable(msg.sender), toTokenBalance);
        }
    }
}
