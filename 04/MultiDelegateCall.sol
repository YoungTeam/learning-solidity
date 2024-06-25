
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MultiDelegateCall{

        error DelegateFailed();

        function execute(bytes[] calldata data) external payable returns (bytes[] memory){
           
            bytes[] memory results = new bytes[](data.length);

            for(uint i = 0; i < data.length;i++){
               (bool succ,bytes memory res) = address(this).delegatecall(data[i]);
               if(!succ){
                revert DelegateFailed();
               }
               results[i] = res;
            }

            return results;
        }

}

contract TestDelegateMultiCall is MultiDelegateCall{
    event Log(address caller,string func,uint value);

    function func1(uint x,uint y) external{
        emit Log(msg.sender,"func1",x+y);
    }

    function func2() external returns(uint256){
        emit Log(msg.sender,"func2",2);
        return 111;
    }

    mapping(address=>uint) public balanceOf;
    function mint() external payable{
        balanceOf[msg.sender]+=msg.value;
    }

    function getData1(uint x,uint y) external pure returns(bytes memory){
         return abi.encodeWithSelector(TestDelegateMultiCall.func1.selector,x,y);
    }
    
    function getData2() external pure returns(bytes memory){
        return abi.encodeWithSelector(TestDelegateMultiCall.func2.selector);
    }

        
    function getMinData() external pure returns(bytes memory){
        return abi.encodeWithSelector(TestDelegateMultiCall.mint.selector);
    }
}
