// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Array{
    uint[] public nums = [1,2,3];
    uint[] public fixedNums = [4,5,6];

    modifier checkIdx(uint idx){
        require(idx<nums.length,"err idx");
        _;
    }

    function insert(uint idx,uint value) public checkIdx(idx){
        uint _value = nums[nums.length-1];
        for(uint i = nums.length-1;i>idx;i--){
            nums[i] = nums[i-1];
        }
        nums[idx] = value;
        nums.push(_value);
    }

    function get(uint idx) public  view checkIdx(idx) returns(uint) {
        return nums[idx];
    }

    function update(uint idx,uint value) public checkIdx(idx) {
          nums[idx] = value;  
    }

    function del(uint idx) public checkIdx(idx) {

        delete nums[idx];
    }

    function remove(uint idx) public  checkIdx(idx) returns (uint[] memory){
         for(uint i = idx;i<nums.length-1;i++){
            nums[i] = nums[i+1];
        }
        nums.pop();
        return  nums;
    }


    function remove(uint[] memory arr,uint idx) public view checkIdx(idx) returns (uint[] memory){

        uint[] memory _arr = new uint[](arr.length-1);

         for(uint i = 0;i<arr.length;i++){
            if(i<idx){
                _arr[i] = arr[i];
            }else{
                _arr[i] = arr[i+1];
            }
        }
        return  _arr;
    }

    function length() public view  returns (uint){
        return nums.length;
    }

    function retArr() public view returns (uint[] memory){
        return nums;
    }


}