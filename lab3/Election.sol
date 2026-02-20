import "./DhondtPollingStation.sol";
  
contract Election {
    address public authority; // [cite: 78]
    uint public numParties;
    
    mapping(uint => DhondtPollingStation) public stations; // ID Region => Contrato Sede
    mapping(address => bool) public hasVoted; // Registro de votantes [cite: 77]

    modifier onlyAuthority() {
        require(msg.sender == authority, "Solo la autoridad puede hacer esto"); // [cite: 82]
        _;
    }

    constructor(uint _numParties) {
        authority = msg.sender; // [cite: 88]
        numParties = _numParties; // [cite: 87]
    }

    function createPollingStation(uint _regionId, address _president) external onlyAuthority {
        require(address(stations[_regionId]) == address(0), "Ya existe sede en esta region"); // [cite: 83, 90]
        
        // Creamos una nueva instancia del contrato Sede [cite: 90]
        DhondtPollingStation newStation = new DhondtPollingStation(_president, numParties, _regionId);
        stations[_regionId] = newStation;
    }

    function castVote(uint _regionId, uint _partyId) external {
        require(address(stations[_regionId]) != address(0), "Sede no valida"); // [cite: 85, 94]
        require(!hasVoted[msg.sender], "Ya has votado"); // [cite: 94]

        hasVoted[msg.sender] = true;
        stations[_regionId].castVote(_partyId); // Llama a la sede correspondiente [cite: 95]
    }

    function getResults() external view onlyAuthority returns (uint[] memory) {
        uint[] memory totalResults = new uint[](numParties);
        
        // En una practica real usariamos un array de IDs para recorrer las sedes [cite: 97]
        // Suponiendo que conocemos las regiones (ej: Madrid 28 y Teruel 44 del PDF) [cite: 108]
        uint[2] memory regions = [uint(28), 44]; 

        for (uint i = 0; i < regions.length; i++) {
            uint[] memory stationRes = stations[regions[i]].getResults(); // [cite: 97]
            for (uint j = 0; j < numParties; j++) {
                totalResults[j] += stationRes[j]; // Consolidacion [cite: 99]
            }
        }
        return totalResults;
    }
}