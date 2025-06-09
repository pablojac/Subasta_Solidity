// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract Auction {

    address public owner;//Dirección del creador del contrato.
    uint public minValue = 0.1 ether;//Valor mínimo para la subasta (0.1 ether).
    uint public endTime;//Tiempo en el que termina la subasta.
    uint public highestBid;//Mayor oferta hasta ahora.
    address public highestBidder;//Dirección del postor con la mayor oferta
    bool public auctionEnded;//Booleano que indica si la subasta ha terminado

    //Almacena cuánto ofertó cada dirección
    mapping(address => uint) public bids;
    
    //NewBid: Se emite cuando se realiza una nueva oferta.
    //AuctionEnded: Se emite al finalizar la subasta.

    event NewBid(address indexed bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    

    //Guarda al msg.sender (creador) como owner.
    //Calcula el tiempo de finalización sumando _duration (en segundos) al tiempo actual.

    constructor(uint _duration) {
        owner = msg.sender;
        endTime = block.timestamp + _duration;
    }

    //Permite que ciertas funciones solo sean llamadas por el propietario.
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    //Permite que ciertas funciones solo se ejecuten mientras la subasta esté activa.

    modifier activeAuction() {
        require(block.timestamp < endTime, "La subasta ha finalizado.");
        _;
    }

    /*Cualquiera puede hacer una oferta (si la subasta está activa).

    La nueva oferta debe ser al menos un 5% mayor que la anterior.

    Si ya ofertaste antes, se te reembolsa tu oferta anterior.

    Se actualizan los valores y se emite el evento.*/

    function bid() external payable activeAuction {
        require(msg.value > highestBid * 105 / 100, "La oferta debe ser al menos un 5% superior.");

        /*Solo el propietario puede finalizarla.

        Solo se puede finalizar después del tiempo límite.

        Se transfiere el dinero al dueño y se marca como finalizada.*/

        if (bids[msg.sender] > 0) {
            payable(msg.sender).transfer(bids[msg.sender]); // Reembolso de ofertas previas
         
        }

        bids[msg.sender] = msg.value;
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit NewBid(msg.sender, msg.value);
    }

    function endAuction() external onlyOwner {
        require(!auctionEnded, "La subasta ya ha terminado.");
        require(block.timestamp >= endTime);

        auctionEnded = true;
        payable(owner).transfer(highestBid); // Transferencia de los fondos al dueño
        emit AuctionEnded(highestBidder, highestBid);
    }
    /*Permite a los perdedores retirar sus fondos.

    El ganador no puede retirar.

    Se cobra una comisión del 2%, devolviendo el 98% de lo ofertado.

    */
    function withdraw() external {
        require(auctionEnded);
        require(msg.sender != highestBidder, "El ganador no puede retirar.");

        uint refundAmount = bids[msg.sender] * 98 / 100; // Aplicando comisión del 2%
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(refundAmount);
        
    }
}   