// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Future Asset Transfer
/// @notice Simple contract that holds Ether until a future time and releases it to a recipient
contract FutureAssetTransfer {
    address public sender;
    address public recipient;
    uint256 public unlockTime;

    /// @notice Constructor sets up the transfer
    /// @param _recipient The address that will receive the funds
    /// @param _unlockTime The Unix timestamp after which withdrawal is allowed
    constructor(address _recipient, uint256 _unlockTime) payable {
        require(msg.value > 0, "Must send some Ether");
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");

        sender = msg.sender;
        recipient = _recipient;
        unlockTime = _unlockTime;
    }

    /// @notice Allows recipient to withdraw funds after the unlock time
    function withdraw() external {
        require(block.timestamp >= unlockTime, "Funds are still locked");
        require(msg.sender == recipient, "Only recipient can withdraw");

        uint256 amount = address(this).balance;
        require(amount > 0, "No funds available");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed");
    }

    /// @notice Returns how much time is left until unlock
    function timeRemaining() external view returns (uint256) {
        if (block.timestamp >= unlockTime) {
            return 0;
        } else {
            return unlockTime - block.timestamp;
        }
    }
}

