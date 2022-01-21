pragma solidity ^0.6.0;
import "./ERC20Claimable.sol";
import "./ExerciceSolutionToken.sol";

contract ExerciceSolution 
{
    ERC20Claimable claimableERC20;
    ExerciceSolutionToken solutionERC20;

    mapping(address => uint256) public nbTokenAddress;

    constructor(ERC20Claimable _claimableERC20, ExerciceSolutionToken _solutionERC20) 
	public 
	{
		claimableERC20 = _claimableERC20;
        solutionERC20 = _solutionERC20;
	}

    function claimTokensOnBehalf() external {
        claimableERC20.claimTokens();
        nbTokenAddress[msg.sender] += claimableERC20.distributedAmount();
    }
    
    function tokensInCustody(address caller) external view returns (uint256) {
        return nbTokenAddress[caller];
    }

    function withdrawTokens(uint256 amount) external returns (uint256) {
        require(nbTokenAddress[msg.sender] >= amount, "This address has no tokens in the contract");
        require(amount > 0, "Amount to withdraw must be greater than 0");
        claimableERC20.transfer(msg.sender, amount);
        nbTokenAddress[msg.sender] -= amount;
        solutionERC20.burn(msg.sender, amount);
    }

    function depositTokens(uint256 amount) external returns (uint256) {
        require(claimableERC20.balanceOf(msg.sender) >= amount, "This address has no tokens to deposit");
        require(amount > 0, "Amount to deposit must be greater than 0");
        uint256 allowance = claimableERC20.allowance(msg.sender, address(this));
        require(allowance >= amount, "Not enough allowance");
        claimableERC20.transferFrom(msg.sender, address(this), amount);
        nbTokenAddress[msg.sender] += amount;
        solutionERC20.mint(msg.sender, amount);
    }

    function getERC20DepositAddress() external view returns (address) {
        return address(solutionERC20);
    }
}