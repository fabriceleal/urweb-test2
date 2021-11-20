open Languages

functor FolderGenerator (M : sig
			     con c :: {Unit}
				 
			     val flU : folder c

			     con t = $(mapU lang c)
				       
			     val elem : t
			 end) = struct

    con t = M.t
    val flU = M.flU
end

structure M = FolderGenerator(struct
				  val elem = languages
			      end)


fun nullRender (_ : unit ) : transaction xbody =
    error <xml>language not found</xml>

and renderMenu (_ : unit) : xbody =
    let

	fun renderMenu2 (*[ts ::: {Unit}]*)
			(*(fl : folder ts) *)
		(*(r : $(mapU lang ts))*)
		(r : M.t) : xbody=
	    @foldR
	     [fn _ => lang] 
	     [fn _ => xbody]
	     (fn [nm ::_] [v ::_] [r ::_] [[nm] ~r] v acc =>
		 <xml>
		   {acc}
		   <a link={langRender v.Id}> {[v.Name]} </a>
		 </xml>
	     )
	     <xml></xml> M.flU r
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
	fun getRenderer (*[ts ::: {Unit}]
			(fl : folder ts)
			(r : $(mapU lang ts)) *)
		(r : M.t) (id : string) : (unit -> transaction xbody) =
	    @foldR
	     [fn _ => lang]
	     [fn _ => unit -> transaction xbody]
	     (fn [nm ::_] [v ::_] [r ::_] [[nm] ~ r] v acc =>
		 if v.Id = id then
		     v.Page
		 else
		     acc
	     )
	     nullRender M.flU r
	    
	val rlang = getRenderer languages l 

    in
	innerpage <- rlang ();
	return <xml>
	  <body>
	   { renderMenu ()}    (*uncomment this and it wont compile *)
	   { innerpage } 
	  </body>
	</xml>		
    end
 
and test (l: string) = genericRenderer <xml>test</xml>
     
and index _ = genericRenderer <xml>homepage</xml>

