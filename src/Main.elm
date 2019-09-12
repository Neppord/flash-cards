module Main exposing (main)

import Browser
import Card exposing (Card, genDeck)
import Html exposing (button, form, img, input, text)
import Html.Attributes exposing (placeholder, src, style, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Random


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
    | UpdateField String


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

                ( UpdateField name, AskName showState _ ) ->
                    AskName showState { name = name }

                ( Next, AskName showState { name } ) ->
                    AskLatinName showState { name = name, latinName = "" }

                ( UpdateField latinName, AskLatinName showState askState ) ->
                    AskLatinName showState { askState | latinName = latinName }

                ( Next, AskLatinName showState askState ) ->
                    ShowCardAnswer showState askState

                ( Next, ShowCardAnswer _ _ ) ->
                    IntroScreen

                ( UpdateField _, _ ) ->
                    state

        nextCommand =
            case ( msg, state ) of
                ( Next, IntroScreen ) ->
                    Random.generate (\( current, deck ) -> Init current deck) genDeck

                _ ->
                    Cmd.none
    in
    ( nextState, nextCommand )


subscriptions : State -> Sub msg
subscriptions _ =
    Sub.none


init () =
    ( IntroScreen, Cmd.none )


view state =
    case state of
        IntroScreen ->
            button [ onClick Next ] [ text "Börja" ]

        ShowCard { current } ->
            img
                [ src current.imgUrl
                , onClick Next
                , style "max-width" "100%"
                ]
                []

        AskName _ { name } ->
            form
                [ onSubmit Next ]
                [ input
                    [ value name
                    , placeholder "Namn"
                    , style "min-width" "100%"
                    , onInput UpdateField
                    ]
                    []
                ]

        AskLatinName _ { latinName } ->
            form
                [ onSubmit Next ]
                [ input
                    [ value latinName
                    , placeholder "Vetenskapligt namn"
                    , style "min-width" "100%"
                    , onInput UpdateField
                    ]
                    []
                ]

        _ ->
            text "Hello world!"


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
