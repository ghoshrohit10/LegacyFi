# 🔒 Future Asset Transfer Smart Contract

<img width="1226" height="2360" alt="celo-sepolia blockscout com_tx_0x409967cdaf383b5b5fccc316408192ea244c47af2d213d45ace236d7f01c8b89" src="https://github.com/user-attachments/assets/d51310e1-0737-4828-839d-ed308b7b7637" />


### 🪙 Project Description  
**Future Asset Transfer** is a simple Ethereum smart contract that enables **automatic, time-locked transfers** of Ether (ETH). It allows a sender to securely deposit funds that can only be withdrawn by a designated recipient **after a specific future date/time**.  

This project is perfect for beginners exploring **Solidity**, **smart contract automation**, and **future asset management** on the blockchain.

---

## 💡 What It Does
This smart contract:
1. Accepts a deposit of Ether during deployment.  
2. Locks the funds until a defined future timestamp (`unlockTime`).  
3. Allows the specified recipient to **withdraw the Ether** once the unlock time has passed.  
4. Prevents anyone (including the sender) from withdrawing before the time lock expires.

It’s a great starting point for use cases like:
- 🔐 **Trustless escrow**
- 🕐 **Time-delayed inheritance**
- 💰 **Scheduled payments**

---

## ✨ Features

- **Time-Locked Transfers:** Automatically enforces a future unlock date using blockchain timestamps.  
- **Recipient Protection:** Only the designated recipient can withdraw the funds.  
- **Transparency:** Anyone can check how much time remains before withdrawal is allowed.  
- **No Middlemen:** The process is entirely automated — no banks, lawyers, or intermediaries needed.  
- **Upgradeable Foundation:** Can be extended to support ERC20 tokens, recurring payments, or Chainlink Automation.

---

## 🌐 Deployed Smart Contract

**Network:** Ethereum (Verified via Sourcify)  
**Contract Address:** [`0x5A0fb813b658455b59126560174A8494C3B43f55`](https://repo.sourcify.dev/11142220/0x5A0fb813b658455b59126560174A8494C3B43f55)

You can explore the verified source code, ABI, and deployment details via the link above.

---

## 🧩 Smart Contract Code

```solidity
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
