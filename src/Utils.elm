module Utils exposing (..)

import Html exposing (Html, text)


updateMatchingBy : (a -> a -> Bool) -> a -> a -> a
updateMatchingBy matcher new old =
    if matcher new old then
        new

    else
        old


renderIf : Bool -> Html msg -> Html msg
renderIf cond template =
    if cond then
        template

    else
        text ""
