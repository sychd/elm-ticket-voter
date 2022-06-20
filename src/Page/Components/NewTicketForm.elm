module Page.Components.NewTicketForm exposing (..)

import Entity.Ticket exposing (Ticket, emptyTicket)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Utils exposing (FormState(..))


type alias State =
    { state : FormState
    , value : Ticket
    }


type Msg
    = FormStateChange FormState
    | DescriptionChange String


initialState : State
initialState =
    { state = Idle
    , value = emptyTicket
    }


update : Msg -> State -> State
update msg state =
    case msg of
        FormStateChange formState ->
            case formState of
                Idle ->
                    initialState

                _ ->
                    { state | state = formState }

        DescriptionChange descr ->
            let
                ticket =
                    state.value

                updatedTicket =
                    { ticket | description = descr }
            in
            { state | value = updatedTicket }


view : (State -> msg) -> State -> Html msg
view toMsg state =
    div []
        [ text "Form with validation to be done"
        , button [ class "btn btn-blue", onClick <| toMsg <| update (FormStateChange Submitted) state ] [ text " New ticket" ]
        , button [ class "btn btn-red", onClick <| toMsg <| update (FormStateChange Rejected) state ] [ text " Cancel" ]
        ]


openNewTicketForm : State -> State
openNewTicketForm form =
    { form | state = Opened }
