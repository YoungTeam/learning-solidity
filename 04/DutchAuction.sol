// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721{
    function transferFrom(address _from,address _to ,uint nfdId) external;
}

contract DutchAuction{
    uint private constant DURATION = 10 minutes;
    IERC721 public immutable nft;
    uint public immutable nftId;

    address public immutable seller;
    uint public immutable startPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(uint _startPrice,uint _discountRate,address _nft,uint _nftId){
        seller = payable(msg.sender);
        startPrice = _startPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        discountRate = _discountRate;

        require(_startPrice >= _discountRate * DURATION,"starting price < discount");

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns(uint){
            uint timeElapsed = block.timestamp - startAt;
            uint discount = discountRate * timeElapsed;
            return startPrice - discount;
    }

    function buy() external payable{
        require(block.timestamp < expiresAt,"expired");

        uint price = getPrice();
        require(msg.value >= price,"not enough eth");
        nft.transferFrom(seller,msg.sender,nftId);
        uint refund = msg.value - price;
        if(refund >0){
            payable(msg.sender).transfer(refund);
        }
    }
}