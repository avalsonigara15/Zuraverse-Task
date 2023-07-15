// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/*import the necessary contracts from the OpenZeppelin library,including ERC721 and ERC721URIStorage for NFT functionality and Ownable for ownership control.*/
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*Declaring the contract mintNFT that is inherited from ERC721URIStorage and Ownable contracts.*/
contract mintNFT is ERC721URIStorage, Ownable {
    uint256 public deploymentTime;
    uint256 public mintThreshold = 129600; //It's a public uint256 variable that represents the duration (in seconds) that needs to pass after deployment before minting is allowed.

    // These are private string variables that store the name and symbol of the token, respectively.
    string private _name;
    string private _symbol;

    // It's a mapping that associates a token name with a URI. It is used to store the URIs for different token names.
    mapping(string => string) private _tokenNames;

    /* It initializes the contract by setting the deployment time, name, symbol, and default URI for the tokens. The deployment time is set to the current block timestamp.*/
    constructor(
        string memory name_,
        string memory symbol_,
        string memory uri_
    ) ERC721(name_, symbol_) {
        deploymentTime = block.timestamp; //It's a public uint256 variable that stores the timestamp of contract deployment.
        _name = name_;
        _symbol = symbol_;
        setTokenNameAndURI(_name, uri_);
    }

    /*It's a function that allows the owner to set the token name and its associated URI.*/
    function setTokenNameAndURI(
        string memory name,
        string memory _uri
    ) public onlyOwner {
        _tokenNames[name] = _uri;
    }

    /*It's a function that allows the owner to mint new tokens. It checks if the required time threshold has passed since deployment before allowing minting. The minted token is assigned to the specified address, and the token URI is set.*/
    function mint(
        address _to,
        uint256 _tokenId,
        string calldata _uri
    ) external onlyOwner {
        require(
            block.timestamp >= deploymentTime + mintThreshold,
            "Minting not yet allowed"
        );
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _uri);
    }

    /*It's a function that returns the URI associated with a given token name.*/
    function tokenName(string memory name) public view returns (string memory) {
        return _tokenNames[name];
    }
}
