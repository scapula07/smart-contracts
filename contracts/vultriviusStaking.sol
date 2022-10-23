//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

// import "./VultrivviusGovernaceToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "./VultriviusNftMarketPlace.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

 interface IERC20MintableBurnable is IERC20 {
    function mint(address, uint256) external;

    function burnFrom(address, uint256) external;
}

 contract VultriviusONEStaking  is Ownable,ERC20,IERC721Receiver{
     uint public totalInvested;
     uint public endTimer;
     uint public startTimer;
     address public admin;
      uint internal _totalSupply; 

      
    mapping(address => uint) public balancesONE;

    address[] stakers;
   
    IERC20MintableBurnable public governaceToken;
    
    event NewInvestor (
        address investor
    );

    constructor( address _governaceToken) ERC20("Vultrivius Token", "V3T")  { 
           admin = msg.sender;
           governaceToken = IERC20MintableBurnable(_governaceToken);
            _mint(msg.sender, 10000 *10**decimals());
            _totalSupply =address(0).balance;
     }
  function stakeONE() external payable {
        
        if(balancesONE[msg.sender] == 0) {
            emit NewInvestor(msg.sender);   
        }

        balancesONE[msg.sender] += msg.value;
        governaceToken.mint(msg.sender, msg.value);
    }


    function stakeToken(uint _amountToken) external payable {
        
        if(balancesONE[msg.sender] == 0) {
            emit NewInvestor(msg.sender);   
        }
       transferFrom(msg.sender, address(this), _amountToken);
       uint amountTokenToOne =_amountToken / 4;
       balancesONE[msg.sender] += amountTokenToOne;
        governaceToken.mint(msg.sender, msg.value);
        stakers.push(msg.sender);
       }


  function unStake() external payable {
     uint amount =balancesONE[msg.sender];
      governaceToken.burnFrom(msg.sender, amount);
     payable(msg.sender).transfer(amount);
      balancesONE[msg.sender] =0;
     
  }

   function totalInvestment()  external returns(uint){

       totalInvested = address(this).balance;

      return totalInvested;
  }

   function totalEarnedReward() view external returns(uint){
    
       uint earned = 0;
       earned += totalInvested * (block.timestamp -  startTimer) / 1 minutes;
        
        return earned;
    }

   function startingTimer(uint _value) external returns (uint256) {
       uint time = _value + 1 minutes;
      endTimer = block.timestamp + time;
      startTimer=block.timestamp;

      return  endTimer ;
   }
  

  
   function purchaseNftItem(address _marketplaceAddrr, uint _itemId) external onlyOwner {
        require( block.timestamp >= endTimer,"deadline is not yet reached");
        VultriviusMarketplace marketplace=  VultriviusMarketplace( _marketplaceAddrr);
        marketplace.purchaseItemWithONE{value:address(this).balance}( _itemId);

   }

   function transferNft(address _nftAddress,uint _tokenId,uint _num )  external onlyOwner{
       require( block.timestamp >= endTimer,"deadline is not yet reached");
       address winner =stakers[_num]
       IERC721(_nftAddress).transferFrom(address(this), winner,_tokenId);

   }

   function vrf() public view returns (bytes2 result) {
    uint[1] memory bn;
    bn[0] = block.number;
    assembly {
      let memPtr := mload(0x40)
      if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
        invalid()
      }
      result := mload(memPtr)

  
     
    }
  }

  function randomNum() public view returns(uint256){ 
      bytes2  vrfValue =vrf();
      uint32 num = uint32(bytes4(vrfValue));

      return uint256(num);
  
  }

   function totalStakers() view external  returns(uint){
       return stakers.length;
       }


    function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
      require(from == address(0x0), "Cannot send nfts to Vault directly");
      return IERC721Receiver.onERC721Received.selector;
    }
  

  
}


