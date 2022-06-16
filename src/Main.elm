module Main exposing (..)

import Browser
import Page.TicketBoard


type Msg
    = TicketBoardMsg Page.TicketBoard.Msg


type alias Model =
    Page.TicketBoard.Model


main : Program () Model Page.TicketBoard.Msg
main =
    Browser.sandbox
        { init = Page.TicketBoard.initialModel
        , view = Page.TicketBoard.view
        , update = Page.TicketBoard.update
        }
