// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

contract PiggyMapping {
    struct Client {
        string name;
        uint balance;
    }

    // Usamos address como clave para encontrar al Cliente 
    mapping(address => Client) public clients;

    function addClient(string memory name) external payable {
        require(bytes(name).length > 0, "El nombre es obligatorio");
        // Comprobar si existe usando la longitud del string
        require(bytes(clients[msg.sender].name).length == 0, "Ya estas registrado");

        clients[msg.sender] = Client(name, msg.value);
    }

    function deposit() external payable {
        require(bytes(clients[msg.sender].name).length > 0, "Cliente no registrado");
        clients[msg.sender].balance += msg.value;
    }

    function withdraw(uint amountInWei) external {
        require(bytes(clients[msg.sender].name).length > 0, "No eres un cliente"); 
        require(clients[msg.sender].balance >= amountInWei, "Saldo insuficiente"); 

        clients[msg.sender].balance -= amountInWei;
        
        (bool success, ) = payable(msg.sender).call{value: amountInWei}("");
        require(success, "Fallo en la transferencia");
    }

    function getBalance() external view returns (uint) {
        require(bytes(clients[msg.sender].name).length > 0, "Cliente no registrado");
        return clients[msg.sender].balance;
    }
}