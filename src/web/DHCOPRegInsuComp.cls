Import SQLUser

Class web.DHCOPRegInsuComp Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 23;

ClassMethod RCFAdmReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RCFAdmReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// W ##class(%ResultSet).RunQuery("web.DHCOPRegInsuComp","RCFAdmReason")

ClassMethod RCFAdmReasonExecute(ByRef qHandle As %Binary, AdmReason As %String, InsuPatTypeCode As %String, NowOrdItemDr As %String, UploadOrdItemDr As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s tmpRowid=""
	s ^songsong("RCFAdmReasonExecute")=AdmReason_"^"_InsuPatTypeCode_"^"_NowOrdItemDr_"^"_UploadOrdItemDr_"^"_StartDate_"^"_EndDate 
	s:EndDate="" EndDate=99999999
	s tmpAdmReason=0
	s tmpRowid=0
	f  s tmpRowid=$o(^User.DHCOPRegInsuCompD(tmpRowid)) q:tmpRowid=""  d
	.s RcfData=$g(^User.DHCOPRegInsuCompD(tmpRowid))
	.s tmpAdmReason=$List(RcfData,8)
	.;w !,"tmpAdmReason=",tmpAdmReason
	.q:((AdmReason'="")&(tmpAdmReason'=AdmReason))
	.s tmpInsuPatTypeCode=$List(RcfData,2)
	.q:((InsuPatTypeCode'="")&(InsuPatTypeCode'=tmpInsuPatTypeCode))
	.;s ^songsong($I(^songsong))=tmpRowid
	.s tmpNowOrdItemDr=$List(RcfData,3)
	.q:((NowOrdItemDr'="")&(NowOrdItemDr'=tmpNowOrdItemDr))
	.s tmpNowOrdItem=$p($g(^ARCIM(+tmpNowOrdItemDr,$p(tmpNowOrdItemDr,"||",2),1)),"^",2)
	.;UploadOrdItemDr_"^"_StartDate_"^"_EndDate 
	.s tmpUploadOrdItemDr=$List(RcfData,5)
	.q:((UploadOrdItemDr'="")&(UploadOrdItemDr'=tmpUploadOrdItemDr))
	.s tmpUploadOrdItem=$p($g(^ARCIM(+tmpUploadOrdItemDr,$p(tmpUploadOrdItemDr,"||",2),1)),"^",2)
	.s tmpStartDate=$List(RcfData,7)
	.;q:((StartDate'="")&(StartDate<tmpStartDate))
	.s:(tmpStartDate'="") tmpStartDate=..%ZD(tmpStartDate) //$zd(tmpStartDate,4)
	.s tmpEndDate=$List(RcfData,6)
	.;q:((EndDate'="")&(EndDate<tmpEndDate))
	.s:(tmpEndDate'="") tmpEndDate=..%ZD(tmpEndDate) //$zd(tmpEndDate,4)
	.s READesc=""
	.i tmpAdmReason'=""  d
	..s READesc=$p($g(^PAC("ADMREA",tmpAdmReason)),"^",2)
	.d Build1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1      
	set Data=$lb(tmpAdmReason,tmpRowid,READesc,tmpStartDate,tmpEndDate,tmpInsuPatTypeCode,tmpNowOrdItem,tmpNowOrdItemDr,tmpUploadOrdItem,tmpUploadOrdItemDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod RCFAdmReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RCFAdmReasonExecute ]
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

Query RCFAdmReason(AdmReason As %String, InsuPatTypeCode As %String, NowOrdItemDr As %String, UploadOrdItemDr As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "AdmReasonRowid:%String,TRowid:%String,TabAdmReason:%String,TabStartDate:%String,TabEndDate:%String,TabInsuPatTypeCode:%String,TabNowOrdItem:%String,TabNowOrdItemDr:%String,TabUploadOrdItem:%String,TabUploadOrdItemDr:%String")
{
}

ClassMethod orderlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = orderlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// W ##class(%ResultSet).RunQuery("web.DHCOPRegInsuComp","orderlookup","")
ClassMethod orderlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare orderc cursor  for 
	select distinct alias_arcim_dr,alias_arcim_dr->arcim_desc
    from SQLUser.arc_ALIAS 
	              WHERE (UPPER(ALIAS_text) like :desc))
	&sql(open orderc)
	f  &sql(fetch orderc into :orderrowid,:orderdesc) q:SQLCODE  d
	.q:orderdesc=""
	.Q:$$valrow(orderrowid)
 	.Do OutputRow3 	 	
 	&sql(close orderc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(orderdesc,orderrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 q 0
}

ClassMethod orderlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = orderlookupExecute ]
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

Query orderlookup(desc As %String) As %Query(ROWSPEC = "ARCIMDesc:%String,ALIASARCIMDR:%String")
{
}

/// w ##class(web.DHCOPRegInsuComp).FeeCate()
ClassMethod FeeCate() As %String
{
	s OutStr="^"
	s REARowid="0"
	f  s REARowid=$o(^PAC("ADMREA",REARowid))  q:REARowid=""  d
	.s READesc=$P(^PAC("ADMREA",REARowid),"^",2)
	.s BillTypeSttDate=$p(^PAC("ADMREA",REARowid),"^",3)
	.q:(BillTypeSttDate'="")&&(BillTypeSttDate>+$h)
	.s BillTypeEndDate=$p(^PAC("ADMREA",REARowid),"^",4)
	.q:(BillTypeEndDate'="")&&(BillTypeEndDate<+$h)
	.s OutStr=OutStr_"!"_REARowid_"^"_READesc
	q OutStr
	
	f  s REARowid=$o(^PAC("ADMREA",REARowid))  q:REARowid=""  d
	.s READesc=$P(^PAC("ADMREA",REARowid),"^",2)
	.s OutStr=OutStr_"^"_REARowid_$c(1)_READesc
	q OutStr
}

/// w ##class(web.DHCOPRegInsuComp).FeeCate()
ClassMethod Insert(InStr As %String) As %String
{
	n (InStr)
	;s InStr="^6^^^3||1^9||1^21/01/2011"
	s ^songsong("Insert")=InStr
	q:InStr="" -100
	s PLIST(2)=$p(InStr,"^",2) //RIC_AdmReason_DR
	s PLIST(3)=$p(InStr,"^",3) //   RIC_EndDate
	i +PLIST(3)'=0   d
	.s PLIST(3)=..%ZDH(PLIST(3)) //$zdh(PLIST(3),4)
	s PLIST(4)=$p(InStr,"^",4) //   RIC_InsuPatTypeCode 
	s PLIST(5)=$p(InStr,"^",5) //   RIC_NowOrdItem   
	s PLIST(6)=$p(InStr,"^",6) //   RIC_StartDate
	i +PLIST(6)'=0   d
	.s PLIST(6)=..%ZDH($p(InStr,"^",6)) //$zdh($p(InStr,"^",6),4)
	s PLIST(7)=$p(InStr,"^",7) //   RIC_UploadOrdItem    
	&sql(insert into DHC_OPRegInsuComp values :PLIST())  
	q:SQLCODE SQLCODE
	s flag=$p(%ROWID,$c(1))
	q flag
}

/// w ##class(web.DHCOPRegInsuComp).FeeCate()
ClassMethod Update(InStr As %String) As %String
{
	n (InStr)
	s ^songsong("Update")=InStr
	;s InStr="3^^^aaaa^5||1^21/01/2011^3||1"
	q:InStr="" -100
	s PLIST(1)=$p(InStr,"^",1)
	s PLIST(2)=$p(InStr,"^",2) //RIC_AdmReason_DR
	s PLIST(3)=$p(InStr,"^",3) //   RIC_EndDate
	i +PLIST(3)'=0   d
	.s PLIST(3)=..%ZDH(PLIST(3)) //$zdh(PLIST(3),4)
	s PLIST(4)=$p(InStr,"^",4) //   RIC_InsuPatTypeCode 
	s PLIST(5)=$p(InStr,"^",5) //   RIC_NowOrdItem   
	s PLIST(6)=$p(InStr,"^",6) //   RIC_StartDate
	i +PLIST(6)'=0   d
	.s PLIST(6)=..%ZDH($p(InStr,"^",6)) //$zdh($p(InStr,"^",6),4)
	s PLIST(7)=$p(InStr,"^",7) //   RIC_UploadOrdItem
	&sql(Update DHC_OPRegInsuComp set RIC_AdmReason_DR=:PLIST(2),
					RIC_EndDate=:PLIST(3),
					RIC_InsuPatTypeCode=:PLIST(4),
					RIC_NowOrdItem=:PLIST(5),
					RIC_StartDate=:PLIST(6),
					RIC_UploadOrdItem=:PLIST(7) where RIC_RowId=:PLIST(1))
	s ^songsong=SQLCODE
	q:SQLCODE SQLCODE
	s flag=$p(%ROWID,$c(1))
	q flag
}

/// w ##class(web.DHCOPRegInsuComp).FeeCate()
ClassMethod Delete(Rowid As %String) As %String
{
	n (Rowid)
	s ^songsong("Delete")=Rowid
	&sql(Delete from DHC_OPRegInsuComp  where RIC_RowId=:Rowid) 
	q SQLCODE
}

}
