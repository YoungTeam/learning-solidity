// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeployWithContract2{
    address public owner;
    constructor(address _owner){
        owner = _owner;
    }
}

contract Create2Factory{

    event Deploy(address addr);

    function deploy(uint _salt) external{
        DeployWithContract2 deploy2 = new DeployWithContract2{salt:bytes32(_salt)}(msg.sender);
        emit   Deploy(address(deploy2));

    }

    function getAddress(bytes memory byteCode,uint salt) external view  returns(address){
        bytes32 hash = keccak256(
                abi.encodePacked(bytes1(0xff),address(this),salt,keccak256(byteCode))
            );

        return address(uint160(uint256(hash)));
    }

    function getByteCode(address _owner) public pure returns(bytes memory){
        bytes memory createCode =  type(DeployWithContract2).creationCode;
        return abi.encodePacked(createCode,abi.encode(_owner));
    }
}