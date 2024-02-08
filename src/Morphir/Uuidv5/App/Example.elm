module Morphir.Uuidv5.App.Example exposing (..)

import UUID exposing (UUID, Error)
import Bytes exposing (Bytes)
import Bytes.Encode

toBytes : String -> Bytes
toBytes name = 
   Bytes.Encode.sequence
        [ Bytes.Encode.unsignedInt32 Bytes.BE (String.length name)
        , Bytes.Encode.string name
        ]
    |>  Bytes.Encode.encode 

build : String -> UUID -> UUID
build name namespace =
    let
        bytes = toBytes name
    in
    -- forBytes creates a version 5 uuid from bytes and the namespace uuid
    UUID.forBytes bytes namespace

v5 : String -> String -> Result Error String
v5 name ns =
    UUID.fromString ns
    |> Result.map 
        (\(namespace) ->
            build name namespace
        )
    |> Result.map 
        UUID.toString


