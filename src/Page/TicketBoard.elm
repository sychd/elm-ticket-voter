module Page.TicketBoard exposing (..)

import Component.Ticket as TicketC
import Entity.Ticket exposing (Ticket, TicketId, sampleTicket, sampleTicket2)
import Html exposing (..)
import Html.Attributes exposing (class)
import Utils exposing (updateMatchingBy)


type alias Model =
    { tickets : List TicketC.State
    }


initialModel : { tickets : List TicketC.State }
initialModel =
    { tickets = List.map TicketC.withTicket [ sampleTicket, sampleTicket2 ]
    }


view : Model -> Html Msg
view model =
    div [ class "m-4" ]
        [ h1 [ class "font-bold text-xl text-center m-2" ] [ text "Tickets board" ]
        , div [ class "flex" ]
            (List.map (TicketC.view TicketChanged) model.tickets)
        ]


type Msg
    = TicketChanged TicketC.State


update : Msg -> Model -> Model
update msg model =
    case msg of
        TicketChanged selectedTicketState ->
            { model | tickets = List.map (updateTicket selectedTicketState) model.tickets }


updateTicket : TicketC.State -> TicketC.State -> TicketC.State
updateTicket newTicket oldTicket =
    updateMatchingBy (\a b -> a.value.id == b.value.id) newTicket oldTicket
