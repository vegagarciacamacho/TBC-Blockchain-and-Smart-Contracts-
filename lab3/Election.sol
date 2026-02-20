// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

import "./DhondtPollingStation.sol";
  
contract Election {
    address public authority; 
    uint public numParties;
    
    mapping(uint => DhondtPollingStation) public stations; // ID Region => Contrato Sede
    mapping(address => bool) public hasVoted; // Registro de votantes 

    modifier onlyAuthority() {
        require(msg.sender == authority, "Solo la autoridad puede hacer esto"); 
        _;
    }

    constructor(uint _numParties) {
        authority = msg.sender; 
        numParties = _numParties; 
    }

    function createPollingStation(uint _regionId, address _president) external onlyAuthority {
        require(address(stations[_regionId]) == address(0), "Ya existe sede en esta region");
        
        // Creamos una nueva instancia del contrato Sede
        DhondtPollingStation newStation = new DhondtPollingStation(_president, numParties, _regionId);
        stations[_regionId] = newStation;
    }

    function castVote(uint _regionId, uint _partyId) external {
        require(address(stations[_regionId]) != address(0), "Sede no valida"); 
        require(!hasVoted[msg.sender], "Ya has votado"); 

        hasVoted[msg.sender] = true;
        stations[_regionId].castVote(_partyId); // Llama a la sede correspondiente
    }

    function getResults() external view onlyAuthority returns (uint[] memory) {
        uint[] memory totalResults = new uint[](numParties);
        
        // En una practica real usariamos un array de IDs para recorrer las sedes 
        // Suponiendo que conocemos las regiones (ej: Madrid 28 y Teruel 44)
        uint[2] memory regions = [uint(28), 44]; 

        for (uint i = 0; i < regions.length; i++) {
            uint[] memory stationRes = stations[regions[i]].getResults();
            for (uint j = 0; j < numParties; j++) {
                totalResults[j] += stationRes[j]; // Consolidacion
            }
        }
        return totalResults;
    }
}