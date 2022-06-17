module Component.Ticket exposing (..)

import Entity.Ticket exposing (Ticket, TicketId)
import Entity.Vote exposing (Vote, VoteId)
import Html exposing (..)
import Html.Events exposing (onClick)


renderTicket : Ticket -> Html TicketMsg
renderTicket ticket =
    div []
        [ span []
            [ text ticket.description ]
        , button [ onClick <| DescriptionChanged ticket.id "Kebab" ] [ text "Change description" ]
        , div []
            (List.map (renderVote ticket) ticket.votes)
        ]


type TicketMsg
    = VoteChanged TicketId VoteId Float
    | DescriptionChanged TicketId String


renderVote : Ticket -> Vote -> Html TicketMsg
renderVote ticket vote =
    div []
        [ span []
            [ text "[ "
            , text <| String.fromFloat vote.value
            , text " ]"
            ]
        , button [ onClick <| VoteChanged ticket.id vote.id 1 ] [ text "+1" ]
        ]
