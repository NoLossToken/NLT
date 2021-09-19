// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;


contract secureNLT {
    
    //add minter variable
    address payable public president;
    address payable public manager;
    address payable public admin;
    
    event managerChanged(address indexed president, address newManager);
    event adminChanged(address indexed executive, address newAdmin);
    
    constructor() {
        president = payable(address(msg.sender));
        manager = payable(address(msg.sender));
        admin = payable(address(msg.sender));
    }
    
    modifier isPresident(){
        require(msg.sender == president, "Not Authorized");
        _;
    }
    
    modifier authorizedExecutive(){
        require(msg.sender == president || msg.sender == manager, "Not an Authorized Executive");
        _;
    }
    
    modifier authorizedStaff(){
        require(msg.sender == president || msg.sender == manager || msg.sender == admin, "Not an Authorized Staff");
        _;
    }
    
    function changeManager(address newManager) public payable isPresident returns (bool){
        manager = payable(address(newManager));
        emit managerChanged(msg.sender, newManager);
        return true;
    }
    
    function changeAdmin(address newAdmin) public payable authorizedExecutive returns (bool){
        manager = payable(address(newAdmin));
        emit adminChanged(msg.sender, newAdmin);
        return true;
    }
    
    
    
    struct userDatabase{
        string securedAmt;
        string guaranteedAmt;
        string borrowableAmt;
        string owningAmt;
        string depositIndex;
        string withdrawIndex;
    }
    mapping(address => userDatabase) userData;
    
    function getUserData(address _userAddress) public view returns(string memory, string memory, string memory, string memory, string memory, string memory) {
        return(
                userData[_userAddress].securedAmt, 
                userData[_userAddress].guaranteedAmt, 
                userData[_userAddress].borrowableAmt, 
                userData[_userAddress].owningAmt, 
                userData[_userAddress].depositIndex,
                 userData[_userAddress].withdrawIndex
            );
    } 
    
    function updateUserDepositData(address _userAddress, string calldata _securedAmt, string calldata _guaranteedAmt, string calldata _borrowableAmt, string calldata _depositIndex) public authorizedExecutive {
        userData[_userAddress].securedAmt = _securedAmt;
        userData[_userAddress].guaranteedAmt =  _guaranteedAmt;
        userData[_userAddress].borrowableAmt = _borrowableAmt;
        userData[_userAddress].depositIndex = _depositIndex;
    }
    
    //Initial deposit information fro BSC-----------------------
    
    struct userNLTransactionData{
        string  hash;
        address payable fro;
        address payable to;
        uint8  status;
    }
    userNLTransactionData[] depositData;
    
}
