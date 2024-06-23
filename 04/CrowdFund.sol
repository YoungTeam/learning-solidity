// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract CrowdFund {
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;
        uint256 startAt;
        uint256 endAt;
        bool claimed;
    }

    IERC20 public token;
    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

    event CampaignCreated(uint256 indexed id, address indexed creator, uint256 goal, uint256 startAt, uint256 endAt);
    event Pledged(uint256 indexed id, address indexed pledger, uint256 amount);
    event Unpledged(uint256 indexed id, address indexed pledger, uint256 amount);
    event Claimed(uint256 indexed id, address indexed creator, uint256 amount);
    event Refunded(uint256 indexed id, address indexed pledger, uint256 amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function createCampaign(uint256 _goal, uint256 _startAt, uint256 _endAt) external {
        require(_startAt >= block.timestamp, "startAt < now");
        require(_endAt > _startAt, "endAt <= startAt");

        _startAt = block.timestamp;
        _endAt = _startAt+ 20 minutes;

        campaignCount++;
        campaigns[campaignCount] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit CampaignCreated(campaignCount, msg.sender, _goal, _startAt, _endAt);
    }

    function pledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp >= campaign.startAt, "Campaign not started");
        require(block.timestamp <= campaign.endAt, "Campaign ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        emit Pledged(_id, msg.sender, _amount);
    }

    function unpledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp <= campaign.endAt, "Campaign ended");
        require(pledgedAmount[_id][msg.sender] >= _amount, "Insufficient pledged amount");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        require(token.transfer(msg.sender, _amount), "Transfer failed");

        emit Unpledged(_id, msg.sender, _amount);
    }

    function claim(uint256 _id) external {
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp > campaign.endAt, "Campaign not ended");
        require(campaign.creator == msg.sender, "Not campaign creator");
        require(campaign.pledged >= campaign.goal, "Goal not reached");
        require(!campaign.claimed, "Already claimed");

        campaign.claimed = true;
        require(token.transfer(campaign.creator, campaign.pledged), "Transfer failed");

        emit Claimed(_id, msg.sender, campaign.pledged);
    }

    function refund(uint256 _id) external {
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp > campaign.endAt, "Campaign not ended");
        require(campaign.pledged < campaign.goal, "Goal reached");

        uint256 balance = pledgedAmount[_id][msg.sender];
        require(balance > 0, "No pledged amount");

        pledgedAmount[_id][msg.sender] = 0;
        require(token.transfer(msg.sender, balance), "Transfer failed");

        emit Refunded(_id, msg.sender, balance);
    }
}
