module Component.Ticket exposing (..)

import Entity.Ticket exposing (Ticket, TicketId, emptyTicket)
import Entity.Vote exposing (Vote, VoteId)
import Html exposing (..)
import Html.Attributes exposing (class, classList, type_, value)
import Html.Events exposing (onClick, onInput)
import Utils exposing (renderIf, updateMatchingBy)


type alias State =
    { value : Ticket
    , draftDescription : String
    , status : Status
    }


type InactiveStatus
    = Confirmed
    | Rejected
    | Idle


type Status
    = Active
    | Inactive InactiveStatus


type Msg
    = ChangeVote Vote Float
    | UpdateDraftDescription String
    | ChangeDraftStatus Status


initialState : State
initialState =
    { value = emptyTicket
    , draftDescription = ""
    , status = Inactive Idle
    }


withTicket : Ticket -> State
withTicket ticket =
    { initialState | value = ticket, draftDescription = ticket.description }


update : Msg -> State -> State
update msg state =
    let
        ticket =
            state.value
    in
    case msg of
        UpdateDraftDescription value ->
            { state | draftDescription = value }

        ChangeDraftStatus Active ->
            { state | status = Active, draftDescription = state.value.description }

        ChangeDraftStatus (Inactive Confirmed) ->
            let
                updatedTicket =
                    { ticket | description = state.draftDescription }
            in
            { state | status = Inactive Idle, value = updatedTicket }

        ChangeDraftStatus (Inactive Rejected) ->
            { state | status = Inactive Idle }

        ChangeVote vote value ->
            let
                newVote =
                    { vote | value = vote.value + value }

                updateVote new old =
                    updateMatchingBy (\a b -> a.id == b.id) new old

                updatedTicket =
                    { ticket | votes = List.map (updateVote newVote) ticket.votes }
            in
            { state | value = updatedTicket }

        _ ->
            state


view : (State -> msg) -> State -> Html msg
view toMsg state =
    let
        ticket =
            state.value
    in
    div [ class "bg-gray-200" ]
        [ span []
            [ text ticket.description ]
        , renderDraftControl toMsg state
        , div []
            (List.map (renderVote toMsg state) ticket.votes)
        ]


renderDraftControl : (State -> msg) -> State -> Html msg
renderDraftControl toMsg state =
    case state.status of
        Active ->
            div []
                [ input
                    [ type_ "text"
                    , onInput (\v -> toMsg <| update (UpdateDraftDescription v) state)
                    , value state.draftDescription
                    ]
                    []
                , button [ onClick <| toMsg <| update (ChangeDraftStatus <| Inactive Rejected) state ] [ text "Cancel" ]
                , button [ onClick <| toMsg <| update (ChangeDraftStatus <| Inactive Confirmed) state ] [ text "OK" ]
                ]

        Inactive _ ->
            button [ onClick <| toMsg (update (ChangeDraftStatus Active) state) ] [ text "Change description" ]


renderVote : (State -> msg) -> State -> Vote -> Html msg
renderVote toMsg state vote =
    div []
        [ span []
            [ text "[ "
            , text <| String.fromFloat vote.value
            , text " ]"
            ]
        , button [ onClick <| toMsg (update (ChangeVote vote 1) state) ] [ text "+1" ]
        , renderIf (vote.value > 0) <| button [ onClick <| toMsg (update (ChangeVote vote -1) state) ] [ text "-1" ]
        ]
