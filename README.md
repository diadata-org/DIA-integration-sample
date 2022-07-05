# DIAOracle Sample Contract

To use a DIA oracle in your own contract you must call one of our deployed oracle. DIA oracles are 
deployed on many EVM-chains, a complete list of deployed contracts can be found 
[here](https://docs.diadata.org/documentation/oracle-documentation/deployed-contracts). 


## Sample Contract

```
pragma solidity ^0.8.13;

interface IDIAOracleV2{
    function getValue(string memory) external returns (uint128, uint128);
}

contract IntegrationSample{

    address immutable ORACLE = 0xa93546947f3015c986695750b8bbEa8e26D65856;
    uint128 public latestPrice; 
    uint128 public timestampOflatestPrice; 
   
    function getPriceInfo(string memory key) external {
        (latestPrice, timestampOflatestPrice) = IDIAOracleV2(ORACLE).getValue(key); 
    }
   
    function checkPriceAge(uint128 maxTimePassed) external view returns (bool inTime){
         if((block.timestamp - timestampOflatestPrice) < maxTimePassed){
             inTime = true;
         } else {
             inTime = false;
         }
    }
}
```

The IntegrationSample contract is provided to show you how to use a oracle contract. The first step is to define
the interface of the DIAOracleV2 contract so that it can be called externally.

```
interface IDIAOracleV2{
    function getValue(string memory) external returns (uint128, uint128);
}
``` 

In this sample contract we are using a DIA oracle deployed on the ethereum mainnet, we define
an immutable variable where the address of the oracle is saved. 

```
address immutable ORACLE = 0xa93546947f3015c986695750b8bbEa8e26D65856;
```

We also define two storage variables to save the price and timestamp retreived from the oracle.

```
uint128 public latestPrice; 
uint128 public timestampOflatestPrice; 
```

To retreive the price and timestamp from the oracle we create a function that calls the
oracle using the IDIAOracleV2 interface and the oracle address.

```
function getPriceInfo(string memory key) external {
        (latestPrice, timestampOflatestPrice) = IDIAOracleV2(ORACLE).getValue(key); 
    }
```

When using an oracle it is important to know if the price has been updated recently. In the sample
contract we create function that answers that questions. The function ```checkPriceAge``` takes an input ```maxTimePassed``` 
representing our limit on how old the price can be and returns a boolian that will be true
if the time since the price was last updates is ```< maxTimePassed``` and false otherwise.

```
function checkPriceAge(uint128 maxTimePassed) external view returns (bool inTime){
         if((block.timestamp - timestampOflatestPrice) < maxTimePassed){
             inTime = true;
         } else {
             inTime = false;
         }
}
```



