// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IDVault {
  // Deposits some Ether owned by the sender.
  function deposit() external payable;

  // Withdraws some _amount owned by the sender.
  function withdraw(uint _amount) external;

  // Returns the balance deposited for an address.
  function balanceOf(address _owner) external view returns (uint);

  // Transfers the ownership of an amount from the sender to another
  // user _to.
  function transfer(address _to, uint _amount) external;
  
  // Transfers some _amount between two different DVault contracts:
  // transfers _amount from this DVault to another DVault deployed at
  // address _dvault.
  //
  // IMPORTANT: note that the owner of the amount transferred should
  // be the same address in both DVaults.
  function externalTransfer(IDVault _dvault, uint _amount) external;
}

