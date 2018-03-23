var SafeMath = artifacts.require("./SafeMath.sol");
var ERC20Token = artifacts.require("./ERC20Token.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ERC20Token);
  deployer.deploy(ERC20Token, 10000000, "Zastrin Token", 2, "ZTOK").then(function() {
    deployer.link(SafeMath, Crowdsale);
    return deployer.deploy(Crowdsale, 1, '0x6eccf86f756943d48f2d04e9c2c01a682ebf2143', ERC20Token.address);
  });
};
