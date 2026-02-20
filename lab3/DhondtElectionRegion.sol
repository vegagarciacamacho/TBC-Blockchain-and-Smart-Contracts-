// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.5;

contract DhondtElectionRegion {
    uint internal regionId;
    mapping (uint => uint) private weights; // [cite: 22]
    uint[] internal results; // [cite: 34]

    constructor(uint _numParties, uint _regionId) {
        regionId = _regionId; // [cite: 32]
        results = new uint[](_numParties); // [cite: 35]
        savedRegionInfo(); // Inicializa los pesos [cite: 23]
    }

    function savedRegionInfo() private {
        weights[28] = 1; // Madrid [cite: 24]
        weights[8] = 1;  // Barcelona [cite: 26]
        weights[41] = 1; // Sevilla [cite: 26]
        weights[44] = 5; // Teruel [cite: 27]
        weights[42] = 5; // Soria [cite: 28]
        weights[49] = 4; // Zamora [cite: 29]
        weights[9] = 4;  // Burgos [cite: 29]
        weights[29] = 2; // Malaga [cite: 30]
    }

    // Registra el voto aplicando el peso de la región [cite: 38]
    function registerVote(uint _party) internal returns (bool) {
        if (_party >= results.length) return false; // [cite: 39]
        
        uint weight = weights[regionId] > 0 ? weights[regionId] : 1;
        results[_party] += weight; // [cite: 40]
        return true; // [cite: 41]
    }
}







