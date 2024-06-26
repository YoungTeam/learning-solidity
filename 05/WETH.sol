// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20{

    event Deposit(address indexed account,uint amount);
    event Withdraw(address indexed account,uint amount);
    
    constructor() ERC20("wyt","wyt") {

    }

    receive() external payable { }
    
    fallback() external payable{
        deposit();
    }

    function deposit() public payable{
        _mint(msg.sender,msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) external payable{
        _burn(msg.sender,_amount);
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender,_amount);

    }


}