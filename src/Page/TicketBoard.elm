module Page.TicketBoard exposing (..)

import Entity.Ticket exposing (Ticket, TicketId, emptyTicket, sampleTicket, sampleTicket2)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Page.Components.NewTicketForm as NewTicketFormComponent
import Page.Components.Ticket as TicketComponent
import Utils exposing (FormState(..), updateMatchingBy)


type alias Model =
    { tickets : List TicketComponent.State
    , newTicketForm : NewTicketFormComponent.State
    }


type Msg
    = TicketChanged TicketComponent.State
    | OpenNewTicketForm
    | NewTicketFormChanged NewTicketFormComponent.State
    | AddTicket NewTicketFormComponent.State
    | RemoveTicket TicketComponent.State


initialModel : Model
initialModel =
    { tickets = List.map TicketComponent.withTicket [ sampleTicket, sampleTicket2 ]
    , newTicketForm = NewTicketFormComponent.initialState
    }


view : Model -> Html Msg
view model =
    case model.newTicketForm.state of
        Opened ->
            div [ class "m-4 flex flex-col w-[300px] gap-y-3" ]
                [ NewTicketFormComponent.view NewTicketFormChanged model.newTicketForm
                ]

        _ ->
            div [ class "m-4" ]
                [ h1 [ class "font-bold text-xl text-center m-2" ] [ text "Tickets board" ]
                , div [ class "flex" ]
                    (List.map (\t -> TicketComponent.view (RemoveTicket t) TicketChanged t) model.tickets)
                , div []
                    [ button [ class "btn btn-blue", onClick OpenNewTicketForm ] [ text " [+] New Ticket" ]
                    ]
                ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        TicketChanged selectedTicketState ->
            { model | tickets = List.map (updateTicket selectedTicketState) model.tickets }

        NewTicketFormChanged form ->
            case form.state of
                Submitted ->
                    { model | newTicketForm = form, tickets = model.tickets ++ [ TicketComponent.withTicket form.value ] }

                _ ->
                    { model | newTicketForm = form }

        OpenNewTicketForm ->
            { model | newTicketForm = NewTicketFormComponent.initialOpenedState }

        RemoveTicket ticket ->
            { model | tickets = List.filter (\t -> t.value.id /= ticket.value.id) model.tickets }

        AddTicket form ->
            { model | tickets = model.tickets ++ [ TicketComponent.withTicket form.value ] }


updateTicket : TicketComponent.State -> TicketComponent.State -> TicketComponent.State
updateTicket newTicket oldTicket =
    updateMatchingBy (\a b -> a.value.id == b.value.id) newTicket oldTicket
