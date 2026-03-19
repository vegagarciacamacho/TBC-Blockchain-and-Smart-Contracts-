// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ComparativaGas {
    uint[] public arr;

    // Llena el array con 100 elementos basados en una semilla
    function generate(uint n) external {
        bytes32 b = keccak256("seed");
        delete arr;
        for (uint i = 0; i < n; i++) {
            uint8 number = uint8(b[i % 32]);
            arr.push(number);
        }
    }

    // VERSIÓN SOLIDITY (Para comparar)
    function maxMinSolidity() public view returns (uint maxmin) {
        uint len = arr.length;
        if (len == 0) return 0;

        uint maxVal = arr[0];
        uint minVal = arr[0];

        for (uint i = 1; i < len; i++) {
            uint val = arr[i];
            if (val > maxVal) maxVal = val;
            if (val < minVal) minVal = val;
        }
        return maxVal - minVal;
    }

    // VERSIÓN YUL (Tu código del Ejercicio 2)
    function maxMinYul() public view returns (uint maxmin) {
        assembly {
            function fmaxmin(s) -> maxV, minV {
                let len := sload(s)
                if iszero(len) { leave }
                mstore(0, s)
                let base := keccak256(0, 32)
                maxV := sload(base)
                minV := maxV
                for { let i := 1 } lt(i, len) { i := add(i, 1) } {
                    let val := sload(add(base, i))
                    if gt(val, maxV) { maxV := val }
                    if lt(val, minV) { minV := val }
                }
            }
            let mx, mn := fmaxmin(arr.slot)
            maxmin := sub(mx, mn)
        }
    }
}