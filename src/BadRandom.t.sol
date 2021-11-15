// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";
import "./test/utils/Hevm.sol";

import "./BadRandom.sol";

contract BadRandomTest is DSTest {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);
    BadRandom prng;

    function setUp() public {
        prng = new BadRandom();
    }

    /**
     * @notice The 'random' number returned is totally determined
     *  by the (manipulable) `block.timestamp`. It's easy to calculate
     *  the return value for every possible block number. 
     */
    function test_random_number_from_block_timestamp() public {
        assertEq(prng.worstRandom(), 47);

        // Change block timestamp to 1
        hevm.warp(1);

        assertEq(prng.worstRandom(), 98);
    }

    function test_random_number_from_block_timestamp_plus_nonce() public {
        assertEq(prng.extremelyBadRandom(), 98);

        // Change block timestamp to 1
        hevm.warp(1);

        assertEq(prng.extremelyBadRandom(), 83);
    }

    /**
     * @notice Run the tests with `dapp test --verbosity 2` to see the logging output
     *  from these tests. Note that we can only manipulate the block timestamp and 
     *  block number using Hevm cheat codes. The rest of the block parameters are set
     *  to default values of zero. In the real world, there would be more variation 
     *  across these parameters, although most of them would still be predictable.  
     */
    function test_random_number_from_multiple_block_parameters_plus_nonce()
        public
    {
        _log_block_params();
        assertEq(prng.veryBadRandom(), 73);

        hevm.warp(1);
        // Change block number to 3
        hevm.roll(3);
        _log_block_params();

        assertEq(prng.veryBadRandom(), 53);
    }

    function test_random_number_from_multiple_block_parameters_plus_nonce_plus_lehmer_rng()
        public
    {
        assertEq(prng.badRandom(), 11);

        hevm.warp(1);
        hevm.roll(3);
        assertEq(prng.badRandom(), 71);

        hevm.warp(2);
        hevm.roll(5);
        assertEq(prng.badRandom(), 62);
    }


    function _log_block_params() internal {
        emit log_named_uint("block.timestamp", block.timestamp);
        emit log_named_uint("block.difficulty", block.difficulty);
        emit log_named_address("block.coinbase", block.coinbase);
        emit log_named_uint("block.gaslimit", block.gaslimit);
        emit log_named_uint("block.number", block.number);
    }
}
