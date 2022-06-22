//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC20.sol";
import "./_scapulatoken.sol";

 contract ScapulaRewardMinter is Ownable{
   IERC20 public SCAAP;
   ISCAAP public SCAPULA;
   mapping(address => uint) public rewards;

    constructor(address _SCAAPaddress) {
        SCAAP = IERC20(_SCAAPaddress);
        SCAPULA=ISCAAP(_SCAAPaddress);
    }
    
     function setReward(address account,uint256 amount)  public onlyOwner  {
        rewards[account] = amount;
    }

    function claimReward(address _address, address _spender) public{
        uint256 rewardAmount = rewards[_address];
        SCAPULA._mintReward(_address,rewardAmount);
       
        SCAAP.transferFrom(_spender,_address, rewardAmount);
    }

 }

 
