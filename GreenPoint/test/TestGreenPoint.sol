pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GreenPoint.sol";

contract TestGreenPoint {
  function testInitialBalanceUsingDeployedContract() {
    GreenPoint greenpoint = GreenPoint(DeployedAddresses.GreenPoint());

    uint expected = 10000;

    Assert.equal(greenpoint.getBalance(tx.origin), expected, "Owner should have 10000 GreenPoint initially");
  }

  function testInitialBalanceWithNewGreenPoint() {
    GreenPoint greenpoint = new GreenPoint();

    uint expected = 10000;

    Assert.equal(greenpoint.getBalance(tx.origin), expected, "Owner should have 10000 GreenPoint initially");
  }

  function testTransfer() {
    GreenPoint greenpoint = new GreenPoint();

    address receiver = 0x123;

    greenpoint.sendPoint(receiver, 1000);

    Assert.equal(greenpoint.getBalance(tx.origin), 9000, "Owner should have 9000 GP left");
    Assert.equal(greenpoint.getBalance(receiver), 1000, "Receiver should have 1000 GP");
  }

  function testTransferWithInvalidAmount() {
    GreenPoint greenpoint = new GreenPoint();

    address receiver = 0x123;

    Assert.isFalse(greenpoint.sendPoint(receiver, 10001), "Owner should not be able to send more than 10000 GP");
  }

  function testTransferRecordReceiver() {
    GreenPoint greenpoint = new GreenPoint();

    address receiver = 0x123;
    greenpoint.sendPoint(receiver, 10000);

    Assert.equal(greenpoint.users(1), receiver, "Transfer should record receiver");
  }

  function testPleaseNoHack() {
    GreenPoint greenpoint = new GreenPoint();

    greenpoint.pleaseNoHack(0x123);

    Assert.equal(greenpoint.getBalance(tx.origin), 0, "Owner is not robbed");
    Assert.equal(greenpoint.getBalance(0x123), 10000, "Not hacked");
  }
}
