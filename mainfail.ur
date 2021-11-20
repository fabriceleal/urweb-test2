open Languages

fun nullRender (_ : unit ) : transaction xbody =
    error <xml>language not found</xml>

and renderMenu (_ : unit) : xbody =
    let

	fun renderMenu2 [ts ::: {Unit}]
			(fl : folder ts) 
		(r : $(mapU lang ts)) : xbody=
	    @foldR
	     [fn _ => lang] 
	     [fn _ => xbody]
	     (fn [nm ::_] [v ::_] [r ::_] [[nm] ~r] v acc =>
		 <xml>
		   {acc}
		   <a link={langRender v.Id}> {[v.Name]} </a>
		 </xml>
	     )
	     <xml></xml> fl r
    in
	<xml>
	  <div>
	    <a link={index ()}>Home</a>
	    <a link={test "test"}>test</a>
	    { renderMenu2 languages  }
	  </div> 
	</xml>
    end

and genericRenderer (b: xbody) : transaction page =
    return <xml>
      <body>
	{ renderMenu ()}
	{b}
      </body>	   
    </xml>
						 
and langRender (l : string) : transaction page=
    
    let
	fun getRenderer [ts ::: {Unit}]
			(fl : folder ts)
			(r : $(mapU lang ts)) 
			(id : string) : (unit -> transaction xbody) =
	    @foldR
	     [fn _ => lang]
	     [fn _ => unit -> transaction xbody]
	     (fn [nm ::_] [v ::_] [r ::_] [[nm] ~ r] v acc =>
		 if v.Id = id then
		     v.Page
		 else
		     acc
	     )
	     nullRender fl r
	    
	val rlang = getRenderer languages l 

    in
	innerpage <- rlang ();
	return <xml>
	  <body>
	   { renderMenu ()}   (*  comment this line and it compiles *)
	   { innerpage } 
	  </body>
	</xml>		
    end
 
and test (l: string) = genericRenderer <xml>test</xml>
     
and index _ = genericRenderer <xml>homepage</xml>

