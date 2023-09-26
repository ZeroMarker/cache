Class web.DHCCTLoc Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CTLocBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT %ID,CTLoc_Code,CTLoc_Desc into :id,:code,:Name FROM SQLUSER.CT_Loc where CTLoc_Code =:val) 
 if SQLCODE'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod RoomBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT %ID,CTLoc_Code,CTLoc_Desc into :id,:code,:Name FROM SQLUSER.CT_Loc where CTLOC_Type="OutPatient Consulting Room" AND CTLoc_Code =:val) 
 if %ROWCOUNT'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod RoomQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RoomQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RoomQueryExecute(ByRef qHandle As %Binary) As %Status
{
	//从资源计划里获取挂号科室
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	Set RowID=""
	Set RowID=$Order(^CTLOC(0,"LocType","OR",RowID))
	while(RowID'="")
	{
		set Code=$piece($Get(^CTLOC(RowID)),"^",1)
		set Name=$piece($Get(^CTLOC(RowID)),"^",2)
		set Data=$ListBuild(Name,Code,RowID)
		Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1

 Set RowID=$Order(^CTLOC(0,"LocType","OR",RowID))

	}

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod RoomQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RoomQueryExecute ]
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

ClassMethod SecheduleLoctionQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SecheduleLoctionQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SecheduleLoctionQueryExecute(ByRef qHandle As %Binary) As %Status
{
	//从资源计划里获取挂号科室
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	Set RowID=""
	Set RowID=$Order(^PAC("ADMLOC",0,"AdmType","O",RowID))
	while(RowID'="")
	{
		set Code=$piece($Get(^CTLOC(RowID)),"^",1)
		set Name=$piece($Get(^CTLOC(RowID)),"^",2)
		set Data=$ListBuild(Name,Code,RowID)
		Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1

 Set RowID=$Order(^PAC("ADMLOC",0,"AdmType","O",RowID))

	}

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod SecheduleLoctionQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SecheduleLoctionQueryExecute ]
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

Query GetLocByName(Name As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID AS ID,CTLoc_Code,CTLoc_Desc AS Name,CTLOC_ContactName As OtherName FROM SQLUSER.CT_Loc where CTLoc_Desc %STARTSWITH :Name
}

Query RoomQuery() As %Query(ROWSPEC = "Name:%String,Code:%String,ID:%String")
{
}

Query SecheduleLoctionQuery() As %Query(ROWSPEC = "Name:%String,Code:%String,ID:%String")
{
}

}
