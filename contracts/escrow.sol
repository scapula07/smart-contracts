//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

contract Escrow {
      address payable public buyer;
      address payable public seller;
      uint amount;
      uint public constant DURATION =15 minutes;
      uint public immutable end;
      
      struct Transaction{
            address payable buyer;
            address payable seller;
            uint amount;
      }

      mapping(address=>uint) balances;
      Transaction transaction;
      Transaction[] transactions;
   
     

      enum STATE {
            AWAITING_PAYMENT,
            AWAITING_DELIVERY,
            COMPLETE
      }
      
      STATE transactionState;

      event NewDeposit(
            address seller,
            address buyer,
            uint amount,
            uint time
        
      );
     
      

  constructor(address  payable _seller, address _buyer, uint _amount)  {
        
       seller =_seller;
       buyer =payable(_buyer);
      amount =_amount;
      end =block.timestamp + DURATION;

  }

     modifier onlyBuyer() {
           require(msg.sender == buyer, "must be a buyer");
           _;
     }
     modifier isState (STATE expected){
          require(transactionState==expected,"");
          _;
     }
   
        
     modifier deadLine (){
       require (block.timestamp > end,"Deadline");
          _;
      }
   
     

     function deposit( ) onlyBuyer isState(STATE.AWAITING_PAYMENT)  external payable{
          require(msg.value==amount,'Amount should not enough');
          transaction.amount =msg.value;
          transactionState =STATE.AWAITING_DELIVERY;
       }
      function confirmDelivery() onlyBuyer isState(STATE.AWAITING_DELIVERY) external {
          seller.transfer(address(this).balance);

          transactionState=STATE.COMPLETE;
          emit NewDeposit(seller ,buyer, amount,block.timestamp);

      }
      function balanceOf() external view returns(uint){
          return address(this).balance;
              

      }
     
       function getTransactions() external  returns( Transaction[] memory){
             transaction.buyer=buyer;
             transaction.seller=seller;

             transactions.push(transaction);
             return transactions;



       }
       
       function terminate() external deadLine() {
             refund();
       }
      

      
     
       function refund() onlyBuyer public {
            require(block.timestamp <= end,"Deadline reached");
             buyer.transfer(address(this).balance);

     

     }
    
}

contract Terminate {


      

}