// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl{
    event GrantLog(bytes32 indexed _role,address indexed _address);
    event RevokeLog(bytes32 indexed _role,address indexed _address);

    mapping(bytes32 => mapping(address=>bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));

    constructor(){
        _grantRole(ADMIN,msg.sender);
    }

    modifier onlyRole(bytes32 _role){
        require(roles[_role][msg.sender],"not authrized");
        _;
    }

    function _grantRole(bytes32 _role,address _address) internal {
        roles[_role][_address] = true;
    }

    function grantRole(bytes32 _role,address _address) external onlyRole(ADMIN){
        _grantRole(_role, _address);
        emit GrantLog(_role,_address);
    }

    function revokeRole(bytes32 _role,address _address) external onlyRole(ADMIN){
         roles[_role][_address] = false;
          emit RevokeLog(_role,_address);
    }

    function getHash(string calldata text) public pure returns(bytes32){
       return keccak256(abi.encodePacked(text));
    }
}