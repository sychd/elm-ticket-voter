module Page.TicketBoard exposing (..)

import Component.Ticket as TicketC
import Entity.Ticket exposing (Ticket, TicketId, sampleTicket, sampleTicket2)
import Html exposing (..)


type alias Model =
    { tickets : List TicketC.State
    }


initialModel : { tickets : List TicketC.State }
initialModel =
    { tickets = List.map TicketC.withTicket [ sampleTicket, sampleTicket2 ]
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Tickets board" ]
        , div []
            (List.map (TicketC.view TicketChanged) model.tickets)
        ]


type Msg
    = TicketChanged TicketC.State


update : Msg -> Model -> Model
update msg model =
    case msg of
        TicketChanged singleTicketState ->
            { model | tickets = List.map (updateTicket singleTicketState) model.tickets }


updateTicket : TicketC.State -> TicketC.State -> TicketC.State
updateTicket newTicket oldTicket =
    if newTicket.value.id == oldTicket.value.id then
        newTicket

    else
        oldTicket
