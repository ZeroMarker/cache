Import SQLUSER

Class web.DHCICUCViewCat Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// Parameter BUILD = 4;

// Parameter SQLDATEFROM;

// Parameter SQLDATETO;

// Parameter SQLCODE = "ANCVC_Code";

// Parameter SQLDESCRIPTION = "ANCVC_Desc";

// Parameter SQLROWID = "ID";

/// d ##class(%ResultSet).RunQuery("web.DHCICUCViewCat","FindICUViewCat")
Query FindICUViewCat(icucvcCode As %String, icucvcDesc As %String, icucvscDesc As %String, icucvcSummaryType As %String) As %Query(ROWSPEC = "tRowId:%String,tIcucvcCode:%String,tIcucvcDesc:%String,tIcucvcVPSite:%String,tIcucvcVS:%String,tIcucvcEvent:%String,tIcucvcOrder:%String,tIcucvcTherapy:%String,tIcucvcLab:%String,tIcucvscDesc:%String,tIcucvscId:%String,tIcucvcDisplayByCat:%String,tIcucvcSummaryType:%String,tIcucvcSummaryTypeDesc:%String,tIcucvcOptions:%String") [ SqlProc ]
{
}

ClassMethod FindICUViewCatExecute(ByRef qHandle As %Binary, icucvcCode As %String = "", icucvcDesc As %String = "", icucvscDesc As %String = "", icucvcSummaryType As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tRowId=0
	f  s tRowId=$o(^DHCICUC("ViewCat",tRowId)) q:tRowId=""  d
	.s tIcucvcCode=$p(^DHCICUC("ViewCat",tRowId),"^",1)
	.q:(icucvcCode'="")&&(tIcucvcCode'[icucvcCode)
	.s tIcucvcDesc=$p(^DHCICUC("ViewCat",tRowId),"^",2)
	.q:(icucvcDesc'="")&&(tIcucvcDesc'[icucvcDesc)
	.s tIcucvcVS=$p($g(^DHCICUC("ViewCat",tRowId)),"^",3)
	.s tIcucvcOrder=$p($g(^DHCICUC("ViewCat",tRowId)),"^",4)
	.s tIcucvcEvent=$p($g(^DHCICUC("ViewCat",tRowId)),"^",5)
	.s tIcucvcVPSite=$p($g(^DHCICUC("ViewCat",tRowId)),"^",6) 
	.s tIcucvcTherapy=$p($g(^DHCICUC("ViewCat",tRowId)),"^",12)
	.s tIcucvcLab=$p($g(^DHCICUC("ViewCat",tRowId)),"^",13)
	
	.s tIcucvcOptions=$p(^DHCICUC("ViewCat",tRowId),"^",17)
    
    .s tIcucvscId=$p($g(^DHCICUC("ViewCat",tRowId)),"^",10)
    .q:(icucvscDesc'="")&&(tIcucvscId'=icucvscDesc)
    .s tIcucvscDesc=""
    .i tIcucvscId'="" s tIcucvscDesc=$p($g(^DHCICUC("VSCat",tIcucvscId)),"^",2)
    .s tIcucvcDisplayByCat=$p($g(^DHCICUC("ViewCat",tRowId)),"^",11)
    .s tIcucvcSummaryType=$p($g(^DHCICUC("ViewCat",tRowId)),"^",14)
    .q:(icucvcSummaryType'="")&&(icucvcSummaryType'=tIcucvcSummaryType)
    .s tIcucvcSummaryTypeDesc=##class(web.DHCCLCom).GetComDescByCode("SummaryType",tIcucvcSummaryType)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(tRowId,tIcucvcCode,tIcucvcDesc,tIcucvcVPSite,tIcucvcVS,tIcucvcEvent,tIcucvcOrder,tIcucvcTherapy,tIcucvcLab,tIcucvscDesc,tIcucvscId,tIcucvcDisplayByCat,tIcucvcSummaryType,tIcucvcSummaryTypeDesc,tIcucvcOptions)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUViewCatExecute ]
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

ClassMethod FindICUViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindICUCVC() As %Query(ROWSPEC = "Id:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod FindICUCVCExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="1",Desc="Y"
	d OutputRow1
	s Id="0",Desc="N"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Id,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCVCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCVCExecute ]
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

ClassMethod FindICUCVCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCVCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindAncvpsite() As %Query(ROWSPEC = "vpsiteDesc:%String,vpsiteDr:%String") [ SqlProc ]
{
}

ClassMethod FindAncvpsiteExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s vpsiteDr=0
	f  s vpsiteDr=$o(^DHCANC("VPSite",vpsiteDr))  q:vpsiteDr=""  d
    .s vpsiteDesc=$p(^DHCANC("VPSite",vpsiteDr),"^",2)
	.d OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(vpsiteDesc,vpsiteDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAncvpsiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAncvpsiteExecute ]
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

ClassMethod FindAncvpsiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAncvpsiteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindAnclcon() As %Query(ROWSPEC = "lconDesc:%String,lconDr:%String") [ SqlProc ]
{
}

ClassMethod FindAnclconExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s lconDr=0
	f  s lconDr=$o(^DHCANC("Icon",lconDr))  q:lconDr=""  d
    .s lconDesc=$p(^DHCANC("Icon",lconDr),"^",2)
	.d OutputRow5
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(lconDesc,lconDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAnclconFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnclconExecute ]
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

ClassMethod FindAnclconClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnclconExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepICUCViewCat(icucvcCode As %String)
{
    ;w ##class(web.DHCANRoomEquipDetail).RepMoniDataItemDesc("31","脉搏")
    s flag="N"
	s tRowid=0 
	   f  s tRowid=$o(^DHCICUC("ViewCat",tRowid)) q:tRowid=""  d
	      .s tIcucvcCode=$p(^DHCICUC("ViewCat",tRowid),"^",1)
	      .i tIcucvcCode=icucvcCode   s flag="Y"
	q flag
}

ClassMethod InsertICUCViewCat(icucvcCode As %String, icucvcDesc As %String, icucvcVS As %String, icucvcOrder As %String, icucvcEvent As %String, icucvcVPSite As %String, icucvscDesc As %String, icucvcDisplayByCat As %String, icucvcTherapy As %String, icucvcLab As %String, icucvcSummaryType As %String, icucvcOptions As %String)
{
	q:icucvcCode="" "代码不能为空!"
	q:icucvcDesc="" "描述不能为空!"
	q:icucvscDesc="" "显示大类不能为空!"
	q:$o(^DHCICUC("ViewCat",0,icucvcCode,""))'="" "代码重复!"
	
	k PLIST
	TSTART
	;w ##class(web.DHCANRoomEquipDetail).InsertMoniDataItem("31","18","Y","11")
	s PLIST(2)=icucvcCode
	s PLIST(3)=icucvcDesc
	s PLIST(4)=icucvcVS
	s PLIST(5)=icucvcOrder
	s PLIST(6)=icucvcEvent
	s PLIST(7)=icucvcVPSite
	s PLIST(9)="Y" //ICUCVC_IcuApply
	s PLIST(11)=icucvscDesc
	s PLIST(12)=icucvcDisplayByCat
	s PLIST(13)=icucvcTherapy
	s PLIST(14)=icucvcLab
	s PLIST(15)=icucvcSummaryType
	s PLIST(18)=icucvcOptions
	&SQL(insert into SQLUSER.DHC_ICUC_ViewCat Values :PLIST())
	b ;SQLCODE
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateICUCViewCat(Rowid As %String, icucvcCode As %String, icucvcDesc As %String, icucvcVS As %String, icucvcOrder As %String, icucvcEvent As %String, icucvcVPSite As %String, icucvscDesc As %String, icucvcDisplayByCat As %String, icucvcTherapy As %String, icucvcLab As %String, icucvcSummaryType As %String, icucvcOptions As %String)
{
 	q:Rowid="" "记录Id为空!"
 	q:icucvcCode="" "代码不能为空!"
	q:icucvcDesc="" "描述不能为空!"
	q:icucvscDesc="" "显示大类不能为空!"
	q:($o(^DHCICUC("ViewCat",0,icucvcCode,""))'="")&($o(^DHCICUC("ViewCat",0,icucvcCode,""))'=Rowid) "代码重复!"

   ;w ##class(web.DHCANCViewCat).UpdateANCViewCat("1","22","55","N","N","Y","","Y")
	k PLIST 
	;&sql(select * into :PLIST() from SQLUSER.DHC_ANC_MoniDataItem where ANCMDI_RowId=:Rowid)
    ;i SQLCODE TRollBack  q
	//s PLIST(1)="4"  //Rowid
	s PLIST(2)=icucvcCode
	s PLIST(3)=icucvcDesc
	s PLIST(4)=icucvcVS
	s PLIST(5)=icucvcOrder
	s PLIST(6)=icucvcEvent
	s PLIST(7)=icucvcVPSite
	s PLIST(9)="Y" //ICUCVC_IcuApply
	
	s PLIST(11)=icucvscDesc
	s PLIST(12)=icucvcDisplayByCat
	s PLIST(13)=icucvcTherapy
	s PLIST(14)=icucvcLab
	s PLIST(15)=icucvcSummaryType
	s PLIST(18)=icucvcOptions
	&sql(update SQLUSER.DHC_ICUC_ViewCat Values :PLIST() where ICUCVC_RowId=:Rowid)
 q SQLCODE
}

ClassMethod DeleteICUCViewCat(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from SQLUSER.DHC_ICUC_ViewCat where ICUCVC_RowId=:Rowid)
	q SQLCODE
}

ClassMethod DelVCAppFlag(val As %String)
{
	set Rowid=$p(val,"^",1)
	q:Rowid="" ""
    set ANCVCAnApply=$p(val,"^",2)
    set ANCVCIcuApply=$p(val,"^",3)
    i ANCVCAnApply="N" d
    .&sql(Update SQLUSER.DHC_ANC_ViewCat set ANCVC_AnApply=:ANCVCAnApply Where Ancvc_RowId=:Rowid)
    i ANCVCIcuApply="N" d
    .&sql(Update SQLUSER.DHC_ANC_ViewCat set ANCVC_IcuApply=:ANCVCIcuApply Where Ancvc_RowId=:Rowid)
	q SQLCODE
}

Query FindVSC() As %Query(ROWSPEC = "icucvscId:%String,icucvscDesc:%String") [ SqlProc ]
{
}

ClassMethod FindVSCExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s icucvscId=0
	f  s icucvscId=$o(^DHCICUC("VSCat",icucvscId))  q:icucvscId=""  d
    .s icucvscDesc=$p(^DHCICUC("VSCat",icucvscId),"^",2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(icucvscId,icucvscDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindVSCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVSCExecute ]
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

ClassMethod FindVSCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVSCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetViewCatList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   icucvc_code As Code,
	   icucvc_desc As Description,
	   icucvc_icucvsc_dr As DocumentId,
	   ICUCVC_Therapy As IsTherapy,
	   ICUCVC_Lab As IsLab,
	   ICUCVC_VitalSign As IsVitalSign,
	   ICUCVC_Order As IsDrug,
	   ICUCVC_Event As IsEvent,
	   icucvc_summarytype As SummaryType FROM DHC_ICUC_ViewCat WHERE icucvc_icuapply='Y'
}

}
