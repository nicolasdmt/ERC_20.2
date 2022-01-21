var TDErc20 = artifacts.require("ERC20TD.sol");
var ERC20Claimable = artifacts.require("ERC20Claimable.sol");
var evaluator = artifacts.require("Evaluator.sol");
var exercicesolution = artifacts.require("ExerciceSolution.sol");
var exercicesolutiontoken = artifacts.require("ExerciceSolutionToken.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployTDToken(deployer, network, accounts); 
        await deployEvaluator(deployer, network, accounts); 
        await doExercices(deployer, network, accounts); 
    });
};

async function deployTDToken(deployer, network, accounts) {
	TDToken = await TDErc20.at('0x77dAe18835b08A75490619DF90a3Fa5f4120bB2E')
	ClaimableToken = await ERC20Claimable.at('0xb5d82FEE98d62cb7Bc76eabAd5879fa4b29fFE94')
    Token = await exercicesolutiontoken.new("ERC20", "TD1");
}

async function deployEvaluator(deployer, network, accounts) {
	Evaluator = await evaluator.at('0x384C00Ff43Ed5376F2d7ee814677a15f3e330705')
}

async function doExercices(deployer, network, accounts){
    //Exo1
    await ClaimableToken.claimTokens();
	await Evaluator.ex1_claimedPoints();

    //Exo 2
    Exo = await exercicesolution.new(ClaimableToken.address, Token.address);
	await Evaluator.submitExercice(Exo.address);
    await Evaluator.ex2_claimedFromContract();

    //Exo 3
    await Evaluator.ex3_withdrawFromContract();
    
    //Exo4
    await ClaimableToken.approve(Exo.address, web3.utils.toBN("100002500002300000"));
    await Evaluator.ex4_approvedExerciceSolution();

    //Exo5
    await ClaimableToken.approve(Exo.address, 0);
    await Evaluator.ex5_revokedExerciceSolution();

    //Exo6
    await Evaluator.ex6_depositTokens();

    //Exo7
    await Token.setMinter(Exo.address, true);
    await Evaluator.ex7_createERC20();

    //Exo8
    await Token.setMinter(Evaluator.address, true);
    await Evaluator.ex8_depositAndMint();

    //Exo9
    await Evaluator.ex9_withdrawAndBurn();
}