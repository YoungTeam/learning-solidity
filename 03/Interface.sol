// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICounter{
    function count() external view returns (uint);
    function update(uint value) external;
    function increment() external;
}

contract Counter is ICounter{
    
    uint public count;

    function update(uint value) public{
            count = value;
    }

    function increment() public{
            count++;
    }
}

contract CallCounter{
    function getCount(ICounter _addr) public view returns (uint){
        return ICounter(_addr).count();
    }

    function updateCount(ICounter _addr,uint value) public {
       return  ICounter(_addr).update(value);
    }

    function incrementCounter(ICounter _addr) public{
        ICounter(_addr).increment();
    }
}