module Main exposing (main)

import Browser
import Html exposing (text)


type alias Card =
    { imgUrl : String
    , name : String
    , latinName : String
    }


type alias ShowState =
    { current : Card
    , deck : List Card
    , failed : List Card
    }


type State
    = IntroScreen
    | ShowCard ShowState
    | AskName ShowState { name : String }
    | AskLatinName ShowState { name : String, latinName : String }
    | ShowCardAnswer ShowState { name : String, latinName : String }


type Msg
    = Init Card (List Card)
    | Next


update msg state =
    let
        nextState =
            case ( msg, state ) of
                ( Init current deck, _ ) ->
                    ShowCard
                        { current = current
                        , deck = deck
                        , failed = []
                        }

                ( _, IntroScreen ) ->
                    IntroScreen

                ( Next, ShowCard showState ) ->
                    AskName showState { name = "" }

                ( Next, AskName showState { name } ) ->
                    AskLatinName showState { name = name, latinName = "" }

                ( Next, AskLatinName showState askState ) ->
                    ShowCardAnswer showState askState

                ( Next, ShowCardAnswer _ _ ) ->
                    IntroScreen
    in
    ( nextState, Cmd.none )


subscriptions : State -> Sub msg
subscriptions _ =
    Sub.none


init () =
    ( IntroScreen, Cmd.none )


view _ =
    text "Hello world!"


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
