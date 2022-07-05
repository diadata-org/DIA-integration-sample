// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { IntegrationSample } from "./../src/IntegrationSample.sol";

/**
* @title Tests for IntegrationSample 
*/

interface IDIAOracleV2{
    function getValue(string memory) external returns (uint128, uint128);
}

contract TestOracleSample is Test {
    address immutable ORACLE = 0xa93546947f3015c986695750b8bbEa8e26D65856;

    function setUp() public {
    }

    /**
    * @dev Test that the storage varibles in the sample contract are
    * equal to values returned from DIAOracle 
    * */
    function testPriceInfo() public {
        IntegrationSample sampleContract = new IntegrationSample();

        sampleContract.getPriceInfo("ETH/USD");

        uint128 priceFromSample = sampleContract.latestPrice(); 
        uint128 timestampFromSample = sampleContract.timestampOflatestPrice(); 

        (uint128 priceFromOracle, uint128 timestampFromOracle) = 
            IDIAOracleV2(ORACLE).getValue("ETH/USD");

        assertEq(priceFromSample, priceFromOracle);
        assertEq(timestampFromSample, timestampFromOracle);
    }

    /**
     * @dev Fuzzy test that checks if the bool returned from checkPriceAge in
     * the sample contract is correct. 
     */
    function testCheckPriceAge(uint256 maxTimePassed256) public {
        maxTimePassed256 = bound(maxTimePassed256, 1, 10000);
        uint128 maxTimePassed = uint128(maxTimePassed256);

        IntegrationSample sampleContract = new IntegrationSample();
        sampleContract.getPriceInfo("ETH/USD");

        bool inTime = sampleContract.checkPriceAge(maxTimePassed);

         (, uint128 oracleTimestamp) =
            IDIAOracleV2(ORACLE).getValue("ETH/USD");

         bool inTimeOracle;

         if((block.timestamp - oracleTimestamp) < maxTimePassed){
             inTimeOracle = true;
         } else {
             inTimeOracle = false;
         }
         assertEq(inTimeOracle, inTime);
    }
}
