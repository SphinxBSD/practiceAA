// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

/**
 * Mock contract para testing
 * Simple contrato que permite testing de llamadas
 */
contract MockContract {
    uint256 public value;
    address public lastCaller;
    
    event ValueSet(uint256 newValue, address caller);
    
    function setValue(uint256 _value) external {
        value = _value;
        lastCaller = msg.sender;
        emit ValueSet(_value, msg.sender);
    }
    
    function getValue() external view returns (uint256) {
        return value;
    }
    
    function getLastCaller() external view returns (address) {
        return lastCaller;
    }
}