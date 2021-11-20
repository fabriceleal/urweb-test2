
type lang  = {
Id : string,
Name : string,
NativeName : string ,
Page : unit -> transaction xbody
}


     
val langRender : string -> transaction page
val index : unit -> transaction page
		    
