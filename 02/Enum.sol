// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderDemo{

    enum OrderStatus{
        None, Pending, Shipped, Completed, Rejected, Cancelled
    }

    struct Order{
        address buyer;
        OrderStatus status;
    }


    Order[] public orders;

    function test() external  {
        Order memory o = Order({buyer: msg.sender,status:OrderStatus.Pending});
        add(o);
    }

    function add(Order memory _order) public   {
        orders.push(_order);
    }

    function set(uint idx,OrderStatus status) external{
        orders[idx].status = status;
    }

    function get(uint idx) external view returns (OrderStatus){
        return orders[idx].status;
    }


    function ship(uint idx) external{
         orders[idx].status = OrderStatus.Shipped;
    }

    function reSet(uint idx) external{
        delete orders[idx].status;
    }

}