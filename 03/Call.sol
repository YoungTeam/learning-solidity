// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestContract{
    event  Log(address caller,uint amount ,string msg);

    string public message;
    uint public num;

    function foo(string memory _msg, uint256 _num) public {
        message = _msg;
        num = _num;
    }
    
    receive() external payable { }

    fallback() external payable {
        emit Log(msg.sender,msg.value," fallback  was called");
    }

}

contract Caller{
    function callFoo(address _testContract, string memory _msg, uint256 _num) public {
        (bool succ,bytes memory data) =  _testContract.call{value:100}(abi.encodeWithSignature("foo(string,uint256)", _msg,_num));
        require(succ,"err");

    }
    function callNonExistentFunction(address _testContract) public {
        (bool succ,bytes memory data) =  _testContract.call(abi.encodeWithSignature("callNonExistentFunction(string,uint256)"));
        require(succ,"call none failed");
    }
}