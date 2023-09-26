Class web.DHCWLReportHead Extends %RegisteredObject [ Not ProcedureBlock ]
{

// creator:杜晖

// date:2022年3月31日11:19:47

// duh使用的表头通用解析方法 api v1.0

/// 给句workload 表 收费分类ID 关联具体的 项目子表
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLReportHead","GetFeeTypeLinkDr")
Query GetFeeTypeLinkDr() As %Query(ROWSPEC = "linkDesc,acId,acDesc") [ SqlProc ]
{
}

ClassMethod GetFeeTypeLinkDrExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,startDate,endDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s acId = 0 f  s acId = $o(^DHCTarC("AC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("AC",acId),"^",2)
    .s linkDesc = 40
    .d outputRow1
    s acId = 0 f  s acId = $o(^DHCTarC("EC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("EC",acId),"^",2)
    .s linkDesc = 41
    .d outputRow1
    s acId = 0 f  s acId = $o(^DHCTarC("IC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("IC",acId),"^",2)
    .s linkDesc = 42
    .d outputRow1
    s acId = 0 f  s acId = $o(^DHCTarC("OC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("OC",acId),"^",2)
    .s linkDesc = 44
    .d outputRow1
    s acId = 0 f  s acId = $o(^DHCTarC("SC",acId)) q:acId=""  d
    .s acDesc = $p(^DHCTarC("SC",acId),"^",2)
    .s linkDesc = 45
    .d outputRow1
    //s acId = 0 f  s acId = $o( ^DHCTarC("TMCNew",acId)) q:acId=""  d
    //.s acDesc = $p(^DHCTarC("TMCNew",acId),"^",2)
    //.s linkDesc = "WorkLoad_TarMC_Dr"
 	//.d outputRow1
	Quit $$$OK
	
outputRow1
 s row=$listbuild(linkDesc,acId,acDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetFeeTypeLinkDrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFeeTypeLinkDrExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFeeTypeLinkDrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFeeTypeLinkDrExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 给句workload 表 收费分类ID 关联具体的 项目子表
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLReportHead","GetSomeLoc","2")
Query GetSomeLoc(HOSPID As %String) As %Query(ROWSPEC = "locId,locDesc") [ SqlProc ]
{
}

ClassMethod GetSomeLocExecute(ByRef qHandle As %Binary, HOSPID As %String) As %Status
{
	n (qHandle,startDate,endDate,HOSPID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s locId=0 f  s locId= $O(^CTLOC(locId)) q:locId=""  d
    .s locType = $p(^CTLOC(locId),"^",13)
    .;q:locType'="E"
    .s wardFlag = $p(^CTLOC(locId),"^",5)
    .;q:wardFlag'="N"
    .s locDesc = $p(^CTLOC(locId),"^",2)
    .s hosp = $P(^CTLOC(locId),"^",22)
    .q:hosp'=HOSPID
    .d outputRow2
   
	Quit $$$OK
	
outputRow2
 s row=$listbuild(locId,locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetSomeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSomeLocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSomeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSomeLocExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据就诊类型选择,区分科室类型
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLReportHead","GetSomeTypeLoc","2")
Query GetSomeTypeLoc(HOSPID As %String) As %Query(ROWSPEC = "locType,locId,locDesc") [ SqlProc ]
{
}

ClassMethod GetSomeTypeLocExecute(ByRef qHandle As %Binary, HOSPID As %String) As %Status
{
	n (qHandle,startDate,endDate,HOSPID,paType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s locId=0 f  s locId= $O(^CTLOC(locId)) q:locId=""  d
    .s locType = $p(^CTLOC(locId),"^",13)
    .q:locType'="E"
    .s wardFlag = $p(^CTLOC(locId),"^",5)
    .q:wardFlag'="N"
    .s locDesc = $p(^CTLOC(locId),"^",2)
    .s hosp = $P(^CTLOC(locId),"^",22)
    .q:hosp'=HOSPID
    .s locDepart = $P(^CTLOC(locId),"^",19)
    .s departDesc = $P(^RBC("DEP",locDepart),"^",2)
    .s locType=""
    .i (departDesc="门急诊科室")  d
    ..i $d(^CTLOC(locId,"LINK",0,"Loc"))=0  d
    ...s locType="O,E,H"
    ...d outputRow3
    .i (departDesc="临床科室")  d
    ..i $d(^CTLOC(locId,"LINK",0,"Loc"))=10  d
    ...s locType="I"
    ...d outputRow3
    .i (departDesc="门急诊科室")  d
    ..i $d(^CTLOC(locId,"LINK",0,"Loc"))=0  d
    ...s locType="O"
    ...d outputRow3
    .i (departDesc="门急诊科室")  d
    ..i $d(^CTLOC(locId,"LINK",0,"Loc"))=0  d
    ...s locType="E"
    ...d outputRow3
    .i (departDesc="门急诊科室")  d
    ..i $d(^CTLOC(locId,"LINK",0,"Loc"))=0  d
    ...s locType="H"
    .i (departDesc="门急诊科室")  d
    ..i $d(^CTLOC(locId,"LINK",0,"Loc"))=0  d
    ...s locType="O,E"
    ...d outputRow3
	Quit $$$OK
	
outputRow3
 s row=$listbuild(locType,locId,locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetSomeTypeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSomeTypeLocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSomeTypeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSomeTypeLocExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据医院选择过滤 科室
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLReportHead","GetHospLoc")
Query GetHospLoc() As %Query(ROWSPEC = "hosp,locId,locDesc") [ SqlProc ]
{
}

ClassMethod GetHospLocExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s locId=0 f  s locId= $O(^CTLOC(locId)) q:locId=""  d
    .s hosp =$p(^CTLOC(locId),"^",22)
    .s locDesc = $P(^CTLOC(locId),"^",2)
    .d outputRow4
	Quit $$$OK
	
outputRow4
 s row=$listbuild(hosp,locId,locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetHospLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospLocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospLocExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLReportHead","GetAllDoc")
Query GetAllDoc() As %Query(ROWSPEC = "docId,docDesc") [ SqlProc ]
{
}

ClassMethod GetAllDocExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s docId=0 f  s docId=$O(^CTPCP(docId)) q:docId=""  d
    .s docDesc = $p(^CTPCP(docId,1),"^",2)
    .d outputRow5
	Quit $$$OK
	
outputRow5
 s row=$listbuild(docId,docDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAllDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllDocExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
