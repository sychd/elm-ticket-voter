module Page.Components.NewTicketForm exposing (..)

import Entity.Ticket exposing (Ticket, emptyTicket)
import Html exposing (Html, button, div, input, label, li, text, ul)
import Html.Attributes exposing (class, name, type_, value)
import Html.Events exposing (onClick, onInput)
import Utils exposing (FormState(..))
import Validate exposing (Validator)


type alias State =
    { state : FormState
    , value : Ticket
    , errors : List Error
    }


type Msg
    = FormStateChange FormState
    | FieldChange FormField String


type FormField
    = Description


type alias Error =
    ( FormField, String )


formValidator : Validator Error State
formValidator =
    Validate.all
        [ Validate.ifBlank (\s -> s.value.description) ( Description, "Description should not be blank" )
        ]


validateForm : State -> Result (List Error) (Validate.Valid State)
validateForm state =
    Validate.validate formValidator state


initialState : State
initialState =
    { state = Closed
    , value = emptyTicket
    , errors = []
    }


initialOpenedState : State
initialOpenedState =
    { initialState | state = Opened }


update : Msg -> State -> State
update msg state =
    case msg of
        FormStateChange formState ->
            case formState of
                Submitted ->
                    let
                        validationResult =
                            validateForm state
                    in
                    case validationResult of
                        Ok _ ->
                            { state | state = Submitted, errors = [] }

                        Err errs ->
                            { state | state = Opened, errors = errs }

                Closed ->
                    initialState

                _ ->
                    { state | state = formState }

        FieldChange formField value ->
            case formField of
                Description ->
                    let
                        ticket =
                            state.value

                        updatedTicket =
                            { ticket | description = value }
                    in
                    { state | value = updatedTicket }


view : (State -> msg) -> State -> Html msg
view toMsg state =
    let
        handle msg =
            toMsg <| update msg state
    in
    div [ class "flex flex-col gap-y-2 gap-x-2" ]
        [ Html.form []
            [ label []
                [ text "Description"
                , input [ class "border border-indigo-600 ml-2", type_ "text", name "description", value state.value.description, onInput (\v -> handle (FieldChange Description v)) ] []
                ]
            ]
        , renderErrors state
        , button [ class "btn btn-blue", onClick <| handle (FormStateChange Submitted) ] [ text " New ticket" ]
        , button [ class "btn btn-red", onClick <| handle (FormStateChange Rejected) ] [ text " Cancel" ]
        ]


renderErrors : State -> Html msg
renderErrors state =
    case state.errors of
        [] ->
            text ""

        errors ->
            ul [ class "text-red-500" ]
                (List.map
                    (\( _, err ) -> li [] [ text err ])
                    errors
                )
