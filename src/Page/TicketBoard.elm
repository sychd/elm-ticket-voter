module Page.TicketBoard exposing (..)

import Component.Ticket as TicketC
import Entity.Ticket exposing (Ticket, TicketId, emptyTicket, sampleTicket, sampleTicket2)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Utils exposing (updateMatchingBy)


type alias Model =
    { tickets : List TicketC.State
    , formState : FormState
    }


type FormState
    = Opened
    | Submitted Ticket
    | Rejected
    | Idle


type Msg
    = TicketChanged TicketC.State
    | NewTicket FormState
    | RemoveTicket TicketC.State


initialModel : Model
initialModel =
    { tickets = List.map TicketC.withTicket [ sampleTicket, sampleTicket2 ]
    , formState = Idle
    }


view : Model -> Html Msg
view model =
    case model.formState of
        Opened ->
            div [ class "m-4 flex flex-col w-[300px] gap-y-3" ]
                [ h1 [ class "font-bold text-xl text-center m-2" ] [ text "New Ticket form" ]
                , text "Form with validation to be done"
                , button [ class "btn btn-blue", onClick <| NewTicket (Submitted emptyTicket) ] [ text " New ticket" ]
                , button [ class "btn btn-red", onClick <| NewTicket Rejected ] [ text " Cancel" ]
                ]

        _ ->
            div [ class "m-4" ]
                [ h1 [ class "font-bold text-xl text-center m-2" ] [ text "Tickets board" ]
                , div [ class "flex" ]
                    (List.map (\t -> TicketC.view (RemoveTicket t) TicketChanged t) model.tickets)
                , div []
                    [ button [ class "btn btn-blue", onClick <| NewTicket Opened ] [ text " [+] New Ticket" ]
                    ]
                ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        TicketChanged selectedTicketState ->
            { model | tickets = List.map (updateTicket selectedTicketState) model.tickets }

        NewTicket formState ->
            case formState of
                Opened ->
                    { model | formState = Opened }

                Submitted ticket ->
                    { model | tickets = model.tickets ++ [ TicketC.withTicket ticket ], formState = Idle }

                Rejected ->
                    { model | formState = Idle }

                Idle ->
                    model

        RemoveTicket ticket ->
            { model | tickets = List.filter (\t -> t.value.id /= ticket.value.id) model.tickets }


updateTicket : TicketC.State -> TicketC.State -> TicketC.State
updateTicket newTicket oldTicket =
    updateMatchingBy (\a b -> a.value.id == b.value.id) newTicket oldTicket
