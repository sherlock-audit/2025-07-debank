/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../library/UniversalERC20.sol";
import "../../interface/IWETH.sol";
import "./WethAddress.sol";

abstract contract WethExecutor is WethAddress {
    using UniversalERC20 for IERC20;

    constructor(address _weth) WethAddress(_weth) {}

    function swapOnWeth(address fromToken, address toToken, uint256 fromAmount) internal {
        _swapOnWeth(fromToken, toToken, fromAmount);
    }

    function _swapOnWeth(address fromToken, address toToken, uint256 fromAmount) private {
        if (fromToken == WETH) {
            require(toToken == UniversalERC20.ETH, "Destination token should be ETH");
            IWETH(WETH).withdraw(fromAmount);
        } else if (fromToken == UniversalERC20.ETH) {
            require(toToken == WETH, "Destination token should be weth");
            IWETH(WETH).deposit{value: fromAmount}();
        } else {
            revert("Invalid fromToken");
        }
    }
}
