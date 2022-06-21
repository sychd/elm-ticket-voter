module Entity.Ticket exposing (..)

import Entity.User exposing (User, UserId, emptyUser, emptyUserId)
import Entity.Vote exposing (Vote, emptyVote, emptyVoteId)


type TicketId
    = TicketId Int


type alias Ticket =
    { id : TicketId
    , author : User
    , description : String
    , votes : List Vote
    }


emptyTicketId : TicketId
emptyTicketId =
    TicketId -1


emptyTicket : Ticket
emptyTicket =
    { id = emptyTicketId
    , description = ""
    , author = emptyUser
    , votes = [ emptyVote ]
    }


sampleTicket : Ticket
sampleTicket =
    { id = TicketId 1
    , description = "Coca-cola"
    , author = emptyUser
    , votes = [ Vote emptyVoteId (User emptyUserId "testor") 1 ]
    }


sampleTicket2 : Ticket
sampleTicket2 =
    { id = TicketId 2
    , description = "Coca-cola"
    , author = emptyUser
    , votes = [ Vote emptyVoteId (User emptyUserId "testor") 3 ]
    }
