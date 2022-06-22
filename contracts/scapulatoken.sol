//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/binodnp/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
 
 
  contract ScapulaToken is ERC20,Ownable{
      
         uint internal _totalSupply; 
        
      constructor(uint _initialsupply) ERC20("Scapula", "SCAAP") {
         _mint(msg.sender, _initialsupply *10**decimals());
         _totalSupply =address(0).balance;
      }
       

        function _mintReward(address _minerAddress,uint amount) external onlyOwner {
        _mint(_minerAddress, amount);
        }

    }
   
   interface ISCAAP{
      function _mintReward(address _minerAddress,uint amount) external ;
   }
