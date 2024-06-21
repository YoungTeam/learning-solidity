// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyOwnable{

    address public owner;
    uint public count;
    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"not owner");
        _;
    }


    function transferOwnership(address _owner) external onlyOwner{
        require(_owner!=address(0),"invalid _owner");
        owner = _owner;
    }

    function counter() external{
            count++;
    }

    function resetCount() external onlyOwner{
        delete count;
    }

}