// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
contract Counter {
   uint public count = 0;

   function inc() external{
        count++;
   }

   function dec() external{
        count--;
   }
}
