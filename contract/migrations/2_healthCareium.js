const Migrations = artifacts.require("healthCareium");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
