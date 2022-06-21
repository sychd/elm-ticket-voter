module Entity.User exposing (User, UserId, emptyUser, emptyUserId)


type UserId
    = AuthorId Int


type alias User =
    { id : UserId
    , nickname : String
    }


emptyUserId : UserId
emptyUserId =
    AuthorId -1


emptyUser : User
emptyUser =
    { id = emptyUserId, nickname = "" }
