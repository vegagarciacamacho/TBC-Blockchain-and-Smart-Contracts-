// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FixedToken {
    uint256 public constant MAX_SUPPLY = 1000000; // [cite: 620]
    address public owner; // [cite: 621]
    mapping (address => uint256) public balances; // [cite: 622]
    uint256 public totalSupply; // [cite: 624]

    constructor() { 
        owner = msg.sender; // [cite: 625-626]
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Not owner"); // [cite: 629]
        require(amount > 0, "Zero amount"); // 

        uint256 remaining = MAX_SUPPLY - totalSupply; // 
        uint256 minted = amount < remaining ? amount : remaining; // 

        balances[to] += minted; // [cite: 634]
        
        // CORRECCIÓN: Se debe sumar 'minted' (cantidad real), no 'amount' (solicitada)
        totalSupply += minted; 

        // El SMTChecker ahora valida que esta aserción nunca falla
        assert(totalSupply <= MAX_SUPPLY); // 
    }

    function burn(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance"); // [cite: 641]
        balances[msg.sender] -= amount; // [cite: 642]
        totalSupply -= amount; // [cite: 643]
        
        assert(totalSupply <= MAX_SUPPLY); // [cite: 645]
    }
}