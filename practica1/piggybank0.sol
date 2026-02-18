// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

contract PiggyBank0 {

    // Permite recibir Ether
    function deposit() external payable {
    }

    // Permite retirar una cantidad específica en Wei
    function withdraw(uint amountInWei) external {
        // Comprueba si el contrato tiene fondos suficientes
        // Si no, revierte la transacción con un mensaje de error
        require(address(this).balance >= amountInWei, "No hay suficiente Ether en la hucha");

        // Envía la cantidad al emisor de la transacción (msg.sender)
        (bool success, ) = payable(msg.sender).call{value: amountInWei}("");
        require(success, "Fallo en el envio de Ether");
    }

    // Devuelve el saldo actual del contrato
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}