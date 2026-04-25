// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./IDvault.sol";

contract DVault is IDVault {
    mapping(address => uint) private accounts;

    function deposit() external payable override {
        accounts[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) external override {
        require(accounts[msg.sender] >= _amount, "Saldo insuficiente");
        // Patron Checks-Effects-Interactions para evitar reentrada
        accounts[msg.sender] -= _amount;
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Error al enviar Ether");
    }

    function balanceOf(address _owner) external view override returns (uint) {
        return accounts[_owner];
    }

    function transfer(address _to, uint _amount) external override {
        require(accounts[msg.sender] >= _amount, "Saldo insuficiente");
        accounts[msg.sender] -= _amount;
        accounts[_to] += _amount;
    }

    function externalTransfer(IDVault _dvault, uint _amount) external override {
        require(accounts[msg.sender] >= _amount, "Saldo insuficiente");
        accounts[msg.sender] -= _amount;
        // Se envia el Ether a la otra hucha
        _dvault.deposit{value: _amount}();
    }
}