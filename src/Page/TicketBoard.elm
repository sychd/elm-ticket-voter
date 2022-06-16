module Page.TicketBoard exposing (..)

import Component.Ticket exposing (renderTicket)
import Entity.Ticket exposing (Ticket, sampleTicket)
import Html exposing (..)


type alias Model =
    { tickets : List Ticket
    }


initialModel : { tickets : List Ticket }
initialModel =
    { tickets = [ sampleTicket ]
    }


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "hello" ]
        , div []
            (List.map renderTicket model.tickets)
        ]


type Msg
    = AddVote


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddVote ->
            model
