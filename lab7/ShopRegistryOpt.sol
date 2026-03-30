// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ShopRegistryOpt {

    struct Item {
        // Slot 0: 32 bytes
        uint256 itemId;
        // Slot 1: 20 + 8 + 1 = 29 bytes (Empaquetados)
        address seller;    // 20 bytes 
        uint64  stock;     // 8 bytes 
        bool    available; // 1 byte 
        // Slot 2: 16 bytes
        uint128 price;     // 16 bytes 
    }

    // --- Variables de Estado Optimizadas ---
    
    // Slot 0: 32 bytes
    uint256 public totalRevenue; 
    
    // Slot 1: 32 bytes
    mapping(uint256 => Item) public items; 

    // Slot 2: 20 + 8 + 1 = 29 bytes (Empaquetados)
    address public owner;       // 20 bytes 
    uint64  public totalSold;   // 8 bytes 
    bool    public paused;      // 1 byte 
    
    // Slot 3: 16 bytes
    uint128 public feeRate;     // 16 bytes 

    constructor() {
        owner  = msg.sender; 
        paused = false;     
    }

    // Las funciones permanecen con la misma lógica que el original 
    
    function addItem(
        uint256 id,
        uint128 price,
        uint64  stock
    ) external {
        require(!paused, "Contract is paused"); 
        require(msg.sender == owner, "Not owner"); 
        
        // El orden de los argumentos en el constructor del struct debe coincidir
        // con la declaración original o usarse de forma nominal
        items[id] = Item({
            price: price,
            seller: msg.sender,
            itemId: id,
            stock: stock,
            available: true
        });
    }

    function recordSale(uint256 id, uint128 amount) external {
        require(!paused, "Contract is paused"); 
        require(items[id].available, "Item not available"); 
        require(items[id].stock > 0, "Out of stock"); 
        
        items[id].stock -= 1; 
        totalSold += 1; 
        totalRevenue += amount; 
    }
}