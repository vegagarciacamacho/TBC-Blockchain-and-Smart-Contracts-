// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Lab6_Ex1 {
    function maxMinMemory(uint[] memory arr) public pure returns (uint maxmin) {
        assembly {
            // Definición de la función Yul según el enunciado
            function fmaxmin(array_pointer) -> maxVal, minVal {
                let len := mload(array_pointer) // Obtenemos la longitud 
                
                // Si el array está vacío, devolvemos 0 (o podrías revertir)
                if iszero(len) {
                    maxVal := 0
                    minVal := 0
                    leave
                }

                let data_ptr := add(array_pointer, 0x20) // Los datos empiezan tras la longitud 
                
                // Inicializamos max y min con el primer elemento 
                let first_elem := mload(data_ptr)
                maxVal := first_elem
                minVal := first_elem

                // Bucle para recorrer el resto del array 
                for { let i := 1 } lt(i, len) { i := add(i, 1) } {
                    let current_val := mload(add(data_ptr, mul(i, 0x20))) // Leemos el elemento i 
                    
                    if gt(current_val, maxVal) { maxVal := current_val } // Actualizamos máximo 
                    if lt(current_val, minVal) { minVal := current_val } // Actualizamos mínimo
                }
            }

            // Invocamos la función fmaxmin
            let maxV, minV := fmaxmin(arr)
            
            // Calculamos la distancia 
            maxmin := sub(maxV, minV)
        }
    }
}