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


initialModel : Model
initialModel =
    { page = TicketBoardPage TicketBoard.initialModel }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        TicketBoardPage boardModel ->
            TicketBoard.view boardModel
                |> Html.map TicketBoardMsg

        NotFoundPage ->
            div [] [ text "Not found page" ]


update : Msg -> Model -> Model
update msg model =
    case ( msg, model.page ) of
        ( TicketBoardMsg subMsg, TicketBoardPage subModel ) ->
            let
                updatedModel =
                    TicketBoard.update subMsg subModel
            in
            { model | page = TicketBoardPage updatedModel }

        ( _, _ ) ->
            model


view : Model -> Html Msg
view model =
    div []
        [ currentView model ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
