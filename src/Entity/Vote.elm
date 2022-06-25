module Entity.Vote exposing (Vote, VoteId, emptyVote, emptyVoteId, votesDecoder)

import Entity.User exposing (User, emptyUserId, userDecoder)
import Json.Decode as Decode exposing (Decoder, float, int, list)
import Json.Decode.Pipeline exposing (required)


type VoteId
    = VoteId Int


type alias Vote =
    { id : VoteId
    , author : User
    , value : Float
    }


emptyVoteId : VoteId
emptyVoteId =
    VoteId -1


emptyVote : Vote
emptyVote =
    { id = VoteId -1
    , author = User emptyUserId "test"
    , value = 0
    }


votesDecoder : Decoder (List Vote)
votesDecoder =
    list voteDecoder


voteDecoder : Decoder Vote
voteDecoder =
    Decode.succeed Vote
        |> required "id" voteIdDecoder
        |> required "author" userDecoder
        |> required "value" float


voteIdDecoder : Decoder VoteId
voteIdDecoder =
    Decode.map VoteId int
