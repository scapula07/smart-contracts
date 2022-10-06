//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

// import "./VultrivviusGovernaceToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

 interface IERC20MintableBurnable is IERC20 {
    function mint(address, uint256) external;

    function burnFrom(address, uint256) external;
}

 contract VultriviusONEStaking  {

    mapping(address => uint) public balances;

    IERC20MintableBurnable public paymentToken;
    
    event NewInvestor (
        address investor
    );

    constructor( address _governaceToken) { 
          
     }
  function stake() external payable {
        
        if(balances[msg.sender] == 0) {
            emit NewInvestor(msg.sender);   
        }
        balances[msg.sender] += msg.value;
    }

  function unStake() external payable {
     uint amount =balances[msg.sender];
     payable(msg.sender).transfer(amount);
     
  }

   function totalInvestment() view external returns(uint){

      uint totalInvested = address(this).balance;

      return totalInvested;
  }


}
