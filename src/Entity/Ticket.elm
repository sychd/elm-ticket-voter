module Entity.Ticket exposing (Ticket, TicketId, emptyTicketId, sampleTicket)

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


sampleTicket : Ticket
sampleTicket =
    { id = emptyTicketId
    , description = "Coca-cola"
    , votes = [ Vote emptyVoteId (Author emptyAuthorId "testor") 1 ]
    }
