abstract contract PollingStation {
    address public president; 
    bool public votingFinished = false; 
    bool private votingOpen = false; 

    modifier onlyPresident() {
        require(msg.sender == president, "Solo el presidente puede hacer esto"); 
        _;
    }

    modifier onlyIfOpen() {
        require(votingOpen && !votingFinished, "La votacion no esta abierta"); 
        _;
    }

    constructor(address _president) {
        president = _president; 
    }

    function openVoting() external onlyPresident {
        require(!votingFinished, "La votacion ya finalizo");
        votingOpen = true; 
    }

    function closeVoting() external onlyPresident {
        votingOpen = false;
        votingFinished = true; 
    }

    // Funciones que implementara el hijo 
    function castVote(uint _partyId) external virtual;
    function getResults() external virtual returns (uint[] memory);
}
