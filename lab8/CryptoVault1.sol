// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26; 

import "hardhat/console.sol"; 

contract CryptoVault1 {
    address public owner;
    uint8 prcFee;
    uint public collectedFees;
    mapping (address => uint256) public accounts;

    constructor(uint8 _prcFee) {
        owner = msg.sender;
        prcFee = _prcFee;
    }

    function deposit() external payable {
        require (msg.value >= 100, "Insufficient deposit");
        uint fee = msg.value * prcFee / 10000;
        accounts[msg.sender] += msg.value - fee;
        collectedFees += fee;
    }

    function withdrawAll() external {
        uint amount = accounts[msg.sender];
        require (amount > 0, "Insufficient funds");

        // LOG para ver cuándo se intenta retirar
        console.log("Intentando retirar para:", msg.sender);
        console.log("Balance en cuenta:", amount);

        (bool sent, ) = msg.sender.call{value: amount}(""); 
        require(sent, "Failed to send funds");

        // Esta línea se ejecuta tarde debido a la reentrada
        accounts[msg.sender] = 0; 
        console.log("Balance puesto a cero para:", msg.sender);
    }
}