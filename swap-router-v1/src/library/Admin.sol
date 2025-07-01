/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

/**
 * @title Admin
 * @notice This contract is used to manage the admin of the contract
 * @dev This contract implements a safety-focused admin system with the following features:
 *      - Three admins with equal privileges
 *      - Pause/Unpause functionality with multi-admin consensus
 *      - Admin replacement capability
  * 1. Pause Mechanism:
 *    - Any admin can pause the contract independently
 *    - When one admin pauses, they can unpause later
 *    - If two or more admins pause, the contract cannot be unpaused
 *    - Acts as a safety mechanism requiring multi-admin consensus to maintain pause
 *
 * 2. Admin Management:
 *    - Three admin positions (indexed 0-2)
 *    - Each admin can replace themselves with a new address
 *    - Admin replacement requires the admin to not have activated pause
 *
 * 3. State Tracking:
 *    - Maintains individual pause states for each admin
 *    - Tracks total number of active pauses
 *    - Prevents unpause when multiple admins have paused
 */
abstract contract Admin {
    bool public paused;
    uint256 public pauseCount;
    address[3] public admins;
    mapping(address => bool) public adminPaused;

    event Paused(address admin);
    event Unpaused(address admin);
    event AdminUpdated(address indexed oldAdmin, address indexed newAdmin, uint256 indexed index);

    modifier onlyAdmin() {
        require(
            msg.sender == admins[0] || msg.sender == admins[1] || msg.sender == admins[2], "Admin: caller is not admin"
        );
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Admin: paused");
        _;
    }

    constructor(address[3] memory _admins) {
        admins = _admins;
    }

    function pause() external onlyAdmin {
        if (!adminPaused[msg.sender]) {
            adminPaused[msg.sender] = true;
            pauseCount++;
            if (pauseCount > 0 && !paused) {
                paused = true;
            }
            emit Paused(msg.sender);
        }
    }

    function unpause() external onlyAdmin {
        require(pauseCount < 2, "Admin: cannot unpause when multiple admins paused");
        require(pauseCount > 0, "Admin: not paused");
        if (adminPaused[msg.sender]) {
            adminPaused[msg.sender] = false;
        }
        pauseCount--;
        if (pauseCount == 0) {
            paused = false;
        }

        emit Unpaused(msg.sender);
    }

    function updateAdmins(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Admin: new admin cannot be zero address");
        require(
            newAdmin != admins[0] && newAdmin != admins[1] && newAdmin != admins[2], "Admin: new admin already exists"
        );
        require(!adminPaused[msg.sender], "Admin: must unpause before updating admin");

        uint256 adminIndex;
        for (uint256 i = 0; i < 3; i++) {
            if (admins[i] == msg.sender) {
                adminIndex = i;
                break;
            }
        }
        address oldAdmin = admins[adminIndex];
        admins[adminIndex] = newAdmin;
        emit AdminUpdated(oldAdmin, newAdmin, adminIndex);
    }

    function getAdminPauseStates() external view returns (bool[3] memory) {
        bool[3] memory states;
        for (uint256 i = 0; i < 3; i++) {
            states[i] = adminPaused[admins[i]];
        }
        return states;
    }

    function getAdmins() external view returns (address[3] memory) {
        return admins;
    }
}
