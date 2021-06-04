pragma solidity >=0.4.24 <0.6.0;

import "./HRC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/roles/MinterRole.sol";

contract HRC721Crowdsale is MinterRole, ReentrancyGuard {
    using SafeMath for uint64;
    using SafeMath for uint128;
    using SafeMath for uint256;

	// owner to benefit from primary sales
	address payable public owner;

	// 721 tokens
	HRC721 hrc721;

	event MintedArtwork(address _addr, uint256 _total, uint256 _tokenId);

	//constructor
	constructor(address payable _owner, HRC721 _hrc721) public {
		owner = _owner;
		hrc721 = _hrc721;
	}

	/********************************
	Primary Sales
	********************************/
    function purchaseWithONE() public nonReentrant payable {
        uint256 weiAmount = msg.value;
		require(weiAmount != 0, "Crowdsale: weiAmount is 0");
		require(msg.sender != address(0), "Crowdsale: beneficiary is the zero address");
        uint128 price = 1000000000000000000;
        require(weiAmount == price, "Crowdsale: weiAmount does not equal price");
		
		//transfer funds to owner
        owner.transfer(msg.value);
		
		//mint and send the token
		_mint(msg.sender);
    }

	/********************************
	Only safe minting that passes purchase conditions
	********************************/
	function _mint(address to) internal {
		uint256 t = hrc721.mintArtwork(to);
		emit MintedArtwork(to, hrc721.totalEverMinted(), t);
	}

	/********************************
	Secondary Sales
	********************************/
	function buyTokenOnSale(uint256 _tokenId, uint256 _amount) public payable {
		address _to = msg.sender;
		uint256 _price = hrc721.getSalePrice(_tokenId);
        require(_price != 0, "Crowdsale: cannot buy token with price 0");
        require(_amount == _price, "Crowdsale: price doesn't equal hrc721.getSalePrice(_tokenId)");
		address _owner = hrc721.ownerOf(_tokenId);

		//pay for token
        // hrc20.transferFrom(_to, _owner, _amount);
		//remove the sale
		hrc721.minterSetSale(_tokenId, 0);
		//transfer the token
		hrc721.transferFrom(_owner, _to, _tokenId);
	}
}