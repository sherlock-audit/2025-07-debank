/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "../library/Utils.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IExecutor {
    /**
     * @notice Execute a mega swap
     * @param fromToken The address of the token to swap from
     * @param toToken The address of the token to swap to
     * @param paths The array of paths to swap
     */
    function executeMegaSwap(IERC20 fromToken, IERC20 toToken, Utils.MultiPath[] calldata paths) external payable;

    function updateAdaptor(address _adapter, bool isAdd) external;

    function getAdapters() external view returns (address[] memory);
}
