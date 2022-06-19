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


view : msg -> (State -> msg) -> State -> Html msg
view onRemoveMsg toMsg state =
    let
        ticket =
            state.value
    in
    div [ class "bg-gray-200 flex flex-col w-200 m-2 p-2 rounded-md gap-y-2 justify-around" ]
        [ span [ class "text-lg font-bold" ]
            [ text ticket.description ]
        , renderDraftControl toMsg state
        , div []
            (List.map (renderVote toMsg state) ticket.votes)
        , button [ class "btn btn-red", onClick onRemoveMsg ] [ text "Remove" ]
        ]


renderDraftControl : (State -> msg) -> State -> Html msg
renderDraftControl toMsg state =
    case state.status of
        Active ->
            div [ class "flex gap-x-2" ]
                [ input
                    [ type_ "text"
                    , onInput (\v -> toMsg <| update (UpdateDraftDescription v) state)
                    , value state.draftDescription
                    ]
                    []
                , button [ class "btn btn-red", onClick <| toMsg <| update (ChangeDraftStatus <| Inactive Rejected) state ] [ text "Cancel" ]
                , button [ class "btn btn-blue", onClick <| toMsg <| update (ChangeDraftStatus <| Inactive Confirmed) state ] [ text "OK" ]
                ]

        Inactive _ ->
            button [ class "btn btn-blue my-4", onClick <| toMsg (update (ChangeDraftStatus Active) state) ] [ text "Change value" ]


renderVote : (State -> msg) -> State -> Vote -> Html msg
renderVote toMsg state vote =
    div [ class "flex gap-x-2 align-center justify-around" ]
        [ button [ class "btn btn-blue", onClick <| toMsg (update (ChangeVote vote 1) state) ] [ text "+1" ]
        , span [ class "bg-gray-300 py-1 px-3 flex align-center rounded-full color-gray-800" ]
            [ text <| String.fromFloat vote.value
            ]
        , renderIf (vote.value > 0) <|
            button
                [ class "btn btn-blue"
                , onClick <| toMsg (update (ChangeVote vote -1) state)
                ]
                [ text "-1" ]
        ]
