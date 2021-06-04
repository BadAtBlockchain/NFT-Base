const HRC721 = artifacts.require("HRC721");
const HRC721Crowdsale = artifacts.require("HRC721Crowdsale");

const gasLimit = process.env.GAS_LIMIT
const gasPrice = process.env.GAS_PRICE

contract("HRC721", (accounts) => {
	let hrc721, crowdsale
	const price = '1000000000000000000';
	const alice = accounts[0], bob = accounts[1]

	it("should be deployed", async () => {
		hrc721 = await HRC721.deployed()
		crowdsale = await HRC721Crowdsale.deployed()
		assert.ok(hrc721 && crowdsale)
	})

	it("Should mint with ONE", async () => {
		const tryMint = await crowdsale.purchaseWithONE({value: price})
		const total = await hrc721.totalEverMinted()
	})

	it("Should get artwork by index id", async () => {
		const artwork = await hrc721.getArtworkByID(0)
		console.log(artwork);
	})

	/*
	it("crowdsale should have 0 items deployed", async () => {
		const totalItems = await crowdsale.totalItems()
		assert.equal(totalItems.toString(), '0')
	})

	it("creating 2 items in crowdsale", async () => {
		await crowdsale.addItem(price)
		await crowdsale.addItem(price)
	})

	it("crowdsale should have 2 items deployed", async () => {
		const totalItems = await crowdsale.totalItems()
		assert.equal(totalItems.toString(), '2')
	})
	*/
	
	/*
	it("crowdsale should mint tokens of an item in inventory", async () => {
		for (let i = 0; i < 10; i++) {
			await crowdsale.mint(alice, 0)
		}
		const minted = await crowdsale.getMinted(0)
		assert.equal(minted.toString(), '10')
	})

	assert.equal((await hrc721.balanceOf(bob)).toNumber(), 0)
	const tokenId = 1
	await hrc721.buyTokenOnSale(tokenId, {
		from: bob,
		value: price,
		gasLimit,
		gasPrice
	})
	assert.equal((await hrc721.balanceOf(alice)).toNumber(), 10)
	assert.equal((await hrc721.balanceOf(bob)).toNumber(), 1)

	})
	*/
});