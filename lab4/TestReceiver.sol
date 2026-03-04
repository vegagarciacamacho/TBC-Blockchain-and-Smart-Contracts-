// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface ERC721TokenReceiver {
    function onERC721Received(
        address _operator, 
        address _from, 
        uint256 _tokenId, 
        bytes calldata _data
    ) external returns(bytes4);
}

contract TestReceiver is ERC721TokenReceiver {
    // Añadimos 'pure' porque solo devolvemos un valor constante (el selector)
    function onERC721Received(
        address, 
        address, 
        uint256, 
        bytes calldata
    ) external pure override returns(bytes4) {
        // Devolvemos el selector de la interfaz para confirmar la recepción 
        return this.onERC721Received.selector; 
    }
}