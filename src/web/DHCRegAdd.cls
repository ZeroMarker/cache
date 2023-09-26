Class web.DHCRegAdd Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Delete(Rowid As %String) As %String
{
	&SQL(Delete From SQLUser.DHC_RegAdd where RA_Rowid=:Rowid)
	Q SQLCODE
}

ClassMethod FindClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 //New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindDocExecute(ByRef qHandle As %Binary, DepID As %String, RegDate As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1

	i RegDate="" s RegDate=+$h
	e  s RegDate=$ZDH(RegDate,4)
	
	If $g(DepID)'="" do
	.Set ResRowId=0 f  Set ResRowId=$o(^RB("RES",0,"CTLOC",DepID,ResRowId)) quit:ResRowId=""  d
	..Q:'$D(^RB("RES",ResRowId))
	..Set DocDr=$p(^RB("RES",ResRowId),"^",2)
	..set ScheSt=$p(^RB("RES",ResRowId),"^",6)
	..Quit:(ScheSt'="Y")
	..Quit:DocDr="" 
	..s DateRowId=""
	..I ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
	..Q:(DateRowId="")
	..s Sess=##class(web.DHCBeforeReg).GetDocRes(ResRowId,DateRowId,RegDate)
 ..Q:(Sess=0)!(Sess="")
 ..i DocDr'="" s MarkDesc=$P($G(^CTPCP(DocDr,1)),"^",2)
 ..Do OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
	set Data=$lb(MarkDesc,DocDr)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
ResetVariables2
	///set (repid)=0
	set (MarkDesc,DocDr)=""
	quit
}

ClassMethod FindDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocExecute ]
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

ClassMethod FindExecute(ByRef QHandle As %Binary, DepID As %String, RegDate As %String) As %Status
{
	i RegDate="" s RegDate=+$h
	;e  s RegDate=$ZDH(RegDate,4)
 Set repid=$I(^CacheTemp)
	s ind=1
	if DepID'="" {
	 	s Rowid=0 f  s Rowid=$o(^DHCRegAdd("0","RegDate",RegDate,Rowid)) q:Rowid=""  d
	 	.s DepRowid=$p($g(^DHCRegAdd(Rowid)),"^",3)
	 	.Q:DepID'=DepRowid
	 	.s MarkRowid=$p($g(^DHCRegAdd(Rowid)),"^",4)
	 	.s MarkDesc=""
	    .i MarkRowid'="" s MarkDesc=$P($G(^CTPCP(MarkRowid,1)),"^",2)
	    .s DepDesc=$p($g(^CTLOC(DepRowid)),"^",2)
	    .s Qty=$p($g(^DHCRegAdd(Rowid)),"^",5)
	    .s AddDate=$p($g(^DHCRegAdd(Rowid)),"^",6)
	    .s AddTime=$p($g(^DHCRegAdd(Rowid)),"^",7)
	    .s UserAdd=$p($g(^DHCRegAdd(Rowid)),"^",8)
	    .i UserAdd'="" s UserAdd=$P(^SSU("SSUSR",UserAdd),"^",2) 
	    .i AddDate'="" s AddDate=$ZD(AddDate,3)
	    .i AddTime'="" s AddTime=$ZT(AddTime)
	    .i AddDate'="" s AddDate=AddDate_" "_AddTime
	    .Do OutputRow
 }
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Rowid,DepDesc,MarkDesc,Qty,UserAdd,AddDate)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (Rowid,DepDesc,MarkDesc,Qty,UserAdd,AddDate)=""
	quit
}

ClassMethod FindFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
{
 //New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod Insert(Type As %String, RegDate As %String, DepID As %String, DocID As %String, Qty As %String, UserAddRowid As %String) As %String
{
	s AddDate=+$H
	s AddTime=$P($h,",",2)
	s RegDate=$ZDH(RegDate,4)
	&SQL(Insert into SQLUser.DHC_RegAdd (RA_Type,RA_RegDate,RA_Dep,RA_Doc,RA_Qty,RA_Date,RA_Time,RA_UserAdd_DR)
	Values (:Type,:RegDate,:DepID,:DocID,:Qty,:AddDate,:AddTime,:UserAddRowid))
	Q SQLCODE
}

ClassMethod QueryLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 //New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocExecute(ByRef QHandle As %Binary) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	
 Set repid=$I(^CacheTemp)
	s ind=1
	set LocRowid=0
 for  s LocRowid=$o(^PAC("ADMLOC",0,"AdmType","O",LocRowid)) q:LocRowid=""  d
 .s LocDesc=$p($g(^CTLOC(LocRowid)),"^",2)
 .s CTDesc=LocRowid_"_"_LocDesc
 .Do OutputRow
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CTDesc)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc)=""
	quit
}

ClassMethod QueryLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
 //New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query Find(DepID As %String, RegDate As %String) As %Query(ROWSPEC = "Rowid:%String,DepDesc:%String,MarkDesc:%String,Qty:%String,UserAdd:%String,AddDateTime:%String") [ SqlProc ]
{
}

Query FindDoc(DepID As %String, RegDate As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

Query QueryLoc() As %Query(ROWSPEC = "name:%String") [ SqlProc ]
{
}

}
