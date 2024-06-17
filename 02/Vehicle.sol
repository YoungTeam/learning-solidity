// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VehicleContract{

    struct Vehicle{
        string  make;
        uint year;
        address owner;
    }

    Vehicle[] public cars;

    function example() external {
        Vehicle memory byd = Vehicle({make:"byd",year:2023,owner:msg.sender});
        cars.push(byd);

        Vehicle memory benz;
        benz.make = "benz";
        benz.year = 2000;
        benz.owner = msg.sender;


        cars.push(benz);

        cars[0].year = 2024;

        cars[1].year = 2011;

        delete cars[0];       

    }

}