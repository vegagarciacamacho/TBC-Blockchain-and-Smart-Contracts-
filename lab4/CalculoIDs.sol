// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./ERC721simplified.sol";

contract SelectorHelper {
    // Calcula el ID de ERC165
    function getERC165Id() public pure returns (bytes4) {
        return type(ERC165).interfaceId;
    }

    // Calcula el ID de tu ERC721simplified
    function getERC721Id() public pure returns (bytes4) {
        return type(ERC721simplified).interfaceId;
    }
}