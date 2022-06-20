module Entity.Ticket exposing (..)

import Entity.Author exposing (Author, AuthorId, emptyAuthorId)
import Entity.Vote exposing (Vote, emptyVote, emptyVoteId)


type TicketId
    = TicketId Int


type alias Ticket =
    { id : TicketId
    , authorId : AuthorId
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
    , authorId = emptyAuthorId
    , votes = [ emptyVote ]
    }


sampleTicket : Ticket
sampleTicket =
    { id = TicketId 1
    , description = "Coca-cola"
    , authorId = emptyAuthorId
    , votes = [ Vote emptyVoteId (Author emptyAuthorId "testor") 1 ]
    }


sampleTicket2 : Ticket
sampleTicket2 =
    { id = TicketId 2
    , description = "Coca-cola"
    , authorId = emptyAuthorId
    , votes = [ Vote emptyVoteId (Author emptyAuthorId "testor") 3 ]
    }
