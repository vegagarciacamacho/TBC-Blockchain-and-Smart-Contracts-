import "./DhondtElectionRegion.sol";
import "./PollingStation.sol";

contract DhondtPollingStation is PollingStation, DhondtElectionRegion {
    
    // 1. Añadimos la variable para guardar la dirección de la autoridad
    address private creador;

    constructor(address _president, uint _numParties, uint _regionId) 
        PollingStation(_president) 
        DhondtElectionRegion(_numParties, _regionId) 
    {
        // 2. Asignamos quién es la autoridad (el que despliega el contrato)
        creador = msg.sender; 
    }

    // 3. Añadimos el modificador según tu captura de pantalla
    modifier onlyAuthority() {
        require(msg.sender == creador, "error no autorizado"); 
        _;
    }

    function castVote(uint _partyId) external override onlyIfOpen {
        bool success = registerVote(_partyId); 
        if (!success) revert("Identificador de partido no valido");
    }

    // 4. Aplicamos el modificador 'onlyAuthority' a la función de resultados
    function getResults() external view override onlyAuthority returns (uint[] memory) {
        if (!votingFinished) revert("La votacion aun no ha terminado"); 
        return results; 
    }
}