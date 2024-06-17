// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayableExample {

    address payable recipient;

    constructor(){
        recipient = payable(msg.sender);
    }

    function receiveEther() external payable{

    }

    function queryBalance() external view returns (uint){
        return address(this).balance;
    }

    receive() external payable {
        
    }


    fallback() external payable {
        revert("Function not payable");
    }
}