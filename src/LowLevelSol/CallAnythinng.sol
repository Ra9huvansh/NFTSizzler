//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// In order to call a function using only the data field or call, we need to encode:
// The function name
// The parameters we want to add
// Down to the binary level

// Now each contract assigns each function it has a function ID. This is known as the "function selector".
// The "function selector" is the first 4 bytes of the function signature.
// The "function signature" is a string that defines the function name & parameters.
// Let's look at this

contract CallAnything{
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address someAddress, uint256 amount) public {
        s_someAddress = someAddress;
        s_amount = amount;
    }

    function getSelectorOne() public pure returns (bytes4 selector){
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
        return selector;
    }

    function getDataToCallTransfer(address someAddress, uint256 amount) public pure returns(bytes memory){
        return abi.encodeWithSelector(getSelectorOne(), someAddress, amount);
    }

    function callTransferFunctionDirectly(address someAddress, uint256 amount) public returns(bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            // getDataToCallTransfer(someAddress, amount)
            abi.encodeWithSelector(getSelectorOne(), someAddress, amount)
        );
        return (bytes4(returnData), success);
    }

    function callTransferFunctionDirectlySig(address someAddress, uint256 amount) public returns(bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            // getDataToCallTransfer(someAddress, amount)
            abi.encodeWithSignature("transfer(address,uint256)", someAddress, amount)
        );
        return (bytes4(returnData), success);
    }
}







contract CallFunctionWithoutContract {
    address public s_selectorsAndSignaturesAddress;

    constructor(address selectorsAndSignaturesAddress) {
        s_selectorsAndSignaturesAddress = selectorsAndSignaturesAddress;
    }

    // pass in 0xa9059cbb000000000000000000000000d7acd2a9fd159e69bb102a1ca21c9a3e3a5f771b000000000000000000000000000000000000000000000000000000000000007b
    // you could use this to change state
    function callFunctionDirectly(bytes calldata callData) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) =
            s_selectorsAndSignaturesAddress.call(abi.encodeWithSignature("getSelectorThree(bytes)", callData));
        return (bytes4(returnData), success);
    }

    // with a staticcall, we can have this be a view function!
    function staticCallFunctionDirectly() public view returns (bytes4, bool) {
        (bool success, bytes memory returnData) =
            s_selectorsAndSignaturesAddress.staticcall(abi.encodeWithSignature("getSelectorOne()"));
        return (bytes4(returnData), success);
    }

    function callTransferFunctionDirectlyThree(address someAddress, uint256 amount) public returns (bytes4, bool) {
        (bool success, bytes memory returnData) = s_selectorsAndSignaturesAddress.call(
            abi.encodeWithSignature("transfer(address,uint256)", someAddress, amount)
        );
        return (bytes4(returnData), success);
    }
}