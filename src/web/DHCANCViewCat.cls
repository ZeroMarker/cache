Import SQLUSER

Class web.DHCANCViewCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 4;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ANCVC_Code";

Parameter SQLDESCRIPTION = "ANCVC_Desc";

Parameter SQLROWID = "ID";

/// d ##class(%ResultSet).RunQuery("web.DHCANCViewCat","FindANCViewCat","N","")
Query FindANCViewCat(IcuApply As %String, AllApply As %String, Desc As %String = "") As %Query(ROWSPEC = "tRowid:%String,tAncvcCode:%String,tAncvcDesc:%String,tAncvcVPSite:%String,tAncvcVs:%String,tAncvcEvent:%String,tAncvcOrder:%String,tAncvcTherapy:%String,tAncvcLab:%String,tANCVSCDesc:%String,tANCVSCId:%String,tAncvcDisplayByCat:%String,tAncvcSummaryType:%String,tAncvcSummaryTypeDesc:%String,tOptions:%String,tANCOViewCatDesc:%String,tANCOViewCatDr:%String")
{
}

ClassMethod FindANCViewCatExecute(ByRef qHandle As %Binary, IcuApply As %String = "", AllApply As %String = "", Desc As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i AllApply="" s AllApply="N"
	s tRowid=0
	f  s tRowid=$o(^DHCANC("ViewCat",tRowid)) q:tRowid=""  d
	.s tAncvcCode=$p(^DHCANC("ViewCat",tRowid),"^",1)
	.s tAncvcDesc=$p(^DHCANC("ViewCat",tRowid),"^",2)
	.q:(Desc'="")&&(tAncvcDesc'[Desc)
	.s tAncvcVs=$p($g(^DHCANC("ViewCat",tRowid)),"^",3)
	.s tAncvcOrder=$p($g(^DHCANC("ViewCat",tRowid)),"^",4)
	.s tAncvcEvent=$p($g(^DHCANC("ViewCat",tRowid)),"^",5)
	.s tAncvcVPSite=$p($g(^DHCANC("ViewCat",tRowid)),"^",6) 
	.s tAncvcTherapy=$p($g(^DHCANC("ViewCat",tRowid)),"^",12)
	.s tAncvcLab=$p($g(^DHCANC("ViewCat",tRowid)),"^",13)
	.s tAncvcAnApply=$p(^DHCANC("ViewCat",tRowid),"^",7)
	.s tOptions=$p(^DHCANC("ViewCat",tRowid),"^",17)
    .q:(tAncvcAnApply'="Y")&(IcuApply'="Y")&(AllApply="N")
    .s tAncvcIcuApply=$p(^DHCANC("ViewCat",tRowid),"^",8)
    .q:(tAncvcIcuApply'="Y")&(IcuApply="Y")&(AllApply="N")
    .s tANCVSCId=$p($g(^DHCANC("ViewCat",tRowid)),"^",10)
    .s tANCVSCDesc=""
    .i tANCVSCId'="" s tANCVSCDesc=$p($g(^DHCANC("VSCat",tANCVSCId)),"^",2)
    .s tAncvcDisplayByCat=$p($g(^DHCANC("ViewCat",tRowid)),"^",11)
    .s tAncvcSummaryType=$p($g(^DHCANC("ViewCat",tRowid)),"^",14)
    .s tAncvcSummaryTypeDesc=##class(web.DHCCLCom).GetComDescByCode("SummaryType",tAncvcSummaryType)
    .s tANCOViewCatDr=$p(^DHCANC("ViewCat",tRowid),"^",18)
    .s tANCOViewCatDesc=""
    .f j=1:1:$l(tANCOViewCatDr,";") d
    ..s ViewCatDr=$p(tANCOViewCatDr,";",j)
    ..q:ViewCatDr=""
	..i (tANCOViewCatDesc="") s tANCOViewCatDesc = $p($g(^DHCANC("ViewCat",+ViewCatDr)),"^",2)
    ..e  s tANCOViewCatDesc = tANCOViewCatDesc_";"_$p($g(^DHCANC("ViewCat",+ViewCatDr)),"^",2)
    .;s tANCOViewCatDesc=$p(^DHCANC("ViewCat",tANCOViewCatDr),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(tRowid,tAncvcCode,tAncvcDesc,tAncvcVPSite,tAncvcVs,tAncvcEvent,tAncvcOrder,tAncvcTherapy,tAncvcLab,tANCVSCDesc,tANCVSCId,tAncvcDisplayByCat,tAncvcSummaryType,tAncvcSummaryTypeDesc,tOptions,tANCOViewCatDesc,tANCOViewCatDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCViewCatExecute ]
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

ClassMethod FindANCViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindAncVC() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindAncVCExecute(ByRef qHandle As %Binary) As %Status
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
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAncVCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAncVCExecute ]
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

ClassMethod FindAncVCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAncVCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindAncvpsite() As %Query(ROWSPEC = "vpsiteDesc:%String,vpsiteDr:%String")
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

Query FindAnclcon() As %Query(ROWSPEC = "lconDesc:%String,lconDr:%String")
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

ClassMethod RepANCViewCat(ancvcCode As %String)
{
    ;w ##class(web.DHCANRoomEquipDetail).RepMoniDataItemDesc("31","脉搏")
    s flag="N"
	s tRowid=0 
	   f  s tRowid=$o(^DHCANC("ViewCat",tRowid)) q:tRowid=""  d
	      .s tAncvcCode=$p(^DHCANC("ViewCat",tRowid),"^",1)
	      .i tAncvcCode=ancvcCode   s flag="Y"
	q flag
}

ClassMethod InsertANCViewCat(ancvcCode As %String, ancvcDesc As %String, ancvcVs As %String, ancvcOrder As %String, ancvcEvent As %String, ancvcVPSite As %String, ancvcTherapy As %String, ancvcLab As %String, ancvcAnApply As %String, ancvcIcuApply As %String, ANCVSCId As %String, ancvcDisplayByCat As %String, ancvcSummaryType As %String, ancvcOptions As %String, ANCOViewCatDr As %String)
{
	q:ancvcCode="" "代码不能为空!"
	q:ancvcDesc="" "描述不能为空!"
	q:ANCVSCId="" "显示大类不能为空!"
	q:$o(^DHCANC("ViewCat",0,"ancvcCode",""))'="" "代码重复!"
	
	k PLIST
	TSTART
	;w ##class(web.DHCANRoomEquipDetail).InsertMoniDataItem("31","18","Y","11")
	s PLIST(2)=ancvcCode
	s PLIST(3)=ancvcDesc
	s PLIST(4)=ancvcVs
	s PLIST(5)=ancvcOrder
	s PLIST(6)=ancvcEvent
	s PLIST(7)=ancvcVPSite
	s PLIST(8)=ancvcAnApply
	s PLIST(9)=ancvcIcuApply
	s PLIST(11)=ANCVSCId
	s PLIST(12)=ancvcDisplayByCat
	s PLIST(13)=ancvcTherapy
	s PLIST(14)=ancvcLab
	s PLIST(15)=ancvcSummaryType
	s PLIST(18)=ancvcOptions
	s PLIST(19)=ANCOViewCatDr
	&SQL(insert into SQLUSER.DHC_ANC_ViewCat (ANCVC_Code,ANCVC_Desc,ANCVC_VitalSign,ANCVC_Order,ANCVC_Event,ANCVC_VPSite,ANCVC_AnApply,ANCVC_IcuApply,ANCVC_ANCVSC_Dr,ANCVC_DisplayByCat,ANCVC_Therapy,ANCVC_Lab,ANCVC_SummaryType,ANCVC_Options,ANCVC_RelateCat) values (:ancvcCode,:ancvcDesc,:ancvcVs,:ancvcOrder,:ancvcEvent,:ancvcVPSite,:ancvcAnApply,:ancvcIcuApply,:ANCVSCId,:ancvcDisplayByCat,:ancvcTherapy,:ancvcLab,:ancvcSummaryType,:ancvcOptions,:ANCOViewCatDr))
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateANCViewCat(Rowid As %String, ancvcCode As %String, ancvcDesc As %String, ancvcVs As %String, ancvcOrder As %String, ancvcEvent As %String, ancvcVPSite As %String, ancvcTherapy As %String, ancvcLab As %String, ancvcAnApply As %String, ancvcIcuApply As %String, ANCVSCId As %String, ancvcDisplayByCat As %String, ancvcSummaryType As %String, ancvcOptions As %String, ANCOViewCatDr As %String)
{
 	q:Rowid="" "记录Id为空!"
 	q:ancvcCode="" "代码不能为空!"
	q:ancvcDesc="" "描述不能为空!"
	q:ANCVSCId="" "显示大类不能为空!"
	q:($o(^DHCANC("ViewCat",0,ancvcCode,""))'="")&($o(^DHCANC("ViewCat",0,ancvcCode,""))'=Rowid) "代码重复!"

   ;w ##class(web.DHCANCViewCat).UpdateANCViewCat("1","22","55","N","N","Y","","Y")
	k PLIST 
	;&sql(select * into :PLIST() from SQLUSER.DHC_ANC_MoniDataItem where ANCMDI_RowId=:Rowid)
    ;i SQLCODE TRollBack  q
	//s PLIST(1)="4"  //Rowid
	s PLIST(2)=ancvcCode
	s PLIST(3)=ancvcDesc
	s PLIST(4)=ancvcVs
	s PLIST(5)=ancvcOrder
	s PLIST(6)=ancvcEvent
	s PLIST(7)=ancvcVPSite
	//s PLIST(8)=""
	i ancvcAnApply="" s PLIST(8)=$p($g(^DHCANC("ViewCat",Rowid)),"^",7)
    e  s PLIST(8)=ancvcAnApply
	i ancvcIcuApply="" s PLIST(9)=$p($g(^DHCANC("ViewCat",Rowid)),"^",8)
	e  s PLIST(9)=ancvcIcuApply
	s PLIST(11)=ANCVSCId
	s PLIST(12)=ancvcDisplayByCat
	s PLIST(13)=ancvcTherapy
	s PLIST(14)=ancvcLab
	s PLIST(15)=ancvcSummaryType
	s PLIST(18)=ancvcOptions
	s PLIST(19)=ANCOViewCatDr
	&sql(update SQLUSER.DHC_ANC_ViewCat Values :PLIST() where Ancvc_RowId=:Rowid)
 q SQLCODE
}

ClassMethod DeleteANCViewCat(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from SQLUSER.DHC_ANC_ViewCat where Ancvc_RowId=:Rowid)
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

Query FindVSC() As %Query(ROWSPEC = "ANCVSCDesc:%String,ANCVSCId:%String")
{
}

ClassMethod FindVSCExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ANCVSCId=0
	f  s ANCVSCId=$o(^DHCANC("VSCat",ANCVSCId))  q:ANCVSCId=""  d
    .s ANCVSCDesc=$p(^DHCANC("VSCat",ANCVSCId),"^",2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(ANCVSCDesc,ANCVSCId)
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

Query GetViewCatList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   ancvc_code As Code,
	   ancvc_desc As Description,
	   ancvc_ancvsc_dr As DocumentId,
	   ancvc_summarytype As SummaryType FROM DHC_ANC_ViewCat WHERE ancvc_icuapply='Y'
}

Query GetANViewCatList() As %SQLQuery(CONTAINID = 1)
{

SELECT %ID As Id,
	   ancvc_code As Code,
	   ancvc_desc As Description,
	   ancvc_ancvsc_dr As CategoryId,
	   ANCVC_VitalSign As VitalSign,
	   ANCVC_Order As Drug,
	   ANCVC_Event As Event,
	   ANCVC_Therapy As Therapy,
	   ANCVC_Lab As Lab,
	   ANCVC_DisplayByCat As DisplayByCat,
	   ANCVC_DataFormat As DataFormat,
	   ANCVC_Options As FormatField,
	   ANCVC_RelateCat As RelateCatId
	   FROM DHC_ANC_ViewCat WHERE ancvc_anapply='Y'
}

Query FindANCDrugViewCat() As %Query(ROWSPEC = "Id:%String,AncvcCode:%String,AncvcDesc:%String")
{
}

ClassMethod FindANCDrugViewCatExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tRowid=0
	f  s tRowid=$o(^DHCANC("ViewCat",tRowid)) q:tRowid=""  d
	.s tAncvcCode=$p(^DHCANC("ViewCat",tRowid),"^",1)
	.;q:(tAncvcCode["PACU")
	.s tAncvcDesc=$p(^DHCANC("ViewCat",tRowid),"^",2)
	.s tAncvcVitalSign=$p($g(^DHCANC("ViewCat",tRowid)),"^",3)
	.s tAncvcOrder=$p($g(^DHCANC("ViewCat",tRowid)),"^",4)
	.s tAncvcEvent=$p($g(^DHCANC("ViewCat",tRowid)),"^",5)
	.q:((tAncvcVitalSign'="Y")&&(tAncvcOrder'="Y")&&(tAncvcEvent'="Y"))
	.d OutputCatRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputCatRow
	set Data=$lb(tRowid,tAncvcCode,tAncvcDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCDrugViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCDrugViewCatExecute ]
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

ClassMethod FindANCDrugViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCDrugViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
