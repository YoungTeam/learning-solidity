// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC721/ERC721.sol";

contract MyERC721 is ERC721 {

    constructor(string memory name_, string memory symbol_) ERC721(name_,symbol_){

    }

    function mint(address to, uint tokenId) external {
        _mint(to,tokenId);
    }
}

contract DutchAuction{

    IERC721 public nft;
    uint256 public nftId;

    address payable public seller;
    uint256 public startingPrice;
    uint256 public reservePrice; //底价
    uint256 public duration; //持续市场
    uint256 public startAt; //开始时间
    uint256 public endAt; //结束时间
    bool public ended; //是否结束
    address public highestBidder; //最高出价人

    event AuctionStarted(
        uint256 startingPrice,
        uint256 reservePrice,
        uint256 duration
    );
    event AuctionEnded(address winner, uint256 amount);
    event BidAccepted(address bidder, uint256 amount);

    constructor(
        address _nft,
        uint256 _nftId,
        uint256 _startingPrice,
        uint256 _reservePrice,
        uint256 _duration
    ) {

        require(_startingPrice > _reservePrice, "Starting price must be greater than reserve price");
        require(_duration > 0, "Duration must be greater than 0");
        seller = payable(msg.sender);

        nft = MyERC721(_nft);
        nftId = _nftId;
        startingPrice = _startingPrice;
        reservePrice = _reservePrice;
        duration = _duration;


    }


     function startAuction() external {
        require(seller == msg.sender,"Only seller can start");
        require(startAt == 0,"Already Start");
        //require(nft.ownerOf(nftId) == msg.sender, "Seller must own the NFT");

        nft.transferFrom(seller,address(this), nftId);

        startAt = block.timestamp;
        endAt = startAt + duration;

        emit AuctionStarted(startingPrice,reservePrice,duration);

     }

    function getCurrentPrice() public view returns (uint256) {

        require(startAt > 0, "Auction not started yet");
        require(block.timestamp <= endAt, "Auction already ended");

        uint256 discount =  (startingPrice - reservePrice) * (block.timestamp - startAt) / duration;
        return startingPrice - discount;

    }

     function bid() external payable {
        require(startAt > 0, "Auction not started yet");
        require(block.timestamp <= endAt && !ended,"Auction is  end");

        uint256 currPrice = getCurrentPrice();
        require(msg.value >= currPrice,"Not enough Money");

        highestBidder = msg.sender;
        uint refund =  msg.value - currPrice;
        
        if (refund > 0) { //退钱
            payable(msg.sender).transfer(refund);
        }

        seller.transfer(currPrice); //收钱

        //转移nft
        nft.transferFrom(address(this), msg.sender, nftId);
        
        emit AuctionEnded(highestBidder, currPrice);
        emit BidAccepted(highestBidder, currPrice);


     }

    function auctionEnded() external view returns (bool) {
        return ended || block.timestamp > endAt;
    }
}
