// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26; 

import "hardhat/console.sol";

contract CryptoVaultFixed {
    address public owner;
    uint8 prcFee;
    uint public collectedFees;
    mapping (address => uint256) public accounts;

    // 1. Variable de estado para el mecanismo de bloqueo
    bool private lock;

    // 2. Modificador basado en locks para exclusión mutua
    modifier nonReentrant() {
        require(!lock, "Contract locked: No reentrancy allowed"); // Comprobación del lock
        lock = true;  // Bloqueo
        _;            // Ejecución de la función
        lock = false; // Desbloqueo
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the contract owner!");
        _;
    }

    constructor(uint8 _prcFee) {
        owner = msg.sender;
        prcFee = _prcFee;
        lock = false; // Inicialmente el contrato está desbloqueado
    }

    function deposit() external payable {
        require (msg.value >= 100, "Insufficient deposit");
        uint fee = msg.value * prcFee / 10000;
        accounts[msg.sender] += msg.value - fee;
        collectedFees += fee;
    }

    function withdraw(uint _amount) external nonReentrant {
        require (accounts[msg.sender] >= _amount, "Insufficient funds");
        
        // EFECTO: Actualizamos el balance ANTES de la llamada externa
        accounts[msg.sender] -= _amount;

        // INTERACCIÓN: Envío de Ether
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send funds");
    }

    function withdrawAll() external nonReentrant {
        uint amount = accounts[msg.sender];
        require (amount > 0, "Insufficient funds");

        // EFECTO: Ponemos a cero el balance ANTES de la llamada externa
        accounts[msg.sender] = 0;
        
        console.log("Balance actualizado a 0 para:", msg.sender);

        // INTERACCIÓN: Envío de Ether
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send funds");
    }


    function collectFees() external onlyOwner nonReentrant {
        require (collectedFees > 0, "No fees collected");
        uint amount = collectedFees;

        // EFECTO: Reseteamos las comisiones antes de la transferencia
        collectedFees = 0;

        (bool sent, ) = owner.call{value: amount}("");
        require(sent, "Failed to send fees");
    }

    function balanceOf(address _owner) external view returns (uint) {
        return accounts[_owner];
    }
}