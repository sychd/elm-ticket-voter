module Entity.User exposing (User, UserId, emptyUser, emptyUserId, userDecoder)

import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)


type UserId
    = UserId Int


type alias User =
    { id : UserId
    , nickname : String
    }


emptyUserId : UserId
emptyUserId =
    UserId -1


emptyUser : User
emptyUser =
    { id = emptyUserId, nickname = "" }


userDecoder : Decoder User
userDecoder =
    Decode.succeed User
        |> required "id" userIdDecoder
        |> required "nickname" string


userIdDecoder : Decoder UserId
userIdDecoder =
    Decode.map UserId int
