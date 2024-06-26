// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

}


contract ERC20 is IERC20{

    uint public override totalSupply; //代币总供给
    mapping(address=>uint) public override balanceOf;

    mapping(address=>mapping(address=>uint)) public override allowance;
    
    string public name = "YTest"; //名称
    string public symbol = "YTest"; //符号
    uint8 public decimals = 18; //小数位数

    event Approval(address indexed owner ,address indexed spender ,uint256 value);
    event Transfer(address indexed from ,address indexed to ,uint256 value);

    constructor(string memory _name,string memory _symbol){
            name = _name;
            symbol = _symbol;
    }


    //代币转账
    function transfer(
        address recipient,
        uint256 amount 
    ) external override returns (bool){
         balanceOf[recipient]+=amount;
         balanceOf[msg.sender]-=amount;
    
        emit Transfer(msg.sender,recipient,amount);
         return true;
    }

    // 代币授权
    function approve(address spender, uint256 amount) external override returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    // 代币授权转账
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool){

        balanceOf[recipient]+=amount;
        balanceOf[sender]-=amount;
        allowance[sender][msg.sender]-=amount;

        emit Transfer(sender,recipient,amount);

        return true;
    }

    function mint(uint amount) public {
        balanceOf[msg.sender]+=amount;
        totalSupply+= amount;

        emit Transfer(address(0),msg.sender,amount);

    }

    function burn(uint amount) external{
        balanceOf[msg.sender]-=amount;
        totalSupply-= amount;

        emit Transfer(msg.sender,address(0),amount);
    }

}