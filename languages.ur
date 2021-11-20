
type lang  = {
     Id :string,
Name : string,
NativeName : string ,
Page : unit -> transaction xbody
}
     
fun renderRu _ =
    return <xml>
      render russian
      </xml>

     
val russian : lang = {
    Id = "ru",
Name = "Russian",
NativeName = "русский язык" ,
Page = renderRu
}


fun renderEn _ =
    return <xml>
      render english
      </xml>

		     
val english : lang = {
    Id = "en",
    Name = "English",
    NativeName = "English",
    Page = renderEn
    }
		     

val languages = (russian, english)
