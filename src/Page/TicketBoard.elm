module Page.TicketBoard exposing (..)

import Entity.Ticket exposing (Ticket, TicketId, sampleTicket, sampleTicket2, ticketsDecoder)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (optional, optionalAt, required, requiredAt)
import Page.Components.NewTicketForm as NewTicketFormComponent
import Page.Components.Ticket as TicketComponent
import RemoteData exposing (RemoteData(..))
import Utils exposing (FormState(..), updateMatchingBy)


type alias Model =
    { tickets : List TicketComponent.State
    , newTicketForm : NewTicketFormComponent.State
    , error : Maybe Http.Error
    }


type Msg
    = TicketChanged TicketComponent.State
    | OpenNewTicketForm
    | NewTicketFormChanged NewTicketFormComponent.State
    | RemoveTicket TicketComponent.State
    | DataReceived (RemoteData Http.Error (List Ticket))


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { tickets = []
      , newTicketForm = NewTicketFormComponent.initialState
      , error = Nothing
      }
    , fetchTickets
    )


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
                , renderNetworkError model
                , div [ class "flex" ]
                    (List.map (\t -> TicketComponent.view (RemoveTicket t) TicketChanged t) model.tickets)
                , div []
                    [ button [ class "btn btn-blue", onClick OpenNewTicketForm ] [ text " [+] New Ticket" ]
                    ]
                ]


renderNetworkError : Model -> Html Msg
renderNetworkError model =
    case model.error of
        Just _ ->
            text "Network error occurred"

        Nothing ->
            text ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TicketChanged selectedTicketState ->
            ( { model | tickets = List.map (updateTicket selectedTicketState) model.tickets }, Cmd.none )

        NewTicketFormChanged form ->
            case form.state of
                Submitted ->
                    ( { model | newTicketForm = form, tickets = model.tickets ++ [ TicketComponent.withTicket form.value ] }, Cmd.none )

                _ ->
                    ( { model | newTicketForm = form }, Cmd.none )

        OpenNewTicketForm ->
            ( { model | newTicketForm = NewTicketFormComponent.initialOpenedState }, Cmd.none )

        RemoveTicket ticket ->
            ( { model | tickets = List.filter (\t -> t.value.id /= ticket.value.id) model.tickets }, Cmd.none )

        DataReceived remoteData ->
            case remoteData of
                Success data ->
                    ( { model | tickets = List.map TicketComponent.withTicket data }, Cmd.none )

                Failure err ->
                    ( { model | error = Just err }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


updateTicket : TicketComponent.State -> TicketComponent.State -> TicketComponent.State
updateTicket newTicket oldTicket =
    updateMatchingBy (\a b -> a.value.id == b.value.id) newTicket oldTicket


fetchTickets : Cmd Msg
fetchTickets =
    Http.get { url = "http://localhost:5050/tickets", expect = Http.expectJson (RemoteData.fromResult >> DataReceived) ticketsDecoder }
