module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Page.TicketBoard as TicketBoard


type Msg
    = TicketBoardMsg TicketBoard.Msg


type Page
    = NotFoundPage
    | TicketBoardPage TicketBoard.Model


type alias Model =
    { page : Page }


initialModel : ( Model, Cmd Msg )
initialModel =
    let
        ( ticketModel, ticketCmds ) =
            TicketBoard.initialModel
    in
    ( { page = TicketBoardPage ticketModel }, Cmd.map TicketBoardMsg ticketCmds )


currentView : Model -> Html Msg
currentView model =
    case model.page of
        TicketBoardPage boardModel ->
            TicketBoard.view boardModel
                |> Html.map TicketBoardMsg

        NotFoundPage ->
            div [] [ text "Not found page" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( TicketBoardMsg subMsg, TicketBoardPage subModel ) ->
            let
                ( updatedModel, updatedCmd ) =
                    TicketBoard.update subMsg subModel
            in
            ( { model | page = TicketBoardPage updatedModel }, Cmd.map TicketBoardMsg updatedCmd )

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ currentView model ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> initialModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
