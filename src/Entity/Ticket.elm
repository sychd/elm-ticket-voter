module Entity.Ticket exposing (..)

import Entity.Author exposing (Author, emptyAuthorId)
import Entity.Vote exposing (Vote, emptyVoteId)


type TicketId
    = TicketId Int


type alias Ticket =
    { id : TicketId
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
    , votes = []
    }


sampleTicket : Ticket
sampleTicket =
    { id = TicketId 1
    , description = "Coca-cola"
    , votes = [ Vote emptyVoteId (Author emptyAuthorId "testor") 1 ]
    }


sampleTicket2 : Ticket
sampleTicket2 =
    { id = TicketId 2
    , description = "Coca-cola"
    , votes = [ Vote emptyVoteId (Author emptyAuthorId "testor") 3 ]
    }
