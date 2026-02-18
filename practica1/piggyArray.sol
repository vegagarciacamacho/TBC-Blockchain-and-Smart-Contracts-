// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

contract PiggyArray {
    struct Client {
        string name;
        address clientAddress;
        uint balance;
    }

    Client[] public clients;

    // Función interna para buscar el índice de un cliente 
    function clientIndex(address _address) internal view returns (uint) {
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].clientAddress == _address) {
                return i;
            }
        }
        revert("Cliente no registrado"); // Si no lo encuentra, revierte con un mensaje de error
    }

    function addClient(string memory name) external payable {
        require(bytes(name).length > 0, "El nombre no puede estar vacio"); 
        
        // Comprobar que no existe ya (si clientIndex no falla, es que existe)
        for (uint i = 0; i < clients.length; i++) {
            require(clients[i].clientAddress != msg.sender, "Cliente ya registrado");
        }

        clients.push(Client(name, msg.sender, msg.value)); 
    }

    function deposit() external payable {
        uint index = clientIndex(msg.sender);
        clients[index].balance += msg.value;
    }

    function withdraw(uint amountInWei) external {
        uint index = clientIndex(msg.sender);
        require(clients[index].balance >= amountInWei, "Saldo insuficiente");

        clients[index].balance -= amountInWei;
        
        (bool success, ) = payable(msg.sender).call{value: amountInWei}("");
        require(success, "Fallo en la transferencia"); // Siempre verifica el resultado del call 
    }

    function getBalance() external view returns (uint) {
        uint index = clientIndex(msg.sender);
        return clients[index].balance;
    }
}