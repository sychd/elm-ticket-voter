module Entity.Board exposing (Board, emptyBoardId)

import Entity.Ticket exposing (Ticket)


type BoardId
    = BoardId Int


type alias Board =
    { id : BoardId
    , tickets : List Ticket
    }


emptyBoardId : BoardId
emptyBoardId =
    BoardId -1
