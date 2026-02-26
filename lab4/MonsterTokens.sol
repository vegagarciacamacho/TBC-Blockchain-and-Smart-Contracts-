// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./ERC721simplified.sol";
import "./ArrayUtils.sol";

contract MonsterTokens is ERC721simplified {
    using ArrayUtils for string[];
    using ArrayUtils for uint[];

    // --- Variables de Estado ---
    address private creador; // GameMaster
    uint256 private nextTokenId = 10001; // IDs consecutivos desde 10001
    uint256 public constant FIANZA = 1000 wei; // Fianza por creación 
    uint256 public totalFianzas; // Saldo bloqueado para devoluciones 

    struct Weapons {
        string[] names;
        uint[] firePowers;
    }

    struct Character {
        string name;
        Weapons weapons;
    }

    mapping(uint256 => Character) private _monsters;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _approvals;

    // --- Modificadores ---
    modifier onlyAuthority() {
        require(msg.sender == creador, "error no autorizado"); // De tu captura
        _;
    }

    modifier onlyAuthorized(uint256 tokenId) {
        require(msg.sender == _owners[tokenId] || msg.sender == _approvals[tokenId], "No autorizado");
        _;
    }

    constructor() {
        creador = msg.sender; // Asignación inicial de autoridad 
    }

    // --- Funciones de Gestión ---

    function createMonsterToken(string memory _name) external payable returns (uint256) {
        require(msg.value >= FIANZA, "Fianza insuficiente"); 
        
        uint256 tokenId = nextTokenId++;
        _owners[tokenId] = msg.sender;
        _balances[msg.sender]++;
        _monsters[tokenId].name = _name;
        totalFianzas += FIANZA;

        emit Transfer(address(0), msg.sender, tokenId);
        return tokenId; 
    }

    function removeMonsterToken(uint256 _tokenId) external {
        require(_owners[_tokenId] == msg.sender, "Solo el dueno puede borrar"); 
        
        _balances[msg.sender]--;
        delete _monsters[_tokenId];
        delete _owners[_tokenId];
        delete _approvals[_tokenId];
        totalFianzas -= FIANZA;

        payable(msg.sender).transfer(FIANZA); // Devuelve la fianza 
    }

    function addWeapon(uint256 _tokenId, string memory _wName, uint _power) external payable onlyAuthorized(_tokenId) {
        Character storage mon = _monsters[_tokenId];
        require(!mon.weapons.names.contains(_wName), "Arma ya existe"); 
        
        // Coste exponencial: firePower * 2 
        require(msg.value >= _power * 2, "Pago insuficiente por arma");

        mon.weapons.names.push(_wName);
        mon.weapons.firePowers.push(_power);
    }

    function incrementFirePower(uint256 _tokenId, uint8 _percentage) external payable onlyAuthorized(_tokenId) {
        // Coste cuadrático: porcentaje al cuadrado 
        require(msg.value >= uint256(_percentage) * _percentage, "Pago insuficiente");
        
        _monsters[_tokenId].weapons.firePowers.increment(_percentage); 
    }

    function collectProfits() external onlyAuthority {
        // Transferir solo beneficios (Saldo - Fianzas) 
        uint256 profits = address(this).balance - totalFianzas;
        payable(creador).transfer(profits);
    }

    // --- Implementación ERC721 Simplified ---

    function approve(address _approved, uint256 _tokenId) external payable override {
        require(_owners[_tokenId] == msg.sender, "No eres el dueno");
        
        // Retribución: suma de potencias de fuego 
        uint256 cost = _monsters[_tokenId].weapons.firePowers.sum();
        require(msg.value >= cost, "Pago insuficiente");

        _approvals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId); 
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable override {
        require(msg.sender == _owners[_tokenId] || msg.sender == _approvals[_tokenId], "No autorizado"); 
        
        uint256 cost = _monsters[_tokenId].weapons.firePowers.sum();
        require(msg.value >= cost, "Pago insuficiente"); 

        _balances[_from]--;
        _balances[_to]++;
        _owners[_tokenId] = _to;
        delete _approvals[_tokenId]; // Revocar aprobación 

        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable override {
        transferFrom(_from, _to, _tokenId);
        // Verificación de cuenta externa o contrato 
        if (_to.code.length > 0) {
             // onERC721Received check omitted for simplicity in simplified ERC721
        }
    }

    function balanceOf(address _owner) external view override returns (uint256) {
        return _balances[_owner]; 
    }

    function ownerOf(uint256 _tokenId) external view override returns (address) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "Token inexistente"); 
        return owner;
    }

    function getApproved(uint256 _tokenId) external view override returns (address) {
        require(_owners[_tokenId] != address(0), "Token invalido"); 
        return _approvals[_tokenId];
    }

    function supportsInterface(bytes4 _interfaceId) external pure override returns (bool) {
        return _interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd; // ERC165 y ERC721
    }
}