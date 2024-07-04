// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignificantBit {
    event Log(uint256 a);
    //10101010 ->7
    //步骤检查 `x` 是否大于或等于 `2^n`（n为128，64，32等），并根据条件判断适当地右移 `x` 并更新 `r`
    function findMostSignificantBit(uint256 x) public pure returns (uint8 r) {

        for(uint i = 7;i>0;i--){
            uint power = 1 << i; // 使用位移操作计算 2 ** power
            if (x >= (1 << power)) {
                x >>= power;
                r += uint8(power);
            }
        }

        if(x>=2){
            r+=1;
        }

    }
}
