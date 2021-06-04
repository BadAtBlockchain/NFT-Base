var HRC721 = artifacts.require("HRC721");
var HRC721Crowdsale = artifacts.require("HRC721Crowdsale");

module.exports = function (deployer, network, accounts) {
	const owner = accounts[0]

	const name = "ProcBlock"
	const symbol = "PROC"
	const price = '1000000000000000000';

	deployer.then(function () {
		return deployer.deploy(HRC721, name, symbol).then(function (hrc721) {
			return deployer.deploy(HRC721Crowdsale, owner, hrc721.address).then(async function (sale) {
				return hrc721.addMinter(sale.address)
			})
		})
	})
}