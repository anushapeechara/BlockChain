var ERC20Token = artifacts.require("./ERC20Token.sol");

contract('ERC20Token', function(accounts) {

  it("should have no balance in first account", function() {
    return ERC20Token.deployed().then(function(instance) {
      return instance.balanceOf.call(accounts[0])
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 0, "100 wasn't in the first account");
    })
  });

  it("should mint 100 tokens and assign to first account", function() {
    var contract;
    return ERC20Token.deployed().then(function(instance) {
      contract = instance;
      return contract.mint(accounts[0], 100);
    }).then(function() {
      return contract.balanceOf.call(accounts[0])
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 100, "100 tokens weren't in the first account");
    });
  });

  it("should transfer 20 tokens from first account to second account", function() {
    var contract;
    return ERC20Token.deployed().then(function(instance) {
      contract = instance;
      return contract.transfer(accounts[1], 20);
    }).then(function() {
      return contract.balanceOf.call(accounts[1])
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 20, "20 tokens weren't in the second account");
    });
  });

});
