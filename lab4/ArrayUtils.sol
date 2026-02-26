// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library ArrayUtils {
    function contains(string[] memory arr, string memory val) internal pure returns (bool) {
        for (uint i = 0; i < arr.length; i++) {
            if (keccak256(abi.encodePacked(arr[i])) == keccak256(abi.encodePacked(val))) return true;
        }
        return false;
    }

    function increment(uint[] storage arr, uint8 percentage) internal {
        for (uint i = 0; i < arr.length; i++) {
            arr[i] += (arr[i] * percentage) / 100;
        }
    }

    function sum(uint[] memory arr) internal pure returns (uint) {
        uint total = 0;
        for (uint i = 0; i < arr.length; i++) {
            total += arr[i];
        }
        return total;
    }
}