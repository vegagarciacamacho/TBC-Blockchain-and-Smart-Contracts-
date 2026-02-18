// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

contract PiggyMapping2 {
    struct Client {
        string name;
        uint balance;
    }

    // Mapeo principal para guardar los datos
    mapping(address => Client) public clients;
    
    // Este array almacenará las direcciones de los clientes para poder iterar sobre ellos
    address[] public clientAddresses;

    function addClient(string memory name) external payable {
        require(bytes(name).length > 0, "El nombre es obligatorio");
        // Verificamos si ya existe para no duplicar la dirección en el array
        require(bytes(clients[msg.sender].name).length == 0, "Ya estas registrado");

        clients[msg.sender] = Client(name, msg.value);
        
        // Guardamos la dirección del nuevo cliente en nuestro "índice" (array)
        clientAddresses.push(msg.sender);
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

    function checkBalances() external view returns (bool) {
        uint totalSum = 0;

        // Recorremos el array de direcciones que hemos ido llenando
        for (uint i = 0; i < clientAddresses.length; i++) {
            address addr = clientAddresses[i];
            // Sumamos el balance de cada cliente usando la dirección como llave del mapping
            totalSum += clients[addr].balance;
        }

        // Comparamos si la suma de los saldos individuales es igual al saldo total del contrato
        return totalSum == address(this).balance;
    }
}