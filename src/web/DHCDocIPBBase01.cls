Import SQLUser

/// Creator:	 吴群科
/// Description: 公共函数
/// Updater:     刘学峰
/// UpdateDate： 2008-11-03
Class web.DHCDocIPBBase01 Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 91;

/// 通过科室查找病房
/// Dep：科室ID
/// Create By LiYang 2008-11-1
ClassMethod QueryWardByDep(Dep)
{
	n (Dep)
	set ret=..GetWardByLoc(Dep)
	q ret
}

ClassMethod GetWardByLoc(cLoc)
{
    n (cLoc)
    s s=""
    ;^CTLOC({CT_Loc.CTLOC_RowID},"LINK",{LINK_Childsub})
    q:'$d(^CTLOC(+cLoc))
    s ChildSub=0
    f  s ChildSub=$o(^CTLOC(+cLoc,"LINK",ChildSub)) q:ChildSub=""  d
    .s cLocRowid=+$g(^CTLOC(+cLoc,"LINK",ChildSub))
    .q:cLocRowid=0
    .q:'$d(^CTLOC(+cLocRowid))
    .;^PAWARD(0,"WARD_LocationDR",{WARD_LocationDR},{WARD_RowID})
    .q:'$d(^PAWARD(0,"WARD_LocationDR",+cLocRowid))
    .s WARDID=0
    .f  s WARDID=$o(^PAWARD(0,"WARD_LocationDR",+cLocRowid,WARDID)) q:WARDID=""  d
    ..q:$p($g(^PAWARD(+WARDID)),"^",6)'="Y"
    ..s WardDesc=$p($g(^PAWARD(+WARDID)),"^",2)
    ..s TMP=+WARDID_"^"_WardDesc
    ..s s=s_TMP_$c(1)
    q s
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-03
/// Description：通过科室找病房,华西医院用
/// Table：      
/// Input：      wardid：病房ID
/// Output：     bedrowid^beddesc字符串，各数据间$c(1)分割
ClassMethod QueryBedByDep(wardid)
{
	n (wardid)
	q:wardid=""
	s ret=""
	s bedno=""
	s stdate=..%SysDate()
	s bedid="0"  
	f  s bedid=$o(^PAWARD(wardid,"BED",bedid))  q:bedid=""   d
	.s beddesc=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	.q:(bedno'="")&(bedno[beddesc)
	.s datefrom=$p(^PAWARD(wardid,"BED",bedid),"^",21)
	.s dateto=$p(^PAWARD(wardid,"BED",bedid),"^",22)
	.s BEDRcFlag=$p(^PAWARD(wardid,"BED",bedid),"^",4)
	.q:(BEDRcFlag'="Y")
	.q:(datefrom'="")&(stdate<datefrom)
	.q:(dateto'="")&(stdate>dateto)
	.s bedrowid=wardid_"||"_bedid
	.s warddesc=$p(^PAWARD(wardid),"^",2)
	.Q:'..IsAvailBed(bedrowid)
	.s statDesc=""
	.s unavail=##class(web.PACBedStatusChange).IsUnavailBedStatus(bedrowid,.statDesc)
	.Q:statDesc'=""
	.s ret = ret _ bedrowid _ "^" _ beddesc _ $c(1)
	q ret
}

ClassMethod IsAvailBed(BedRowId) As %String
{
	s avail=1
	s WardID=$P(BedRowId,"||",1)
	s BedSub=$P(BedRowId,"||",2)
	s BedSTATSub=$o(^PAWARDA(WardID,"BED",BedSub,"STAT",""),-1)
	i BedSTATSub'="",BedSTATSub'=0 d
    .s STATDateTo=$p($g(^PAWARDA(WardID,"BED",BedSub,"STAT",BedSTATSub)),"^",5)
	.s STATTimeTo=$p($g(^PAWARDA(WardID,"BED",BedSub,"STAT",BedSTATSub)),"^",6)
	.if (STATDateTo'="")&((STATDateTo<$p($h,",",1))!((STATDateTo=..%SysDate())&(STATTimeTo<..%SysTime()))) s avail=0
	b
	if avail=1 {
		s BedADMSub=$o(^PAWARDA(WardID,"BED",BedSub,"ADM",""),-1)
		i BedADMSub'="",BedADMSub'=0 {
			s BedADMDr=$p(^PAWARDA(WardID,"BED",BedSub,"ADM",BedADMSub),"^",1)
			i BedADMDr'="" s avail=0
		}
	}
	Q avail
}

/// 通过ctloc查找其DepartmentId
ClassMethod GetDepartmentByLocID(Ctloc)
{
	n (Ctloc)
	set ret = ""
	quit:Ctloc="" ret
	set DepID = ""
	set LocID = ""
	while 1
	{
		set DepID = $o(^CTLOC(0, "DepGrp", DepID))
		quit:DepID=""
		set LocID = ""
		while 1
		{
			set LocID = $o(^CTLOC(0, "DepGrp", DepID, LocID))
			quit:LocID=""
			set:LocID=Ctloc ret = DepID
		}
	}
	quit ret
}

ClassMethod admdeplookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admdeplookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admdeplookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	/*s rowid=0
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    .q:($p($g(^CTLOC(rowid)),"^",13)'="E")
    .s Desc=$p($g(^CTLOC(rowid)),"^",2)
    .Q:(Desc["门诊")
    .i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    .s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    .s:ContactName["-" ContactName=$p(ContactName,"-",1)
    .d OutputRow*/
	s rowid=0 ,AdmTypePut="I"
    f  s rowid=$O(^PAC("ADMLOC",0,"AdmType",AdmTypePut,rowid)) Q:rowid=""  d
    .s CTHospID=$p($g(^CTLOC(rowid)),"^",22)
	.s Desc=$p($g(^CTLOC(rowid)),"^",2)
	.i $l(Desc,"-")=2 s Desc=$p(Desc,"-",2)
	.s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    .s:ContactName["-" ContactName=$p(ContactName,"-",1)
    .d OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,Desc,ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admdeplookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admdeplookupExecute ]
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

/// Creator：    刘学峰
/// CreatDate：  2008-11-03
/// Description：查询科室Query
/// Table：      
/// Input：  	 desc：科室描述  
/// Output：     dep,depid,ContactName
Query admdeplookup(desc As %String) As %Query(ROWSPEC = "depid:%String,dep:%String,ContactName:%String")
{
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-09
/// Description：将科室Query处理成字符串
/// Table：      
/// Input：      desc：科室描述
/// Output：     depde_$C(1)_pid字符串,"^"分割
/// Debug:		 w ##class(web.DHCDocIPBBase01).GetDeptStr("")
ClassMethod GetDeptStr(desc As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCDocIPBBase01:admdeplookup")
	s ret=""
	
	do rset.Execute(desc)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

// 取科室

ClassMethod OPLoclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPLoclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod OPLoclookupExecute(ByRef qHandle As %Binary, desc As %String, LogonHospId As %String) As %Status
{
	s ^tempscl("OPLoclookup")=LogonHospId
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s OPLocdesc="",rowid="0"
	s rowid="0"
	f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","I",rowid))  q:rowid=""  d
	.s OPLocdesc=$p(^CTLOC(rowid),"^",2)
	.s OPLocdesc=$$ALPHAUP^SSUTIL4(OPLocdesc)
    .s CTLosHospId=$p(^CTLOC(rowid),"^",22)
    .q:(CTLosHospId'=LogonHospId)&&(LogonHospId'="")
	.i desc'=""  d
	..i OPLocdesc[desc  d
	...d OutputRow9
 	.e  d
 	..d OutputRow9
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
    
	set Data=$lb(OPLocdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OPLoclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPLoclookupExecute ]
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

Query OPLoclookup(desc As %String, LogonHospId As %String) As %Query(ROWSPEC = "OPLocdesc:%String,rowid:%String") [ SqlProc ]
{
}

}
