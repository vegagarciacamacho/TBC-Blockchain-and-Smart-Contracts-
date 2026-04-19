// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.2; // Usamos 0.6.2 para permitir {value: ...}

contract CryptoVaultFixed {
    address public owner;
    uint public collectedFees;
    address tLib;
    uint8 prcFee;
    bool initialized; 
    mapping (address => uint256) public accounts;

    constructor(address _vaultLib, uint8 _prcFee) public {
        tLib = _vaultLib;
        prcFee = _prcFee;
        owner = msg.sender;
        initialized = true; 
    }

    function deposit() public payable {
        require (msg.value >= 100, "Insufficient deposit");
        uint fee = msg.value * prcFee / 10000;
        accounts[msg.sender] += msg.value - fee;
        collectedFees += fee;
    }

    function withdraw(uint _amount) public {
        // Corrección Underflow: Comprobar balance antes de la resta [cite: 1410-1411]
        require (accounts[msg.sender] >= _amount, "Insufficient funds"); 
        accounts[msg.sender] -= _amount;
        
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send funds");
    }

    function withdrawAll() public {
        uint amount = accounts[msg.sender];
        require (amount > 0, "Insufficient funds");
        accounts[msg.sender] = 0;
        
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send funds");
    }

    // Fallback corregido para evitar toma de control [cite: 1416]
    fallback () external payable {
        // Bloqueamos cualquier intento de llamar a 'init' desde fuera [cite: 1411]
        require(msg.sig != bytes4(keccak256("init(address)")), "Forbidden: Ownership hijacking attempt");
        
        (bool success,) = tLib.delegatecall(msg.data);
        require(success, "delegatecall failed");
    }

    // Añadimos receive para cumplir con los estándares de la versión 0.6.2
    receive () external payable {}
}