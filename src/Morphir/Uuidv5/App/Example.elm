module Morphir.Uuidv5.App.Example exposing (..)

import Result
import Bitwise
import Bitwise exposing (shiftRightZfBy)
import Bitwise exposing (or)
import Bitwise exposing (shiftLeftBy)

unescape: String -> String
unescape value =
    -- todo implement me
    value

-- note this is in elm/url
percentEncode: String -> String
percentEncode value =
    -- todo implement me
    -- unicode ❤️ broken until then
    value

utf8Escape: String -> String
utf8Escape value =
    -- based on http://ecmanaut.blogspot.com/2006/07/encoding-decoding-utf8-in-javascript.html
    percentEncode value
    |> unescape

-- note: handled more elegantly here 
-- https://github.com/zwilias/elm-utf-tools/blob/master/src/String/UTF8.elm#L90
stringToBytes: String -> List Int
stringToBytes value =
    utf8Escape value 
    |> String.toList
    |> List.map Char.toCode

isValidUuid : String -> Bool
isValidUuid _ =
    -- todo implement
    -- [0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
    -- Char.isAlphaNum
    True

validateUUID: String -> Result String String
validateUUID value =
    -- todo implement me
    Ok(value)

parseUUID: String -> List Int
parseUUID _ =
    -- todo validate
    -- todo build int array of 16
    -- {aaaaaa}-{bbbb}-{cccc}-{dddd}-{eeeeee}
    []

sha1: List Int -> List Int
sha1 _ =
    -- todo implement me
    -- see http://www.movable-type.co.uk/scripts/sha1.html
    []

rotl: Int -> Int -> Int
rotl x n =
    or (shiftLeftBy x n)  (shiftRightZfBy x (32-n))

sha1Hash: String -> String
sha1Hash input =
    let
        -- Based on http://www.movable-type.co.uk/scripts/sha1.html
        escaped = utf8Escape input
        -- constants [§4.2.1]
        constants = [ 0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6 ]
        -- initial hash value [§5.3.1]
        _ = [ 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 ]
        -- PREPROCESSING [§6.1.1]
        -- add trailing '1' bit (+ 0's padding) to string
        end = Char.fromCode(0x80) |> String.fromChar
        message = escaped ++ end
        -- convert string message into 512-bit/16-integer blocks arrays of ints [§5.2.1]
        -- length (in 32-bit integers) of message + ‘1’ + appended length
        length = (String.length message) // 4 + 2
        -- number of 16-integer-blocks required to hold 'length' ints
        numberOfBlocks = ceiling (toFloat length / 16)
        -- todo of size numberOfBlocks
        _ = List.range 0 (numberOfBlocks - 1)
    in
    message
    -- todo

-- version 0x50 (sha1) or 0x30 (md5)

createUUIDBytes: List Int -> List Int -> Result String (List Int)
createUUIDBytes name namespace =
    List.append namespace name
    |> sha1
    |> Ok
    -- todo implement me
    -- bytes[6] = (bytes[6] & 0x0f) | version;
    -- bytes[8] = (bytes[8] & 0x3f) | 0x80;

toHexString : Int -> String
toHexString _ =
    -- todo implement me
    ""

byteToHex: Int -> String
byteToHex i =
    toHexString (i + 0x100)
    -- eg 10a -> 0a
    |> (String.dropLeft 1 )
    
bytesToHex : List String
bytesToHex = 
    List.range 0 256
    |> List.map byteToHex

bytesToFormattedString: List Int -> String
bytesToFormattedString _ =
    -- todo implement me
    -- format as {aaaaaa}-{bbbb}-{cccc}-{dddd}-{eeeeee}
    ""

-- v5
generateUUIDv5: (String, String) -> Result String String
generateUUIDv5 (value, namespace) =
    let
        name = stringToBytes value
        ns = parseUUID namespace
    in
    createUUIDBytes name ns
    |> Result.map bytesToFormattedString
