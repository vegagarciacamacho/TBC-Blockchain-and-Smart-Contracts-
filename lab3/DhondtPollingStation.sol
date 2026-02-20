import "./DhondtElectionRegion.sol";
import "./PollingStation.sol";

contract DhondtPollingStation is PollingStation, DhondtElectionRegion {
    
    constructor(address _president, uint _numParties, uint _regionId) 
        PollingStation(_president) 
        DhondtElectionRegion(_numParties, _regionId) 
    {} // [cite: 67]

    function castVote(uint _partyId) external override onlyIfOpen {
        bool success = registerVote(_partyId); // [cite: 69]
        if (!success) revert("Identificador de partido no valido"); // [cite: 70]
    }

    function getResults() external view override returns (uint[] memory) {
        if (!votingFinished) revert("La votacion aun no ha terminado"); // [cite: 72]
        return results; // [cite: 71]
    }
}