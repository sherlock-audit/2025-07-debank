/*
    Copyright Debank
    SPDX-License-Identifier: BUSL-1.1
*/
pragma solidity ^0.8.25;

import "lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

contract UniswapV3TickBitmapLens {
    int16 MIN_WORD = -3466;
    int16 MAX_WORD = 3465;
    uint256 BATCH_SIZE = 100;

    function getPopulatedTickBitmapWords(address pool, int16 startWord) public view returns (int16[] memory words) {
        require(startWord >= MIN_WORD, "message1");
        require(startWord <= MAX_WORD, "message2");
        words = new int16[](BATCH_SIZE);
        uint256 i = 0;
        for (int16 word = startWord; word <= MAX_WORD; word++) {
            uint256 bitmap = IUniswapV3Pool(pool).tickBitmap(word);
            if (bitmap > 0) {
                words[i] = word;
                i++;
                if (i >= BATCH_SIZE) break;
            }
        }
        for (; i < BATCH_SIZE; i++) {
            words[i] = type(int16).max;
        }
    }
}
