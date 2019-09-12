module Card exposing (Card, deck, genDeck, verbenaBonarensis)

import Random exposing (Generator, constant)


type alias Card =
    { imgUrl : String
    , name : String
    , latinName : String
    }


verbenaBonarensis : Card
verbenaBonarensis =
    { imgUrl = "https://upload.wikimedia.org/wikipedia/commons/8/8f/Verbena_bonarensis.jpg"
    , name = "Jätteverbena"
    , latinName = "Verbena Bonarensis"
    }


deck =
    [ verbenaBonarensis ]


genDeck : Generator ( Card, List Card )
genDeck =
    constant ( verbenaBonarensis, [] )
