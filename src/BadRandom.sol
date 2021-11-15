// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

contract BadRandom {
    uint256 nonce;

    /**
     * @notice Returns a 'random' number based on the block timestamp.
     *  Besides just returning 9 or something, this is about the worst
     *  pseudorandomness you can get, because miners can control the
     *  `block.timestamp` value and manipulate the 'random' output.
     */
    function worstRandom() public view returns (uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp)));
        return seed % 100;
    }

    /**
     * @notice We can improve this a little by adding a nonce (number only
     *  used once) that increments on each call. Now it's harder to force
     *  a specific output by manipulating `block.timestamp`.
     */
    function extremelyBadRandom() public returns (uint256) {
        nonce++;
        uint256 seed = uint256(
            keccak256(abi.encodePacked(nonce + block.timestamp))
        );
        return seed % 100;
    }

    /**
     * @notice We can take this a step further and use additional block
     *  parameters in combination, like the `block.difficulty`, `block.basefee`,
     *  `block.coinbase`, `block.gaslimit`, and `block.number`. All of these
     *  parameters are predictable or manipulable by the miner, but using them
     *  in combination makes it harder to manipulate them all at once.
     */
    function veryBadRandom() public returns (uint256) {
        nonce++;
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(
                    nonce +
                        block.timestamp +
                        block.difficulty +
                        uint256(keccak256(abi.encodePacked(block.coinbase))) +
                        block.gaslimit +
                        block.number
                )
            )
        );
        return seed % 100;
    }

    /**
     * @notice We can even tack on a simple real-world PRNG. However, all these
     *  approaches are still deterministic! These are all bad, predictable 
     *  pseudorandom sources that can be controlled by a sufficiently motivated 
     *  miner or contract caller. To get real, reliable entropy on chain it has
     *  to come from the outside world!
     */
    function badRandom() public returns (uint256) {
        uint256 seed = veryBadRandom() * 16807 % 2147482647;
        return seed % 100;
    }
}
