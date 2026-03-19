// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ex2 {
    uint[] public arr;

    function generate(uint n) external {
        bytes32 b = keccak256("seed");
        delete arr;
        for (uint i = 0; i < n; i++) {
            uint8 number = uint8(b[i % 32]);
            arr.push(number);
        }
    }

    function maxMinStorage() public view returns (uint maxmin) {

        assembly {
            // Definición de la función Yul según el enunciado 
            function fmaxmin(slot_param) -> maxVal, minVal {
                let len := sload(slot_param) // Leer longitud del array desde storage 
                
                if iszero(len) { leave } 

                // Calcular inicio de datos: keccak256(slot_param)
                mstore(0, slot_param)
                let base := keccak256(0, 32) 
                
                maxVal := sload(base) 
                minVal := maxVal

                for { let i := 1 } lt(i, len) { i := add(i, 1) } { 
                    let val := sload(add(base, i)) 
                    if gt(val, maxVal) { maxVal := val } 
                    if lt(val, minVal) { minVal := val }                 }
            }

            // Aquí es donde usamos el ".slot" correctamente 
            let mx, mn := fmaxmin(arr.slot) 
            maxmin := sub(mx, mn) 
        }
    }
}