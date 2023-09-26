Import SQLUser

/// Creator:	 吴群科
/// Description: 公共函数
/// Updater:     刘学峰
/// UpdateDate： 2008-11-03
Class web.DHCMedBase01 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

/// Description：查询医生信息
/// Input：      
/// 		Code：医师工号
/// 		Name：姓名
/// 		ctLoc：科室
/// Return：     医生信息 RowID^Code^Name
ClassMethod QueryDoctor(Code, Name, Ctloc)
{
	n (Code, Name, Ctloc)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s ss="",pid=""
    zn MEDDATA
	;d getDepartmentALL^DHCMedBase()
	s pid=$p($$QueryDoctor^DHCMedBase01(Code,Name,Ctloc) ,"^",1)
	
	s tmp=""
	f  s tmp=$$fetchDoctor^DHCMedBase01(pid) q:tmp=""  d
	.s ss=ss_tmp
	
	zn CurrentNS
	q ss
}

/// 通过科室查找病房
/// Dep：科室ID
/// Create By LiYang 2008-11-1
ClassMethod QueryWardByDep(Dep)
{
	n (Dep)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	set ret = $$GetWardByDepHosp^DHCMedBase01(Dep)
	zn CurrentNS
	q ret
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
	s stdate=+$h
	s bedid="0"  
	f  s bedid=$o(^PAWARD(wardid,"BED",bedid))  q:bedid=""   d
	.s beddesc=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	.q:(bedno'="")&(bedno[beddesc)
	.s datefrom=$p(^PAWARD(wardid,"BED",bedid),"^",21)
	.s dateto=$p(^PAWARD(wardid,"BED",bedid),"^",22)
	.q:(datefrom'="")&(stdate<datefrom)
	.q:(dateto'="")&(stdate>dateto)
	.s bedrowid=wardid_"||"_bedid
	.s warddesc=$p(^PAWARD(wardid),"^",2)
	.s ret = ret _ bedrowid _ "^" _ beddesc _ $c(1)
	q ret
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

/// 取当前医院设置
/// Modified By LiYang 2009-2-11 增加返回值类型
ClassMethod GetDefaultHosp() As %String
{
   n
   q:'$d(^DHCMedHosptial(0)) ""
   s s=$g(^DHCMedHosptial(0))
   s Rowid=+s
   s sHosp=Rowid_"^"_$g(^CT("HOSP",+Rowid))
   s $p(s,"/",1)=sHosp
   q s
}

/// 取当前医院设置中的医院代码，如BeiJing_FX
/// add by liuxuefeng 2009-05-14
/// Debug:w ##class(web.DHCMedBase01).GetDefaultHospCode()
ClassMethod GetDefaultHospCode() As %String
{
	n
	s HospCode=""
   	q:'$d(^DHCMedHosptial(0)) HospCode
   	s HosptialStr=$g(^DHCMedHosptial(0))
   	s HospCode=$p(HosptialStr,"/",4)
   	q HospCode
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
	
	s rowid=0
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    .q:$p($g(^CTLOC(rowid)),"^",13)'="E"
    .s Desc=$p($g(^CTLOC(rowid)),"^",2)
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

ClassMethod admbedlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admbedlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admbedlookupExecute(ByRef qHandle As %Binary, wardid As %String, bedno As %String, sexdr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    i wardid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    If $g(ind)="" Set ind=1
	s stdate=+$h
	s bedid="0"  
	f  s bedid=$o(^PAWARD(wardid,"BED",bedid))  q:bedid=""   d
	.s beddesc=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	.q:(bedno'="")&(bedno[beddesc)
	.s datefrom=$p(^PAWARD(wardid,"BED",bedid),"^",21)
	.s dateto=$p(^PAWARD(wardid,"BED",bedid),"^",22)
	.;b
	.q:(datefrom'="")&(stdate<datefrom)
	.q:(dateto'="")&(stdate>dateto)
	.;w !,"1err"
	.;b
	.s roomid=$p(^PAWARD(wardid,"BED",bedid),"^",3)
	.q:($d(^PAROOM(roomid))=0)
	.;w !,"2err"
	.;b
	.s rmdtfrom=$p(^PAROOM(roomid),"^",8)
	.s rmdtto=$p(^PAROOM(roomid),"^",9)
	.q:(rmdtfrom'="")&(stdate<rmdtfrom)
	.q:(rmdtto'="")&(stdate>rmdtto)
	.s flag=..checkini(wardid,bedid)
	.q:flag["N"
	.s rmsexdiff=$p(^PAROOM(roomid),"^",4)
	.s bedid1=""
	.s bednum=0
	.f bedid1=$o(^PAWARD("BED_Room_DR",roomid,wardid,bedid1))  q:bedid1=""  d
	..s bedadmid=""
	..f  s bedadmid=$o(^PAWARDA(wardid,"BED",bedid1,"ADM",bedadmid))  q:bedadmid=""  d
	...s admno=$p(^PAWARDA(wardid,"BED",bedid1,"ADM",bedadmid),"^",1)
	...q:($d(^PAADM(admno))=0)
	...s admvisit=$p(^PAADM(admno),"^",20)
	...q:(admvisit'="A")
	...s papmiid=$p(^PAADM(admno),"^",1)
	...q:($d(^PAPER(papmiid))=0)
	...s admsexdr=$p(^PAPER(papmiid,"ALL"),"^",7)
	...i (admsexdr'=sexdr)&(sexdr'="")  d
	....s bednum=bednum+1
	.;w !,bednum
	.;b
	.q:(bednum>0)&(rmsexdiff="N")
	.;w !,"4err"
	.;b
	.i rmsexdiff="D"  d
	..s roomstatus="正常"
	.e  i rmsexdiff="W"  d
	..s roomstatus="警告"
	.s roomtypeid=$p(^PAROOM(roomid),"^",3)
	.;w !,roomtypeid
	.;b
	.q:(roomtypeid="")
	.q:($d(^PAC("ROOMT",roomtypeid))=0)
	.;w !,"5err"
	.;b
	.s roomtype=$p(^PAC("ROOMT",roomtypeid),"^",2)
	.s roomdesc=$p(^PAROOM(roomid),"^",2)
	.s bedtypeid=$p(^PAWARD(wardid,"BED",bedid),"^",2)
	.q:(bedtypeid="")
	.q:($d(^PAC("BEDTP",bedtypeid))=0)
	.;w !,"6err"
	.;b
	.s bedtype=$p(^PAC("BEDTP",bedtypeid),"^",2)
	.s bedrowid=wardid_"||"_bedid
	.&sql(select BED_Available into :bedavail 
	      from pac_bed where bed_rowid=:bedrowid)
	.s bedavail=$p(bedavail,$c(1))
	.q:bedavail="N"
	.i bedavail="N"  d
	..s bedstatus="使用中"
	.e  d 
	..s bedstatus="空"
	.q:(bedstatus="使用中")
	.s warddesc=$p(^PAWARD(wardid),"^",2)
	.d OutputRow5
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
    
    set Data=$lb(beddesc,warddesc,roomdesc,bedtype,bedstatus,roomtype,roomstatus,roomid,bedrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admbedlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admbedlookupExecute ]
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

ClassMethod admwardlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admwardlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-03
/// Description：查询病床Query
/// Table：      
/// Input：      wardid：病房ID、bedno：床号、sexdr：男、女病床类型
/// Output：     
Query admbedlookup(wardid As %String, bedno As %String, sexdr As %String) As %Query(ROWSPEC = "beddesc:%String,warddesc:%String,roomdesc:%String,bedtype:%String,bedstatus:%String,roomtype:%String,roomstatus:%String,roomid:%String,bedid:%String")
{
}

ClassMethod admwardlookupExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    i admdepid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    If $g(ind)="" Set ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s childid=""
	f  s childid=$o(^CTLOC(admdepid,"LINK",childid))  q:childid=""  d
	.s linkid=$p(^CTLOC(admdepid,"LINK",childid),"^",1)
	.q:($d(^CTLOC(linkid))=0)
	.s loctype=$p(^CTLOC(linkid),"^",13)
	.q:(loctype'="W")
	.s ctdesc=$p(^CTLOC(linkid),"^",2)
	.s rowid=""
	.s rowid=$o(^PAWARD(0,"WARD_LocationDR",linkid,rowid))
	.s ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.i desc'=""  d
	..i ctdesc1[desc  d
	...i $f(ctdesc,"-")'=0  d
    ....s ctdesc=$p(ctdesc,"-",2)
    ...d OutputRow1
 	.e  d
 	..i $f(ctdesc,"-")'=0  d
    ...s ctdesc=$p(ctdesc,"-",2)
    ..d OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(ctdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod checkini(ward, bed) As %String
{
	n (ward,bed)
	q:($g(ward)="")||($g(bed)="") ""
	s falg=""
	s inidate=+$h+1
	f  s inidate=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate),-1)  q:(inidate="")||(falg="N")  d
	.s initime=""
	.s:inidate=+$h initime=+$p($h,",",2)+1
	.f  s initime=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime),-1)  q:(initime="")||(falg="N")  d
	..s sub=""
	..f  s sub=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime,sub),-1)  q:(sub="")||(falg="N")  d 
	...s dateto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",5)
	...s:+dateto=0 falg="N"
	...s timeto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",6)
	...q:((+dateto<+$h)||((dateto=+$h)&&(timeto<+$P($h,",",2))))
	...s falg="N"
    q falg
}

ClassMethod admwardlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admwardlookupExecute ]
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
/// Description：查询病区Query
/// Table：      
/// Input：      admdepid：科室ID、 desc：病区描述
/// Output：     ward,wardid
Query admwardlookup() As %Query(ROWSPEC = "ward:%String,wardid:%String")
{
}

/// Creator：    刘学峰
/// CreatDate：  2008-11-09
/// Description：将科室Query处理成字符串
/// Table：      
/// Input：      desc：科室描述
/// Output：     depde_$C(1)_pid字符串,"^"分割
/// Debug:		 w ##class(web.DHCMedBase01).GetDeptStr("")
ClassMethod GetDeptStr(desc As %String) As %String
{
	;w ##class(web.DHCMainNurse).GetWardStr("W")
	s rset=##class(%ResultSet).%New("web.DHCMedBase01:admdeplookup")
	s ret=""
	;i CTType=""  s CTType="W"
	do rset.Execute(desc)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

/// 取出院时间，各家医院取的时间不一样
/// w ##Class(web.DHCMedBase01).GetDisDateTime(Paadm)
/// 日期和时间“,”分割
ClassMethod GetDisDateTime(Paadm)
{
	n (Paadm)
	s cDisDate="",cDisTime=""
	s HospCode=$p(..GetDefaultHosp(),"/",4)
	;modify by liuxuefeng 2009-07-01 取消复兴医院出院日期的个性化设置
	i HospCode="FX" d
	.s cDisDate=+$p($g(^PAADM(+Paadm)),"^",59)
	.s cDisTime=+$p($g(^PAADM(+Paadm)),"^",60)
	e  d
	.s cDisDate=+$p($g(^PAADM(+Paadm)),"^",17)
	.s cDisTime=+$p($g(^PAADM(+Paadm)),"^",18)
	q cDisDate_","_cDisTime
}

/// ///////////////////////////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////////////////////////////////
/// Creator：    刘学峰
/// CreatDate：  2009-07-21
/// Description：依次根据CTLOC_Hospital_DR、和CTLOC_Desc查询CT_Loc表项目,
/// 				然后根据CT_Loc表RowID找到PAC_Ward表中的病区RowID
/// Table：      CT_Loc、PAC_Ward
/// Input：  	 CTLOC_Hospital_DR：医院；CTLOC_Desc描述
/// Output：     CTLOC_RowID,CTLOC_Desc
/// 说明：		 PA_Adm表中，第70个字段PAADM_CurrentWard指向表PAC_Ward
/// 			 表PAC_Ward中的WARD_LocationDR指向表CT_Loc
/// 			 当CTLOC_Type="W"时，查询的为病区
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCMedBase01","QueryWard","W","","")
Query QueryWard(InLOCHospitalDR As %String, InLOCDesc As %String) As %Query(ROWSPEC = "LOCCode:%String,PACWardRowID:%String")
{
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary, InLOCHospitalDR As %String, InLOCDesc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	;^CTLOC(0,"LocType",{CTLOC_Type},{CTLOC_RowID})

	s:InLOCDesc'="" InLOCDesc=$$ALPHAUP^SSUTIL4(InLOCDesc)
	
	s LOCRowID=0
	f  s LOCRowID=$o(^CTLOC(0,"LocType","W",LOCRowID)) q:LOCRowID=""  d
	.s strLoc=$g(^CTLOC(LOCRowID))
	.s LOCHospitalDR=$p(strLoc,"^",22) 				;医院指向
	.;w !,"LOCHospitalDR="_LOCHospitalDR
	.q:(InLOCHospitalDR'="")&&(InLOCHospitalDR'=LOCHospitalDR)
	.s LOCCode=$p(strLoc,"^",1) 					
	.s LOCDesc=$p(strLoc,"^",2) 					
	.s LOCDesc=$$ALPHAUP^SSUTIL4(LOCDesc)
	.;w !,"LOCDesc="_LOCDesc
	.q:(InLOCDesc'="")&&(LOCDesc'[InLOCDesc)
	.s PACWardRowID=$o(^PAWARD(0,"WARD_LocationDR",LOCRowID,0))
	.;^PAWARD(0,"WARD_LocationDR",{WARD_LocationDR},{WARD_RowID}) 
	.d BuildRow
	.s ind=ind+1
	Quit $$$OK
BuildRow
    set Data=$lb(LOCCode,PACWardRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	quit
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
