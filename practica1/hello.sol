// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

contract hello {
    event Print (string message);

    function helloWorld() public {
        emit Print("Hello, World!");
    }

    // Ejercicio 2
    function factorial(uint n) public pure returns (uint) {
        if (n == 0) return 1;
        uint res = 1;
        for (uint i = 1; i <= n; i++) {
            res *= i;
        }
        return res;
    }
}
