/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/

pragma solidity ^0.8.25;

import "../library/UniversalERC20.sol";
import "./error/RouterError.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Spender {
    using UniversalERC20 for IERC20;

    address public immutable dexSwap;

    constructor() {
        dexSwap = msg.sender;
    }

    /// @notice Receive ETH
    receive() external payable {}

    function swap(address adapter, bytes calldata data) external payable {
        if (msg.sender != dexSwap) revert RouterError.Forbidden();
        if (adapter == address(0)) revert RouterError.AdapterNotApproved();
        _delegate(adapter, data, "ADAPTER_DELEGATECALL_FAILED");
    }

    /**
     * @dev Performs a delegatecall and bubbles up the errors, adapted from
     * @param target Address of the contract to delegatecall
     * @param data Data passed in the delegatecall
     * @param errorMessage Fallback revert reason
     */
    function _delegate(address target, bytes memory data, string memory errorMessage) private returns (bytes memory) {
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
