// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "../ERC20/IERC20.sol"; //import IERC20

contract ERC20 is IERC20 {
    mapping(address => uint256) public override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply; // 代币总供给

    string public name; // 名称
    string public symbol; // 符号

    uint8 public decimals = 18; // 小数位数

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    // @dev 实现`transfer`函数，代币转账逻辑
    function transfer(
        address recipient,
        uint amount
    ) public override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // @dev 实现 `approve` 函数, 代币授权逻辑
    function approve(
        address spender,
        uint amount
    ) public override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // @dev 实现`transferFrom`函数，代币授权转账逻辑
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) public override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // @dev 铸造代币，从 `0` 地址转账给 调用者地址
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // @dev 销毁代币，从 调用者地址 转账给  `0` 地址
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

// ERC20代币的水龙头合约
contract Faucet {
    uint256 public amountAllowed = 100; // 每次领 100 单位代币
    address public tokenContract; // token合约地址
    mapping(address => bool) public requestedAddress; // 记录领取过代币的地址

    // SendToken事件
    event SendToken(address indexed Receiver, uint256 indexed Amount);

    // 部署时设定ERC2代币合约
    constructor(address _tokenContract) {
        tokenContract = _tokenContract; // set token contract
    }

    // 用户领取代币函数
    function requestTokens() external {
        require(!requestedAddress[msg.sender],"one time fo one address");   //一个地址只能领一次
        IERC20 token = IERC20(tokenContract);

        //判断还有没有水可以领
        require(tokenContract.balanceOf(address(this)) >= amountAllowed,"faucet empty");

        token.transfer(msg.sender, amountAllowed);

        //标记领过了
        requestedAddress[msg.sender] = true;

        //send event
        emit SendToken(msg.sender,amountAllowed);

    }
}
