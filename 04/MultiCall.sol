
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestMultiCall{

    function func1() external view returns (uint,uint){
            return (1,block.timestamp);
    }

    function func2() external view returns (uint,uint){
            return (2,block.timestamp);
    }

    function getData1() external pure returns(bytes memory){
        return abi.encodeWithSignature("func1()");
    }
    
    function getData2() external pure returns(bytes memory){
        return abi.encodeWithSelector(this.func2.selector);
    }

}

contract MultiCall{

        function execute(address[] calldata funcs , bytes[] calldata data) external view returns (bytes[] memory){
            require(funcs.length == data.length,"not eq");

            bytes[] memory results = new bytes[](funcs.length);

            for(uint i = 0; i < funcs.length;i++){
               (bool succ,bytes memory res) = funcs[i].staticcall(data[i]);
               require(succ,"failed");
               results[i] = res;
            }

            return results;
        }

}