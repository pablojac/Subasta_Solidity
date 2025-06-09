# **Smart Contract de Subasta en Solidity**

Este contrato implementa un sistema de subasta donde los usuarios pueden realizar ofertas, y el propietario puede finalizar la subasta, transfiriendo los fondos a su cuenta.

## **Características**

- **Subasta de un solo artículo**: Los usuarios pueden hacer ofertas en una subasta.
- **Requisitos de la oferta**: Cada oferta debe ser al menos un 5% mayor que la oferta anterior.
- **Reembolso de ofertas previas**: Si un usuario ya ha hecho una oferta, se le reembolsa la cantidad ofertada antes de hacer una nueva oferta.
- **Finalización de la subasta**: Solo el propietario puede finalizar la subasta, una vez que ha pasado el tiempo de finalización.
- **Retiro de fondos para los perdedores**: Los usuarios que no ganen la subasta pueden retirar el 98% de su oferta (se aplica una comisión del 2%).
- **Transferencia de fondos**: Al finalizar la subasta, el dinero se transfiere al propietario del contrato.

## **Variables**

- `owner`: Dirección del creador del contrato (propietario).
- `minValue`: Valor mínimo de la oferta (0.1 ether).
- `endTime`: Tiempo de finalización de la subasta (establecido en el momento de la creación).
- `highestBid`: La oferta más alta hasta el momento.
- `highestBidder`: Dirección de la persona que ha realizado la oferta más alta.
- `auctionEnded`: Booleano que indica si la subasta ha terminado o no.

## **Eventos**

- `NewBid`: Se emite cuando se realiza una nueva oferta.
- `AuctionEnded`: Se emite cuando se finaliza la subasta.

## **Funciones**

### **constructor(uint _duration)**
- **Descripción**: Inicializa el contrato configurando el propietario y la duración de la subasta.
- **Parámetros**:
  - `_duration`: Duración de la subasta en segundos.

### **bid()**
- **Descripción**: Permite realizar una oferta durante la subasta.
- **Requisitos**: La oferta debe ser al menos un 5% mayor que la anterior.
- **Reembolsos**: Si el usuario ha ofertado previamente, su oferta anterior se reembolsa.
- **Emite**: `NewBid(address indexed bidder, uint amount)`

### **endAuction()**
- **Descripción**: Permite al propietario finalizar la subasta. Solo el propietario puede ejecutar esta función.
- **Requisitos**: Solo puede ejecutarse después de la hora de finalización.
- **Emite**: `AuctionEnded(address winner, uint amount)`

### **withdraw()**
- **Descripción**: Permite a los perdedores retirar sus ofertas (con una comisión del 2%).
- **Requisitos**: No puede ser ejecutada por el ganador de la subasta.

## **Modificadores**

- **onlyOwner**: Asegura que solo el propietario del contrato pueda ejecutar ciertas funciones.
- **activeAuction**: Asegura que solo se pueda realizar una oferta mientras la subasta esté activa.

## **Instalación y Despliegue**

1. **Instalar dependencias**
   - Asegúrate de tener instalado [Node.js](https://nodejs.org/), y [Truffle](https://www.trufflesuite.com/truffle) o [Hardhat](https://hardhat.org/) como entorno de desarrollo para contratos inteligentes.

2. **Desplegar el contrato**
   - Usa Truffle o Hardhat para compilar y desplegar el contrato en la red de Ethereum (local, testnet o mainnet).

   **Ejemplo con Truffle**:
   - Compilar el contrato:
     ```bash
     truffle compile
     ```
   - Desplegar el contrato:
     ```bash
     truffle migrate --network <red_a_usar>
     ```

   **Ejemplo con Hardhat**:
   - Compilar el contrato:
     ```bash
     npx hardhat compile
     ```
   - Desplegar el contrato:
     ```bash
     npx hardhat run scripts/deploy.js --network <red_a_usar>
     ```

3. **Interactuar con el contrato**
   - Una vez desplegado, puedes interactuar con el contrato usando una interfaz de usuario (por ejemplo, con Web3.js o Ethers.js) o directamente a través de la consola de Truffle o Hardhat.

## **Consideraciones de Seguridad**

- **Reentrancy**: Este contrato utiliza `transfer` para transferir fondos, lo cual es relativamente seguro, pero siempre es recomendable revisar los contratos en busca de posibles vulnerabilidades como ataques de reentrancy.
  
- **Gas**: Asegúrate de que los valores de gas estén correctamente configurados para evitar fallos en la ejecución de funciones.

## **Licencia**

Este contrato está bajo la licencia MIT. Puedes usarlo, modificarlo y distribuirlo libremente, siempre que incluyas una copia de la licencia.
