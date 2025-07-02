// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/SimpleAccount.sol";
import "../src/SimpleAccountFactory.sol";
import "../src/MockContract.sol";
import "@account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract TestSimpleAccount is Test {
    SimpleAccountFactory public factory;
    SimpleAccount public account;
    MockContract public mockContract;
    IEntryPoint public entryPoint;
    
    address public owner;
    uint256 public ownerPrivateKey;
    
    // EntryPoint v0.7.0 address
    address constant ENTRY_POINT_ADDRESS = 0x0000000071727De22E5E9d8BAf0edAc6f37da032;
    
    function setUp() public {
        // Generar owner y private key
        ownerPrivateKey = 0x1234567890123456789012345678901234567890123456789012345678901234;
        owner = vm.addr(ownerPrivateKey);
        
        // Deploy mock del EntryPoint (ya que no tenemos acceso directo en test)
        entryPoint = IEntryPoint(ENTRY_POINT_ADDRESS);
        
        // Deploy factory
        factory = new SimpleAccountFactory(entryPoint);
        
        // Deploy mock contract para testing
        mockContract = new MockContract();
        
        console.log("Owner address:", owner);
        console.log("Factory address:", address(factory));
        console.log("Mock contract address:", address(mockContract));
    }
    
    function testCreateAccount() public {
        uint256 salt = 0;
        
        // Crear account usando factory
        account = factory.createAccount(owner, salt);
        
        console.log("Account address:", address(account));
        
        // Verificar que la account fue creada correctamente
        assertEq(account.owner(), owner);
        assertEq(address(account.entryPoint()), ENTRY_POINT_ADDRESS);
    }
    
    function testExecuteFunction() public {
        uint256 salt = 0;
        
        // Crear account
        account = factory.createAccount(owner, salt);
        
        // Preparar la llamada al mock contract
        uint256 newValue = 42;
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", newValue);
        
        // Ejecutar desde el owner (no desde EntryPoint para simplificar)
        vm.prank(owner);
        account.execute(address(mockContract), 0, callData);
        
        // Verificar que la llamada fue exitosa
        assertEq(mockContract.getValue(), newValue);
        assertEq(mockContract.getLastCaller(), address(account));
        
        console.log("Value set successfully:", mockContract.getValue());
        console.log("Last caller:", mockContract.getLastCaller());
    }
    
    function testExecuteBatch() public {
        uint256 salt = 0;
        
        // Crear account
        account = factory.createAccount(owner, salt);
        
        // Preparar batch de llamadas
        address[] memory destinations = new address[](2);
        uint256[] memory values = new uint256[](2);
        bytes[] memory callDatas = new bytes[](2);
        
        destinations[0] = address(mockContract);
        destinations[1] = address(mockContract);
        values[0] = 0;
        values[1] = 0;
        callDatas[0] = abi.encodeWithSignature("setValue(uint256)", 100);
        callDatas[1] = abi.encodeWithSignature("setValue(uint256)", 200);
        
        // Ejecutar batch
        vm.prank(owner);
        account.executeBatch(destinations, values, callDatas);
        
        // La última llamada debería haber establecido el valor a 200
        assertEq(mockContract.getValue(), 200);
        
        console.log("Batch execution successful, final value:", mockContract.getValue());
    }
    
    function testGetAddress() public {
        uint256 salt = 0;
        
        // Obtener dirección calculada
        address predictedAddress = factory.getAddress(owner, salt);
        
        // Crear account
        SimpleAccount createdAccount = factory.createAccount(owner, salt);
        
        // Verificar que coinciden
        assertEq(address(createdAccount), predictedAddress);
        
        console.log("Predicted address:", predictedAddress);
        console.log("Actual address:", address(createdAccount));
    }
    
}