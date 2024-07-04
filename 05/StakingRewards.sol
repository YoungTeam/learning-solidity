// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract StakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public owner;

    uint public duration;
    uint public finishAt;
    uint public updateAt;
    uint public rewardRate;
    uint public rewardPerTokenStored; //奖励速率*时间/总质押量

    mapping(address => uint) public userRewardPerTokenPaid; //每一个用户的rpt
    mapping(address => uint) public rewards; //记录用户拿到多少奖励

    uint public totalSupply; //总质押token数量
    mapping(address => uint) public balanceOf; //用户质押了多少token

    constructor(address _stakingToken, address _rewardsToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "not owner");
        _;
    }

    modifier updateReward(address _account){
        rewardPerTokenStored = rewardPerToken();
        updateAt = lastTimeRewardApplicable();
        if(_account!=address(0)){
            rewards[_account]+=earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
        _;

    }

    //设置奖励时长
    function setRewardsDuration(uint _duration) external onlyOwner updateReward(address(0)){
        require(finishedAt < block.timestamp, "rewards duration not finished");
        duration = _duration;
    }

    //设置奖励金额
    function notifyRewardAmount(uint _amount) external onlyOwner {
        if (block.timestamp > finishedAt) {
            rewardRate = _amount / duration;
        } else {
            uint remainingRewards = rewardRate * (finishedAt - block.timestamp);
            rewardRate = (remainingRewards + amount) / duration;
        }

        require(rewardRate > 0, "reward rate >0");
        require(
            rewardRate * duration <= rewardToken.balanceOf(address(this)),
            "rewards not enough"
        );

        finishAt = block.timestamp + duration;
        updateAt = block.timestamp;
    }

    //
    function stake(uint _amount) external updateReward(msg.sender){
        require(_amount > 0, "amount >0");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;
    }

    function withdraw(uint _amount) external updateReward(msg.sender){
        require(_amount > 0, "amount >0");
        require(balanceOf[msg.sender] > _amount,"balance > amount");
        
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }

    function lastTimeRewardApplicable() public pure returns (uint) {
        return _min(block.timestamp, finishedAt);
    }

    function rewardPerToken() public view returns (uint) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            (rewardRate * (lastTimeRewardApplicable() - updateAt) * 1e18) /
            totalSupply;
    }

    //查看奖励
    function earned(address _account) external view returns (uint) {
        return
            balanceOf[_account] *
            (rewardPerToken() - userRewardPerTokenPaid[_account]) / 1e18 +
            rewards[_account];
    }

    function getReward() external {
            uint reward  = rewards[msg.sender];
            if(reward!=0){
                rewards[msg.sender] = 0;
                rewardsToken.transer(msg.sender,reward);
            }
    }
}
