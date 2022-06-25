module Entity.Ticket exposing (..)

import Entity.User exposing (User, UserId, emptyUser, emptyUserId, userDecoder)
import Entity.Vote exposing (Vote, emptyVote, emptyVoteId, votesDecoder)
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)


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


ticketsDecoder : Decoder (List Ticket)
ticketsDecoder =
    list ticketDecoder


ticketDecoder : Decoder Ticket
ticketDecoder =
    Decode.succeed Ticket
        |> required "id" ticketIdDecoder
        |> required "user" userDecoder
        |> required "description" string
        |> required "votes" votesDecoder


ticketIdDecoder : Decoder TicketId
ticketIdDecoder =
    Decode.map TicketId int
