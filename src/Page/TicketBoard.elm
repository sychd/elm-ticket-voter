module Page.TicketBoard exposing (..)

import Component.Ticket exposing (TicketMsg(..), renderTicket)
import Entity.Ticket exposing (Ticket, TicketId, sampleTicket, sampleTicket2)
import Html exposing (..)


type alias Model =
    { tickets : List Ticket
    }


initialModel : { tickets : List Ticket }
initialModel =
    { tickets = [ sampleTicket, sampleTicket2 ]
    }


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "hello" ]
        , div []
            (List.map (renderTicket >> Html.map TicketMessage) model.tickets)
        ]



--(List.map (\ticket -> Html.map TicketMessage <| renderTicket ticket) model.tickets) equals (List.map (renderTicket >> Html.map TicketMessage) model.tickets)


type Msg
    = TicketMessage TicketMsg


update : Msg -> Model -> Model
update msg model =
    case msg of
        TicketMessage subMsg ->
            case subMsg of
                DescriptionChanged ticketId value ->
                    let
                        updatedTickets =
                            List.map
                                (\ticket ->
                                    if ticket.id == ticketId then
                                        { ticket | description = value }

                                    else
                                        ticket
                                )
                                model.tickets
                    in
                    { model | tickets = updatedTickets }

                VoteChanged _ _ _ ->
                    model
