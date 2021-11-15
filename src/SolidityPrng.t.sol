// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./SolidityPrng.sol";

contract SolidityPrngTest is DSTest {
    SolidityPrng prng;

    function setUp() public {
        prng = new SolidityPrng();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
