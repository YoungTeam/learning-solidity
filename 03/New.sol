// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Account {
    address public owner;
    constructor(address _owner) payable{
        owner = _owner;
    }
}


contract AccountFactory{

    Account[] public accounts;

    function createAccount(address _owner) external payable{

        Account account = new Account{value:123}(_owner);
        accounts.push(account);
    }
}