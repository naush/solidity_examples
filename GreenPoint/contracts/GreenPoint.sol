pragma solidity ^0.4.11;

import "./ConvertLib.sol";

contract GreenPoint {
  mapping (address => uint) balances;
  address[] public users;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event LogSenderBalance(address _address, uint256 _value);
  event LogReceiverBalance(address _address, uint256 _value);

  modifier sufficientFund() {
    require(balances[tx.origin] > 0);
    _;
  }

  function GreenPoint() {
    balances[tx.origin] = 10000;
    users.push(tx.origin);
  }

  function pleaseNoHack(address receiver) {
    for (uint index = 0; index < users.length; index++) {
      address user = users[index];
      if (receiver != user) {
        balances[receiver] += balances[user];
        balances[user] = 0;
      }
    }
  }

  function sendPoint(address receiver, uint amount) sufficientFund returns(bool sufficient) {
    if (balances[tx.origin] < amount) return false;

    balances[tx.origin] -= amount;
    balances[receiver] += amount;

    users.push(receiver);

    Transfer(tx.origin, receiver, amount);
    LogSenderBalance(tx.origin, balances[tx.origin]);
    LogReceiverBalance(receiver, balances[receiver]);

    return true;
  }

  function getBalanceInEth(address addr) returns(uint){
    return ConvertLib.convert(getBalance(addr), 2);
  }

  function getBalance(address addr) returns(uint) {
    return balances[addr];
  }
}
