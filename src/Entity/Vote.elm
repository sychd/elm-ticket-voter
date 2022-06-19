module Entity.Vote exposing (Vote, VoteId, emptyVote, emptyVoteId)

import Entity.Author exposing (Author, emptyAuthorId)


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


emptyVote : Vote
emptyVote =
    { id = VoteId -1
    , author = Author emptyAuthorId "test"
    , value = 0
    }
