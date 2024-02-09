module Morphir.Uuidv5.App.Example exposing (..)
import Result exposing (andThen)

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
    []

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
