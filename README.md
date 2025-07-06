**Proyecto de Cuenta Simplificada con Account Abstraction y Foundry**

**Descripción**

Este repositorio contiene un conjunto de smart contracts y pruebas automatizadas en Foundry para demostrar la funcionalidad de dos contratos principales:

* `SimpleAccount.sol`
* `SimpleAccountFactory.sol`

Además, incluye un contrato de prueba `MockContract.sol` para simular llamadas externas y verificar el comportamiento de las cuentas.

El objetivo es mostrar cómo desplegar cuentas basadas en el estándar de Account Abstraction (ERC-4337), ejecutar transacciones y gestionar depósitos en un EntryPoint simulado, todo ello cubierto por tests en Foundry.

---

## Estructura del Proyecto

```plaintext
├── src
│   ├── MockContract.sol         # Contrato de prueba para simular llamadas
│   ├── SimpleAccount.sol        # Implementación de la cuenta minimalista
│   └── SimpleAccountFactory.sol # Fábrica para crear cuentas con CREATE2 y proxies
│
├── test
│   └── SimpleAccountTest.t.sol  # Tests en Foundry para validar la funcionalidad
│
├── foundry.toml                 # Configuración de Foundry
└── README.md                    # Documentación del proyecto
```

---

## Requisitos

* [Foundry](https://github.com/foundry-rs/foundry) (cargo install forge)
* [Solidity](https://docs.soliditylang.org/) >= 0.8.23
* Node.js y NPM (solo si se desea integrar scripts adicionales)

---

## Instalación y Configuración

1. Clona el repositorio:

   ```bash
   git clone https://github.com/tu-usuario/tu-repo.git
   cd tu-repo
   ```

2. Instala Foundry (si no está instalado):

   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

3. Compila los contratos:

   ```bash
   forge build
   ```

---

## Descripción de los Contratos

### MockContract.sol

Contrato sencillo para pruebas que permite:

* Almacenar un valor (`value`).
* Registrar la última dirección que llamó (`lastCaller`).
* Emitir evento `ValueSet` en cada actualización.

### SimpleAccount.sol

Implementa una cuenta minimalista basada en `BaseAccount` de OpenZeppelin y ERC-4337:

* **Propietario**: clave única capaz de firmar operaciones de usuario.
* **EntryPoint**: punto de entrada para operaciones de Account Abstraction.
* **Funciones**:

  * `execute` / `executeBatch`: ejecutar llamadas externas.
  * Gestión de depósitos: `getDeposit`, `addDeposit`, `withdrawDepositTo`.
  * Validación de firma: `_validateSignature`.
  * Soporte para UUPS-upgradeable.

### SimpleAccountFactory.sol

Fábrica que permite desplegar cuentas con proxies y CREATE2:

* Despliega una implementación inmutable de `SimpleAccount`.
* `createAccount(owner, salt)`: devuelve la dirección de cuenta, enferma o existente.
* `getAddress(owner, salt)`: calcula la dirección contrafáctica antes de desplegar.

---

## Pruebas con Foundry

Todos los tests están en `test/SimpleAccountTest.t.sol` y cubren:

1. **Despliegue de la cuenta**: `testCreateAccount`.
2. **Ejecución directa como owner**: `testExecuteFunction`.
3. **Ejecución a través del EntryPoint simulado**: `testExecuteFromEntryPoint`.

Ejecuta los tests con:

```bash
forge test --match-contract TestSimpleAccount
```

---

## Uso

1. Despliega tu propio EntryPoint en una red de prueba o utiliza el mock.
2. Despliega la fábrica:

   ```solidity
   SimpleAccountFactory factory = new SimpleAccountFactory(entryPointAddress);
   ```
3. Crea una cuenta para tu dirección:

   ```solidity
   SimpleAccount account = factory.createAccount(myAddress, salt);
   ```
4. Usa `account.execute(...)` o `account.executeBatch(...)` para enviar transacciones.
5. Gestiona depósitos con `addDeposit`, `getDeposit` y `withdrawDepositTo`.

---

## Licencia

Este proyecto está bajo licencia **GPL-3.0**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## Autor

* **Tu Nombre** (@sphinxar)
* Muestra cómo implementar Account Abstraction con Solidity y Foundry.

*¡Gracias por usar este proyecto! Cualquier contribución es bienvenida.*
