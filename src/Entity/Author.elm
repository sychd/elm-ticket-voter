module Entity.Author exposing (Author, AuthorId, emptyAuthorId)


type AuthorId
    = AuthorId Int


type alias Author =
    { id : AuthorId
    , nickname : String
    }


emptyAuthorId : AuthorId
emptyAuthorId =
    AuthorId -1
