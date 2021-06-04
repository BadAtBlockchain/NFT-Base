pragma solidity >=0.4.21 <0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";

contract HRC721 is ERC721Full, ERC721Mintable {
	//maps tokenIds to artwork indexes
	mapping(uint256 => uint256) private _allArtworks;
	uint256 public totalEverMinted;

	//maps tokenIds to salePrice, sale means price of > 0
	mapping(uint256 => uint256) private salePrice;

	event MintedArtwork(address _addr, uint256 _mintedID, uint256 _tokenId);
	
	constructor(string memory _name, string memory _symbol) ERC721Full(_name, _symbol) public {}

	function setSale(uint256 tokenId, uint256 price, address saleContract) public {
		address owner = ownerOf(tokenId);
        require(owner != address(0), "setSale: nonexistent token");
        require(owner == msg.sender, "setSale: msg.sender is not the owner of the token");
		salePrice[tokenId] = price;
		approve(saleContract, tokenId);
	}

	function minterSetSale(uint256 tokenId, uint256 price) public {
		salePrice[tokenId] = price;
	}

	function mintArtwork(address to) public returns (uint256) {
		bytes32 hashed = keccak256(abi.encodePacked(totalEverMinted, block.timestamp, to));
        uint256 tokenId = uint(hashed);
		
		// TODO: this should be safe right? Index will be the current minted total? 0,1,2,3,etc
		_allArtworks[totalEverMinted] = tokenId;
		totalEverMinted = totalEverMinted.add(1);

        mint(to, tokenId);

		return tokenId;
	}

	function getSalePrice(uint256 tokenId) public view returns (uint256) {
		return salePrice[tokenId];
	}

	function getArtworkByID(uint256 id) public view returns (string memory) {
		require(id < totalEverMinted, "ID requested has not been created yet");
		
		uint256 tokenID = _allArtworks[id];
		require(tokenID > 0, "TokenID was not found in artwork collection");

		return "FOUND NFT WITH TOKEN";
	}
}