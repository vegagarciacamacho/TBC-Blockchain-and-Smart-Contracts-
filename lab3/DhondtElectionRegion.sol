// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

contract DhondtElectionRegion {
    uint internal regionId;
    mapping (uint => uint) private weights; 
    uint[] internal results; 

    constructor(uint _numParties, uint _regionId) {
        regionId = _regionId;
        results = new uint[](_numParties);
        savedRegionInfo(); 
    }

    function savedRegionInfo() private {
        weights[28] = 1; 
        weights[8] = 1;  
        weights[41] = 1; 
        weights[44] = 5; 
        weights[42] = 5; 
        weights[49] = 4; 
        weights[9] = 4;  
        weights[29] = 2; 
    }

    // Registra el voto aplicando el peso de la región 
    function registerVote(uint _party) internal returns (bool) {
        if (_party >= results.length) return false; 
        
        uint weight = weights[regionId] > 0 ? weights[regionId] : 1;
        results[_party] += weight; 
        return true; 
    }
}







