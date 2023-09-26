Class web.DHCANCIcon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod AddDHCANCIcon(itmjs As %Library.String = "", itm As %Library.String = "", Str As %String)
{

 s retcode=..InsertDHCANCIcon(Str)
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q retcode
}

ClassMethod InsertDHCANCIcon(val As %String)
{
    
 set ANICode=$p(val,"^",1)
 set ANIDesc=$p(val,"^",2)
 set ANICount=$p(val,"^",3)
 set ANIWidth =$p(val,"^",4)
 set ANIHeight=$p(val,"^",5)
 set ANIPositionX=$p(val,"^",6)
 set ANIPositionY=$p(val,"^",7)
 set ANILineWidth=$p(val,"^",8)
 set ANIShape=$p(val,"^",9)
 set ANIData=$p(val,"^",10)

    &sql(INSERT INTO sqluser.DHC_ANC_Icon(ANI_Code,ANI_Desc,ANI_Count,ANI_Width ,ANI_Height,ANI_PositionX,ANI_PositionY,ANI_LineWidth,ANI_Shape,ANI_Data) Values (:ANICode,:ANIDesc,:ANICount,:ANIWidth,:ANIHeight,:ANIPositionX,:ANIPositionY,:ANILineWidth,:ANIShape,:ANIData))
    	    i SQLCODE=0 d   s retcode=0
	    e  s retcode=100
	    q retcode
}

ClassMethod DeleteDHCANCIcon(itmjs As %Library.String = "", itm As %Library.String = "", ID As %String)
{
    &sql(Delete From sqluser.DHC_ANC_Icon Where ANI_Rowid=:ID)
            set retcode=SQLCODE
     s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
    quit SQLCODE
}

ClassMethod GetDHCANCIconClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCANCIconExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDHCANCIconExecute(ByRef qHandle As %Binary, code As %String = "", desc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	If $g(ind)="" Set ind=1
	s rowid=0

	f  s rowid=$o(^DHCANC("Icon",rowid)) q:rowid=""  d
		.set ANICode=$p(^DHCANC("Icon",rowid),"^",1)
		.q:(code'="")&($$ALPHAUP^SSUTIL4(ANICode)'[$$ALPHAUP^SSUTIL4(code))
		.set ANIDesc=$p(^DHCANC("Icon",rowid),"^",2)
		.q:(desc'="")&($$ALPHAUP^SSUTIL4(ANIDesc)'[$$ALPHAUP^SSUTIL4(desc))
		.set ANICount=$p(^DHCANC("Icon",rowid),"^",3)
		.set ANIWidth=$p(^DHCANC("Icon",rowid),"^",4)
		.set ANIHeight=$p(^DHCANC("Icon",rowid),"^",5)
		.set ANIPositionX=$p(^DHCANC("Icon",rowid),"^",6)
		.set ANIPositionY=$p(^DHCANC("Icon",rowid),"^",7)
		.set ANILineWidth =$p(^DHCANC("Icon",rowid),"^",8)
		.set ANIShape=$p(^DHCANC("Icon",rowid),"^",9)
		.set ANIData=$p(^DHCANC("Icon",rowid),"^",10)
		.s rowid0=rowid
	 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ANICode,ANIDesc,ANICount,ANIWidth ,ANIHeight,ANIPositionX,ANIPositionY,ANILineWidth,ANIShape,ANIData,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDHCANCIconFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCANCIconExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UpdateDHCANCIcon(itmjs As %Library.String = "", itm As %Library.String = "", Val As %String)
{
   
    set ANICode=$p(Val,"^",1)
    set ANIDesc=$p(Val,"^",2)
    set ANICount=$p(Val,"^",3)
    set ANIWidth=$p(Val,"^",4)
    set ANIHeight=$p(Val,"^",5)
    set ANIPositionX=$p(Val,"^",6)
    set ANIPositionY=$p(Val,"^",7)
    set ANILineWidth=$p(Val,"^",8)
    set ANIShape=$p(Val,"^",9)
    set ANIData=$p(Val,"^",10)
    set ID=$p(Val,"^",11)
    &sql(Update sqluser.DHC_ANC_Icon set ANI_Data=:ANIData,ANI_Shape=:ANIShape,ANI_LineWidth=:ANILineWidth,ANI_PositionY=:ANIPositionY, ANI_PositionX=:ANIPositionX,ANI_Height=:ANIHeight,ANI_Width=:ANIWidth,ANI_Count=:ANICount,ANI_Code=:ANICode,ANI_Desc=:ANIDesc Where ANI_Rowid=:ID)
    set retcode=SQLCODE
    s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
    quit SQLCODE
}

Query GetDHCANCIcon(code As %String = "", desc As %String = "") As %Query(ROWSPEC = "ANICode:%String,ANIDesc:%String,ANICount:%String,ANIWidth :%String,ANIHeight :%String,ANIPositionX :%String,ANIPositionY :%String,ANILineWidth :%String,ANIShape:%String,ANIData :%String,rowid0:%String")
{
}

ClassMethod GetIconInfo(ID As %String) As %String
{
	set RetVal=^DHCANC("Icon",ID)
	quit RetVal
}

}
