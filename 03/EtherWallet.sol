// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet{
    address public owner;
    constructor(){
        owner = msg.sender;
    }

    receive() external payable{

    }

    function withdraw(uint amount) external payable{

        require(owner==msg.sender,"illege");
        payable(owner).transfer(amount);
    }

    function balance() external view returns(uint){
        return address(this).balance;

    }
}