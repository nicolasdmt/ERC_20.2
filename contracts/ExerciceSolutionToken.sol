pragma solidity >=0.6.0 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ExerciceSolutionToken is ERC20 {

	constructor(string memory name, string memory symbol) public ERC20(name, symbol) 
	{
	   _mint(msg.sender, 100000000000000000);
	}

	mapping(address => bool) public minter;

	function setMinter(address minterAddress, bool isMinter)  external {
		minter[minterAddress] = isMinter;
	}

	function mint(address toAddress, uint256 amount)  external {
		require(minter[toAddress], "This address is not a minting one");
		_mint(toAddress, amount);
	}

	function isMinter(address minterAddress) external view returns (bool) {
		return minter[minterAddress];
	}

	function burn(address from, uint256 amount) external {
        require(minter[msg.sender], "Sender is not a minter");
        _burn(from, amount);
    }
}