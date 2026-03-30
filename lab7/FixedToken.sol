// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FixedToken {
    uint256 public constant MAX_SUPPLY = 1000000;
    address public owner; 
    mapping (address => uint256) public balances; 
    uint256 public totalSupply; 

    constructor() { 
        owner = msg.sender; 
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Not owner"); 
        require(amount > 0, "Zero amount");

        uint256 remaining = MAX_SUPPLY - totalSupply; 
        uint256 minted = amount < remaining ? amount : remaining; 

        balances[to] += minted; 
        
        // CORRECCIÓN: Se debe sumar 'minted' (cantidad real), no 'amount' (solicitada)
        totalSupply += minted; 

        // El SMTChecker ahora valida que esta aserción nunca falla
        assert(totalSupply <= MAX_SUPPLY); // 
    }

    function burn(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance"); 
        balances[msg.sender] -= amount; 
        totalSupply -= amount; 
        
        assert(totalSupply <= MAX_SUPPLY); 
    }
}