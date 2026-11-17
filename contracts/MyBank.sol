// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

// A simple bank contract that lets users deposit and withdraw Ether.
contract MyBank {

    // Stores the Ether balance of each user's wallet address.
    // The mapping is private, so users must call viewBalance() to check their balance.
    mapping(address => uint256) private _balances;

    // Stores the address that deployed this contract.
    address public owner;

    // Events are written to the transaction logs when deposits or withdrawals happen.
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    // Runs only once when the contract is deployed.
    // 'payable' allows the deployer to send Ether during deployment.
    constructor() payable {
        owner = msg.sender;

        // If Ether is sent during deployment, credit it to the deployer's balance.
        if (msg.value > 0) {
            _balances[msg.sender] = msg.value;
            emit Deposit(msg.sender, msg.value);
        }
    }

    // Allows the caller to deposit Ether into the bank.
    // In Remix, enter the Ether amount in the Value field before clicking deposit().
    function deposit() public payable {
        require(msg.value > 0, "Enter an amount to deposit");

        // Add the received Ether (in Wei) to the caller's recorded balance.
        _balances[msg.sender] += msg.value;

        // Record the deposit in the transaction logs.
        emit Deposit(msg.sender, msg.value);
    }

    // Allows the caller to withdraw a specified amount of Ether.
    // The amount parameter is in Wei. Example: 1 ETH = 1000000000000000000 Wei.
    // Keep Remix's Value field at 0 when calling this function.
    function withdraw(uint256 amount) public {
        // Reject zero or negative-equivalent amounts (uint cannot be negative).
        require(amount > 0, "Amount must be greater than 0");

        // Check that the caller has enough recorded balance.
        require(
            _balances[msg.sender] >= amount,
            "Insufficient user balance"
        );

        // Check that the contract actually holds enough Ether to send.
        require(
            address(this).balance >= amount,
            "Bank does not have enough ETH"
        );

        // Update the user's balance before sending Ether.
        // This follows the Checks-Effects-Interactions pattern.
        _balances[msg.sender] -= amount;

        // Send Ether to the caller. 'success' tells us whether the transfer worked.
        (bool success, ) = payable(msg.sender).call{value: amount}("");

        // Revert the transaction if the Ether transfer failed.
        require(success, "Transfer failed");

        // Record the successful withdrawal in the transaction logs.
        emit Withdrawal(msg.sender, amount);
    }

    // Returns the recorded balance of the address calling this function.
    // 'view' means this function reads data but does not change blockchain state.
    // The returned value is in Wei.
    function viewBalance() public view returns (uint256) {
        return _balances[msg.sender];
    }

    // Returns the total Ether currently held by this contract, in Wei.
    // This is the contract's actual Ether balance, not an individual user's balance.
    function bankBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
