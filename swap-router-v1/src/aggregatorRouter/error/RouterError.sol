/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/

pragma solidity ^0.8.25;

library RouterError {
    error AdapterExists();
    error AdapterDoesNotExist();
    error AdapterAddressZero();
    error IncorrectFeeReceiver();
    error FeeRateTooBig();
    error TokenPairInvalid();
    error IncorrectMsgValue();
    error SlippageLimitExceeded();
    error DelegatecallFailed();
    error Forbidden();
    error AdapterNotApproved();
}
