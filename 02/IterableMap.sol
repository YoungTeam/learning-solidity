// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IterableMap{
    mapping(address=>uint) public balances;
    mapping(address=>bool) public inserted;
    address[] public keys;

    function set(address _addr,uint _val) external  {

        balances[_addr] = _val;
        if(!inserted[_addr]){
            inserted[_addr] = true;
        }
        
        keys.push(_addr);

    }

    function getSize() view public returns (uint) {
        return keys.length;
    }

    function first() view public returns (uint) {
        return balances[keys[0]];
    }

    function last() view public returns (uint) {
        return balances[keys[keys.length-1]];
    }

    function get(uint idx) view public returns (uint) {
        require(idx<keys.length && idx >= 0,"idx err");
        return balances[keys[idx]];
    }

}