// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NoLossToken is ERC20 {

 //Main variables
  address payable public owner;
  address payable public minter;
  address payable public commissionAddress;
  uint public commissionPercentage;

  //Events
  event TokenMinted(address indexed from, address to);
  event MinterChanged(address indexed from, address to);
  event commissionAddressChanged(address indexed from, address to);
  event commissionPercentageChanged(address indexed from, uint percentage);
  event tokenMintedToPayUnfreeze(address receiverAddress, uint amount);
  event ownerMinted(address receiverAddress, uint amount);
  event tokenBurnt(address burnerAddress, uint amount);
  
   constructor() payable ERC20("NoLoss Token", "NLT") {
    owner = payable(address(msg.sender));
    minter = payable(address(msg.sender));
    commissionAddress = payable(address(msg.sender));
  }
  
  modifier authorizedOwner(){
    require(msg.sender == owner, "Not Authorized");
    _;
  }
  
  modifier authorizedToMint(){
    require(msg.sender == minter || msg.sender == owner, "Not Authorized");
    _;
  }
  
  //Assign Minter 
  function passMinterRole(address newMinter) public payable authorizedOwner returns (bool){
    minter = payable(address(newMinter));
    emit MinterChanged(msg.sender, newMinter);
    return true;
  }
  
  //Assign commissionAddress 
  function passcommissionAddress(address newCommissionAddress) public payable authorizedOwner returns (bool){
    commissionAddress = payable(address(newCommissionAddress));
    emit commissionAddressChanged(msg.sender, newCommissionAddress);
    return true;
  }
  
  //Assign commissionAddress 
  function changeCommissionPercentage(uint percentage) public payable authorizedOwner returns (bool){
    commissionPercentage = percentage;
    emit commissionPercentageChanged(msg.sender, percentage);
    return true;
  }
  
  //Mint For UnFreeze
  function mintForUnFreeze(address receiverAddress, uint256 amount) public payable authorizedToMint {
	_mint(receiverAddress, amount);
    	uint commissionAmount = (amount*commissionPercentage)/100;
    	_mint(commissionAddress, commissionAmount);
    	emit tokenMintedToPayUnfreeze(receiverAddress, amount);
  }
  
  //Mint By Owner
  function mint(address receiverAddress, uint256 amount) public payable authorizedOwner {
	_mint(receiverAddress, amount);
   	emit ownerMinted(receiverAddress, amount);
  }
  
  function burn(uint256 amount) public {        
    _burn(msg.sender, amount);   
    emit tokenBurnt(msg.sender, amount);
  }    
  
  
} 
 
