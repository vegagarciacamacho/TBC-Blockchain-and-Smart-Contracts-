// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./ERC721simplified.sol";
import "./ArrayUtils.sol";

// Interfaz para el receptor de tokens (necesaria para safeTransferFrom)
interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
}

contract MonsterTokens is ERC721simplified {
    using ArrayUtils for string[];
    using ArrayUtils for uint[];

    address private creador; // GameMaster 
    uint256 private nextTokenId = 10001; 
    uint256 public constant FIANZA = 1000 wei; 
    uint256 public totalFianzas;

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

    modifier onlyAuthority() {
        require(msg.sender == creador, "error no autorizado");
        _;
    }

    constructor() {
        creador = msg.sender;
    }

    // --- FUNCIONES DE GESTIÓN PROPIAS ---

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

    function addWeapon(uint256 _tokenId, string memory _wName, uint _power) external payable {
        require(_owners[_tokenId] == msg.sender || _approvals[_tokenId] == msg.sender, "No autorizado"); 
        require(!_monsters[_tokenId].weapons.names.contains(_wName), "Arma ya existe"); 
        require(msg.value >= _power * 2, "Pago insuficiente por arma");
        _monsters[_tokenId].weapons.names.push(_wName);
        _monsters[_tokenId].weapons.firePowers.push(_power);
    }

    function collectProfits() external onlyAuthority {
        uint256 profits = address(this).balance - totalFianzas; 
        payable(creador).transfer(profits);
    }

    // --- IMPLEMENTACIÓN OBLIGATORIA DE ERC721simplified ---

    function approve(address _approved, uint256 _tokenId) external payable override {
        require(_owners[_tokenId] == msg.sender, "Solo el dueno puede aprobar"); 
        uint256 cost = _monsters[_tokenId].weapons.firePowers.sum(); 
        require(msg.value >= cost, "Pago insuficiente"); 
        _approvals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId); 
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable override {
        require(msg.sender == _owners[_tokenId] || msg.sender == _approvals[_tokenId], "No autorizado"); 
        require(_owners[_tokenId] == _from, "Origen no es dueno");
        uint256 cost = _monsters[_tokenId].weapons.firePowers.sum(); 
        require(msg.value >= cost, "Pago insuficiente");

        _balances[_from]--;
        _balances[_to]++;
        _owners[_tokenId] = _to;
        delete _approvals[_tokenId]; 
        emit Transfer(_from, _to, _tokenId); 
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable override {
        transferFrom(_from, _to, _tokenId); 
        if (_to.code.length > 0) { 
            bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, ""); 
            require(retval == ERC721TokenReceiver.onERC721Received.selector, "Receptor no valido"); 
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
        require(_owners[_tokenId] != address(0), "Token inexistente"); 
        return _approvals[_tokenId]; 
    }

    function supportsInterface(bytes4 _interfaceId) external pure override returns (bool) {
        // Retorna true para ERC165 y para TU ID calculado de ERC721simplified
        return _interfaceId == 0x01ffc9a7 || _interfaceId == 0x73884ab3;
    }
}