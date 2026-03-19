// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8;

contract lab6 {
    uint[] arr;
    uint sum;

    // Genera el array con el que vamos a trabajar
    function generate (uint n) external {
        for (uint i=0; i<n; i++) {
            arr.push(i*i);
        }
    }

    function computeSum() external {
        uint _tempSum = 0; // Variable local (barata)
        uint _len = arr.length; // Cache de longitud (1 solo SLOAD)
        
        for (uint i = 0; i < _len; i++) {
            _tempSum += arr[i]; // Solo 1 SLOAD (el de arr[i])
        }
        
        sum = _tempSum; // 1 solo SSTORE final
    }
}