abstract contract PollingStation {
    address public president; // [cite: 51]
    bool public votingFinished = false; // [cite: 46]
    bool private votingOpen = false; // [cite: 47]

    modifier onlyPresident() {
        require(msg.sender == president, "Solo el presidente puede hacer esto"); // [cite: 62]
        _;
    }

    modifier onlyIfOpen() {
        require(votingOpen && !votingFinished, "La votacion no esta abierta"); // [cite: 55, 60]
        _;
    }

    constructor(address _president) {
        president = _president; // [cite: 53]
    }

    function openVoting() external onlyPresident {
        require(!votingFinished, "La votacion ya finalizo");
        votingOpen = true; // [cite: 54]
    }

    function closeVoting() external onlyPresident {
        votingOpen = false;
        votingFinished = true; // [cite: 56, 57]
    }

    // Funciones que implementara el hijo [cite: 58]
    function castVote(uint _partyId) external virtual;
    function getResults() external virtual returns (uint[] memory);
}
