// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyOwnable{
    address  public owner;
    uint public count;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(owner == msg.sender,"not owner");
        _;
    }

    function transferOwnership(address _owner) external onlyOwner(){
        require(_owner != address(0),"can't be 0");
        owner = _owner;
    }

    function exec() external{
        count++;
    }

    function resetCount(uint value) external onlyOwner(){   
        count = value;
    } 
}