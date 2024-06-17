// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract ErrorHandling{
    uint num = 222;

    error MyError(address _addr,uint i);

    function testRequire(uint i) public pure {
        require(i <= 10, "i is greater than 10");
    }

    function testRevert(uint i) public pure {
        if (i > 10) {
            revert("i is greater than 10");
        }
    }

    function testAssert() public view {
        assert(num == 222);
    }

    function testCustomError(uint i) public view {
        if (i > 10) {
            revert MyError(msg.sender, i);
        }
    }
}