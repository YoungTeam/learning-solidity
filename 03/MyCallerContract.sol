// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyCallerContract{

    function setTargetX(MyTargetContract target,uint x) public {

        target.setX(x);
    }

    function getTargetX(address target) public  view returns (uint){
          return MyTargetContract(target).getX();
    }


    function setXWithEther(MyTargetContract target,uint x) public payable{
            target.setXAndReceiveEther{value:msg.value}(x);
    }

    function getXAndValueFromTarget(address target) public view returns(uint,uint){
        return MyTargetContract(target).getXAndValue();
    }

}

contract MyTargetContract{
    uint public x;
    uint public value;

    function setX(uint _x) public {
        x = _x;
    }

    function getX() public view returns (uint){
        return x;
    }

    function setXAndReceiveEther(uint _x) external payable{
        x = _x;
        value = msg.value;
    }

    function getXAndValue() public view returns(uint,uint) {
        return (x,value);
    }
}