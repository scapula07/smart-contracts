//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC20.sol";


contract PaymentProcessor{
    address public admin;
    IERC20 public eseh;

    event PaymentDone(
        address payer,
        uint amount,
        string paymentId,
        uint date

    );

    constructor(address _adminAddress, address _esehAddress) {
        admin=_adminAddress;
        eseh=IERC20(_esehAddress);
    }

    function pay(uint _amount,string  memory _paymentId,address _payer) external{
        eseh.transferFrom(_payer,admin,_amount);
        emit PaymentDone(_payer,_amount,_paymentId,block.timestamp);

    }
}