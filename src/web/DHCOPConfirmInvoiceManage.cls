/// author：wanghuicai
/// date：  2009-4-14
/// 描述：  对表DHC_ConfirmInvoice的增删改查,业务类
Class web.DHCOPConfirmInvoiceManage Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 描述：把票据核销时，把票据的rowid放到表DHC_ConfirmInvoice中
/// 作者：汪会财
/// 入参：DHC_INVOICE表rowid,SS_User表Rowid
/// 出参：SQLCODE
ClassMethod ConfirmInsert(invRowid, userRowid)
{
		k PLIST
		s PLIST(2)=invRowid
		s PLIST(3)=+$h
		s PLIST(4)=$p($h,",",2)
		s PLIST(5)=userRowid
		//s ^TMP(0,"wang",1)=PLIST(2)_"^"_PLIST(3)_"^"_PLIST(4)_"^"_PLIST(5)
		s rtn=##class(web.DHCOPConfirmInvoice).INSERT()
		q rtn
}

ClassMethod GetUserNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserNameExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^TMP("userName",$j)
	Quit $$$OK
}

ClassMethod GetUserNameExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    k ^TMP("userName",$j)
    s userDr=""
    f  s userDr=$o(^DHCCONFIRMINVOICE(0,"UserDr",userDr)) q:userDr=""  d
    .s userName=$p(^SSU("SSUSR",userDr),"^",2)
    .q:$g(^TMP("userName",$j,userDr))'=""
    .s ^TMP("userName",$j,userName)=userName
    .s ^TMP("userName",$j,userDr)=userDr
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(userName,userDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod GetUserNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// 描述：查询表DHC_ConfirmInvoice中的userName，userDr
/// 作者：汪会财 
/// 出参：userName，userDr
Query GetUserName() As %Query(ROWSPEC = "TusrName:%String,Trowid:%String")
{
}

/// ------------------------------------
ClassMethod ConfirmInvprtQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ConfirmInvprtQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ConfirmInvprtQueryExecute(ByRef qHandle As %Binary, inStDate As %String, inEndDate As %String, inUserRowid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s ind=1
 	;if inStDate="" s inStDate=+$h
 	;if inEndDate="" s inEndDate=+$h
 	s ^TMP("wang","date")=inStDate_" st ^ end "_inEndDate_" ^ userDr"_inUserRowid
 	i ((inStDate="")||(inEndDate="")) Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s conInvRowid=""
 	f date=inStDate:1:inEndDate  d
 	.f  s conInvRowid=$o(^DHCCONFIRMINVOICE(0,"Date",date,conInvRowid)) q:conInvRowid=""  d
	..s userDr=$p(^DHCCONFIRMINVOICE(conInvRowid),"^",4)
	..q:((userDr'=$g(inUserRowid))&&($g(inUserRowid)'=""))
	..s userName=$p(^SSU("SSUSR",userDr),"^",2)
	..s invRowid=$p(^DHCCONFIRMINVOICE(conInvRowid),"^",1)
	..s startNo=$p($g(^DHCINVOICE(invRowid)),"^",1)
	..s endNo=$p($g(^DHCINVOICE(invRowid)),"^",2)
	..s formatDate=$zd(date,3)
	..Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(conInvRowid,invRowid,formatDate,userName,startNo,endNo)
 	Set ^CacheTemp(repid,ind)=Data
 	s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ConfirmInvprtQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ConfirmInvprtQueryExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 描述：查询核销票据，表DHC_ConfirmInvoice
/// 作者：汪会财
/// 入参：date,user 
/// 出参：SQLCODE
Query ConfirmInvprtQuery(inStDate As %String, inEndDate As %String, inUserRowid As %String) As %Query(ROWSPEC = "TconfirmRowid:%String,TinvRowid:%String,Tdate:%String,Tuser:%String,TstartNum:%String,TendNum:%String")
{
}

///   ----------------------------------------

}
