// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ShopRegistry {

    struct Item {
        uint128 price;       // 16 bytes
        address seller;      // 20 bytes
        uint256 itemId;      // 32 bytes
        uint64  stock;       //  8 bytes
        bool    available;   //  1 byte
    }

    uint64  public  totalSold;     //  8 bytes
    bool    public  paused;        //  1 byte
    uint256 public  totalRevenue;  // 32 bytes
    uint128 public  feeRate;       // 16 bytes
    address public  owner;         // 20 bytes


    mapping(uint256 => Item) public items; // 32 bytes

    constructor() {
        owner  = msg.sender;
        paused = false;
    }

    function addItem(
        uint256 id,
        uint128 price,
        uint64  stock
    ) external {
        require(!paused, "Contract is paused");
        require(msg.sender == owner, "Not owner");
        items[id] = Item(price, msg.sender, id, stock, true);
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