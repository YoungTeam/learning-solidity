// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Caller {
    uint public num;

    function setNum(address _callee,uint _num) public {
        (bool success, ) = _callee.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );
        require(success, "Delegatecall failed");
    }
}

contract Callee {

    uint public num;
    function setNum(uint _num) public {
        num = _num;
    }
}
