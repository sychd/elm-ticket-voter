module Entity.Vote exposing (Vote, VoteId, emptyVote, emptyVoteId)

import Entity.User exposing (User, emptyUserId)


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
