module Component.Ticket exposing (renderTicket)

import Entity.Ticket exposing (Ticket)
import Entity.Vote exposing (Vote)
import Html exposing (..)

renderTicket : Ticket -> Html msg
renderTicket ticket =
    div []
        [ span []
            [ text ticket.description ]
        , div []
            (List.map renderVote ticket.votes)
        ]


renderVote : Vote -> Html msg
renderVote vote =
    div []
        [ span []
            [ text <| String.fromFloat vote.value ]
        ]
