module Entity.Vote exposing (Vote, emptyVoteId)

import Entity.Author exposing (Author)


type VoteId
    = VoteId Int


type alias Vote =
    { id : VoteId
    , author : Author
    , value : Float
    }


emptyVoteId : VoteId
emptyVoteId =
    VoteId -1
