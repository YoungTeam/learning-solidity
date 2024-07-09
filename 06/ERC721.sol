// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed id
    );

    event Apporval(
        address indexed owner,
        address indexed spender,
        uint256 indexed id
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    mapping(uint => address) internal _ownerOf;

    mapping(address => uint) internal _balanceOf;

    mapping(uint => address) internal _approvals;

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    mapping(address => mapping(address => bool)) private _operatorApprovals;


    function supportsInterface(
        bytes4 interfaceId
    ) external view  override returns (bool) {
        
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
        
    }
    

    function balanceOf(address owner) external view returns(uint){
        require(owner!=address(0),"owner == address(0)");
        return  _balanceOf[owner];
    }

    function ownerOf(uint tokenId) external view returns(address owner){

        owner = _ownerOf[tokenId];
        require(owner!=address(0),"owner = addres 0");

    }

    function setApprovalForAll(address operator,bool _approved) external{
        require(operator != msg.sender, "ERC721: approve to caller");

        isApprovedForAll[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);

    }

    function approve(address to ,uint256 tokenId) external{
        address owner = _ownerOf[tokenId];
        require(

            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authoried"
        );  

        _approvals[tokenId] = to;
        emit Apporval(owner, to, tokenId);

    }


    function getApproved(uint256 tokenId) external view returns(address operator){
        require(_ownerOf[tokenId]!=address(0), "ERC721: approved query for nonexistent token");
        return _approvals[tokenId];
    }

    function _isApprovedOrOwner(address owner,address spender,uint tokenId) internal view returns (bool){
        return owner == spender ||
            isApprovedForAll[owner][spender] ||
            spender == _approvals[tokenId];
    }

    function transformFrom(address from,address to,uint256 tokenId) public{
        require(from == _ownerOf[tokenId],"from != owner");
        require(to != address(this),"to  = zero");

        require( _isApprovedOrOwner(from, msg.sender, tokenId)," not  authoried");

         _balanceOf[from]--;
         _balanceOf[to]++;

         _ownerOf[tokenId] = to;

         delete _approvals[tokenId];
         emit Transfer(from, to, tokenId);

    }

    function safeTransferFrom(address from,address to,uint256 tokenId) external{
            transformFrom(from,to,tokenId);
            require(to.code.length == 0 || IERC721Receiver(to).onERC721Received(msg.sender,from,tokenId,"")
            == IERC721Receiver.onERC721Received.selector ,"unsafe");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId,bytes calldata data) external{
        transformFrom(from,to,tokenId);
                    require(to.code.length == 0 || IERC721Receiver(to).onERC721Received(msg.sender,from,tokenId,data)
                    == IERC721Receiver.onERC721Received.selector ,"unsafe");
    }    


    function _mint(address to,uint tokenId) internal {
        require(to!=address(0),"zero address");
        require(_ownerOf[tokenId]==address(0),"token exist");

        _balanceOf[to]++;
        _ownerOf[tokenId] = to;
        emit Transfer(address(0),to,tokenId);

    }

    function _burn(uint tokenId) internal{
        address owner = _ownerOf[tokenId];
        require(owner!=address(0),"token dose not exist");

        _balanceOf[owner]--;
        delete _ownerOf[tokenId];
        delete _approvals[tokenId];

        emit Transfer(owner,address(0),tokenId);
    }


}



contract  MyNFT is ERC721{
    function mint(address to, uint tokenId) external{
        _mint(to, tokenId);
    }

    function burn(uint tokenId) external{
        require(msg.sender == _ownerOf[tokenId],"not owner");
        _burn(tokenId);
    }
}