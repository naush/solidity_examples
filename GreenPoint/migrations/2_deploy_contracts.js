var ConvertLib = artifacts.require("./ConvertLib.sol");
var GreenPoint = artifacts.require("./GreenPoint.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, GreenPoint);
  deployer.deploy(GreenPoint);
};
