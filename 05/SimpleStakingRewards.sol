// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleStakingRewards {

    IERC20 public immutable stakingToken;

    uint public totalStaked;//总抵押量
    mapping(address => uint) public balances;//用户抵押余额

    address public owner;

    constructor(address _stakingToken){
        stakingToken = IERC20(_stakingToken);
        owner = msg.sender;
    }

    // 增加用户抵押余额的逻辑
    function stake(uint _amount) external {
        require(_amount > 0, "amount >0");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        balanceOf[msg.sender] += _amount;
        totalStaked += _amount;
    }

    // 减少用户抵押余额的逻辑
    function withdraw(uint _amount) external {
        require(_amount > 0, "amount >0");
        require(balanceOf[msg.sender] > _amount,"balance > amount");

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }
}
