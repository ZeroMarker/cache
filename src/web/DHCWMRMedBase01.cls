Import SQLUser

/// Creator:	 吴群科
/// Description: 公共函数
/// Updater:     刘学峰
/// UpdateDate： 2008-11-03
Class web.DHCWMRMedBase01 Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 69;

/// Description：查询医生信息
/// Input：      
/// 		Code：医师工号
/// 		Name：姓名
/// 		ctLoc：科室
/// Return：     医生信息 RowID^Code^Name
ClassMethod QueryDoctor(Code, Name, Ctloc)
{
	n (Code, Name, Ctloc)
	
    s ss="",pid=""
	;d getDepartmentALL^DHCWMRMedBase()
	s pid=$p(..QueryDoctorX(Code,Name,Ctloc) ,"^",1)
	
	s tmp=""
	f  s tmp=..fetchDoctor(pid) q:tmp=""  d
	.s ss=ss_tmp
	q ss
}

// 查询医师信息

// Code：工号

// Name：姓名

// Ctloc：科室

ClassMethod QueryDoctorX(Code, Name, Ctloc)
{
    n (Code,Name,Ctloc)
    k ^CacheTemp($zn,$j)
    ;w !,Code_"   -   "_Name_"   -   "_Ctloc
    s Code=$$ALPHAUP^SSUTIL4(Code)
    s Name=$$ALPHAUP^SSUTIL4(Name)
    s iCount=0
    i Code'="" d
    .s iCount=..GetDocByCode(Code,Name,Ctloc)
    e  d
    .s:Name'="" iCount=..GetDocByName(Name,Ctloc)
    s iIndex=""
    q $j_"^"_iCount
}

/// 通过科室查找病房
/// Dep：科室ID
/// Create By LiYang 2008-11-1
ClassMethod QueryWardByDep(Dep)
{
	n (Dep)
	set ret =..GetWardByDepHosp(Dep)
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
/// Debug:w ##class(web.DHCWMRMedBase01).GetDefaultHospCode()
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
/// Debug:		 w ##class(web.DHCWMRMedBase01).GetDeptStr("")
ClassMethod GetDeptStr(desc As %String) As %String
{
	;w ##class(web.DHCMainNurse).GetWardStr("W")
	s rset=##class(%ResultSet).%New("web.DHCWMRMedBase01:admdeplookup")
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
/// w ##Class(web.DHCWMRMedBase01).GetDisDateTime(Paadm)
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
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCWMRMedBase01","QueryWard","W","","")
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

// 获取系统日期

ClassMethod GetSysDate()
{
       
    s sysdate=$p($h,",",1)
    s sysdate=$zd(sysdate,3)
    s P0=sysdate
    q P0
}

// 获取系统时间

ClassMethod GetSysTime()
{
     
    s systime=$p($h,",",2)
    s P0=$zt(systime)
    q P0
}

// 获取医院名称                    

ClassMethod GetHospital()
{
    ;^CT("HOSP",{HOSP_RowId})
    s id="0",s=""
    f  s id=$o(^CT("HOSP",id)) q:id=""  d
    .s tmp=id_"^"_$g(^CT("HOSP",+id))
    .s s=s_tmp_$c(1)
    q s
}

// 设置医院信息

ClassMethod SetDefaultHosp(Instring)
{
    n (Instring)
    s ^DHCMedHosptial(0)=Instring
    q 0
}

ClassMethod GetWardByDep(cDep)
{
    ;By RBC_DepartmentGroup
    n (cDep)
    s s=""
    q:'$d(^CTLOC(0,"DepGrp",+cDep)) s
    s ctloc="" f  s ctloc=$o(^CTLOC(0,"DepGrp",+cDep,ctloc)) q:ctloc=""  d
    .q:'$d(^PAWARD(0,"WARD_LocationDR",+ctloc))
    .s WARDID="" f  s WARDID=$o(^PAWARD(0,"WARD_LocationDR",+ctloc,WARDID)) q:WARDID=""  d
    ..q:$p($g(^PAWARD(+WARDID)),"^",6)'="Y"
    ..s WardDesc=$p($g(^PAWARD(+WARDID)),"^",2)
    ..s TMP=+WARDID_"^"_WardDesc
    ..s s=s_TMP_$c(1)
    q s
}

ClassMethod CheckWard(cDep, cWard, Ward)
{
    n (cDep,cWard,Ward)
    s flag="0"
    q:cDep="" "1"
    i cWard="" d
    .s ctloc=$p($g(^PAWARD(+Ward)),"^",5)
    .s dep=$p($g(^CTLOC(+ctloc)),"^",19)
    .s:cDep=dep flag="1"
    e  d
    .s:cWard=Ward flag="1"    
    q flag
}

ClassMethod CheckIfCtloc(regno, arglocID, Ctloc)
{
     k P6                 ;GetPatInfo(regno,paadmID)
     s regno=$$ALPHAUP^SSUTIL4(regno)
     ;Add by wuqk 2008-04-25
     s regno=..RegNoCon(regno)
     s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
     s PAPMIRowId= $o(^PAPERi("PAPMI_PatNo",regno,-1)) 
     s PAPMIRowId=+PAPMIRowId
     s paadmIDI=$o(^PAPERdr(PAPMIRowId,"ADM","I",-1))
     s paadmIDO=$o(^PAPERdr(PAPMIRowId,"ADM","O",-1))
     s:paadmIDI>paadmIDO paadmID=paadmIDI
     s:paadmIDI<paadmIDO paadmID=paadmIDO         
     q:paadmID="" 1
         
     s sCtloc=+$p(^PAADM(paadmID),"^",4)
     s ctlocDesc=$p(^CTLOC(sCtloc),"^",2)
     i $g(ctlocDesc)["-" s ctlocDesc=$p(ctlocDesc,"-",2)
     s P6=ctlocDesc
     q:Ctloc'=sCtloc 2
         
     //update by zf 2008-07-31 更新程序时发现不县替换原来文件的内嬍
     //s curdepdr=+$P(^CTLOC(sCtloc),"^",19)
     //s curdepdrdesc=$p(^RBC("DEP",+curdepdr),"^",2)
     //s P6=curdepdrdesc
     //by wuqk 2008-1-25  判断科室的时候根据医院设置取科室
     s sdep=..getDepByHospLoc(sCtloc)
     s curdepdr=+sdep
     s curdepdrdesc=$p(sdep,"/",2)
     s P6=curdepdrdesc 
         
     q:curdepdr'=arglocID 1
     k P6
     q 0
}

ClassMethod GetDocByCode(Code, Name, Ctloc)
{
   n (Code,Name,Ctloc)
   s iCount=1
   s Rowid=..GetDocByCodeLoop(Code)
   s flag=..CheckDoctor(Rowid,Code,Name,Ctloc)
   i flag=1 d
   .;s ^CacheTemp($zn,$j,iCount)=Rowid
   .s ^CacheTemp($zn,$j,Rowid)=""
   .s iCount=iCount+1
   s tmpCode=""
   f  s tmpCode=$o(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode)) q:(tmpCode="")  d
   .;!(tmpCode'[Code)
   .q:tmpCode'[Code
   .;w !,tmpCode
   .s Rowid=..GetDocByCodeLoop(tmpCode)
   .s flag=..CheckDoctor(Rowid,"",Name,Ctloc)
   .i flag=1 d
   ..;s ^CacheTemp($zn,$j,iCount)=Rowid  by wuqk 20080529 重复取数
   ..s ^CacheTemp($zn,$j,Rowid)=""
   ..s iCount=iCount+1
   q iCount-1
}

ClassMethod GetDocByCodeLoop(Code)
{
   n (Code)
   ;^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}),{SSUSR_RowId}) 
   s Rowid=""
   q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",Code)) Rowid
   s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",Code,Rowid))
   q Rowid
}

// 通过医师姓名，科室查询医师

ClassMethod GetDocByName(Name, Ctloc)
{
   n (Name,Ctloc)
   s iCount=1
   s Rowid=..GetDocByNameLoop(Name)
   s flag=..CheckDoctor(Rowid,"",Name,Ctloc)
   i flag=1 d
   .;s ^CacheTemp($zn,$j,iCount)=Rowid
   .s ^CacheTemp($zn,$j,Rowid)=""
   .s iCount=iCount+1
   ;w !,"------2-----",!
   s tmpName=Name
   f  s tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName)) q:(tmpName="")!(tmpName'[Name)  d
   .;w !,tmpName
   .s Rowid=..GetDocByNameLoop(tmpName)
   .s flag=..CheckDoctor(Rowid,"","",Ctloc)
   .;w "flag="_flag
   .i flag=1 d
   ..;s ^CacheTemp($zn,$j,iCount)=Rowid  by wuqk 20080529 重复取数
   ..s ^CacheTemp($zn,$j,Rowid)=""
   ..s iCount=iCount+1
   q iCount-1
}

ClassMethod GetDocByNameLoop(Name)
{
   n (Name)
   ;^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP({SSUSR_Name}),{SSUSR_RowId}) 
   s Rowid=""
   q:'$d(^SSU("SSUSR",0,"SSUSR_Name",Name)) Rowid
   s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",Name,Rowid))
   q Rowid
}

ClassMethod CheckDoctor(ssusr, Code, Name, Ctloc)
{
    n (ssusr,Code,Name,Ctloc)
    ;q 1
    s flag=""
    q:ssusr="" flag
    q:'$d(^SSU("SSUSR",+ssusr)) flag
    s usrCode=$p($g(^SSU("SSUSR",+ssusr)),"^",1)
    s usrName=$p($g(^SSU("SSUSR",+ssusr)),"^",2)
    s usrCtloc=$p($g(^SSU("SSUSR",+ssusr)),"^",4)
    s usrCareProvDR=$p($g(^SSU("SSUSR",+ssusr)),"^",14)
    q:usrCareProvDR="" flag
    ;w !,Code_Name_Ctloc_"/"_usrCode_usrName_usrCtloc_usrCareProvDR
    q:(Code'="")&(usrCode'[Code) flag
    q:(Name'="")&(usrName'[Name) flag
    q:(Ctloc'="")&(usrCtloc'[Ctloc) flag
    ;w !,"----"_usrCareProvDR
    s flag=1
    q flag
}

ClassMethod fetchDoctor(JIndex)
{
    q:'$d(^CacheTemp($zn,JIndex)) ""
    s s=""
    s i=0
    s tmpcode=iIndex
    f  s tmpcode=$o(^CacheTemp($zn,JIndex,tmpcode)) q:(tmpcode="")!(i=100)  d
    .;s ssusr=$g(^CacheTemp($zn,JIndex,tmpcode))
    .s ssusr=+$g(tmpcode)
    .s iIndex=tmpcode
    .s tmp=..GetUser(ssusr)
    .s s=s_tmp_$c(1)
    .s i=i+1
    i tmpcode="" k ^CacheTemp($zn,JIndex)
    q s
}

ClassMethod GetUser(ssusr)
{
   n (ssusr)   
   s usrCode=$p($g(^SSU("SSUSR",+ssusr)),"^",1)
   s usrName=$p($g(^SSU("SSUSR",+ssusr)),"^",2)
   s usrCtloc=$p($g(^SSU("SSUSR",+ssusr)),"^",4)
   s sCTLOC=##Class(web.DHCWMRMedBase).GetCtlocStr(usrCtloc)
   s s=ssusr_"^"_usrCode_"^"_usrName_"^"_sCTLOC
   q s
}

// ---------Add by wuqk 2007-05-23 for DHCMedInfection of Anzhen

// By CT_Loc

// pac_wardbedallocation

ClassMethod GetWardByLoc(cLoc)
{
    ;n (cLoc)
    s s=""
    
    ;add by zf 2008-11-17  通过科室找病区
    s HospCode=..GetHospitalCode()
    //add  by wuqk 2009-06-22 
    i (HospCode="BeiJing_DT")||(HospCode="Shanghai_HS") d
    .;^CTLOC({CT_Loc.CTLOC_RowID},"LINK",{LINK_Childsub})
    .q:'$d(^CTLOC(+cLoc))
    .s ChildSub=0
    .f  s ChildSub=$o(^CTLOC(+cLoc,"LINK",ChildSub)) q:ChildSub=""  d
    ..s cLocRowid=+$g(^CTLOC(+cLoc,"LINK",ChildSub))
    ..q:cLocRowid=0
    ..q:'$d(^CTLOC(+cLocRowid))
    ..;^PAWARD(0,"WARD_LocationDR",{WARD_LocationDR},{WARD_RowID})
    ..q:'$d(^PAWARD(0,"WARD_LocationDR",+cLocRowid))
    ..s WARDID=0
    ..f  s WARDID=$o(^PAWARD(0,"WARD_LocationDR",+cLocRowid,WARDID)) q:WARDID=""  d
    ...q:$p($g(^PAWARD(+WARDID)),"^",6)'="Y"
    ...s WardDesc=$p($g(^PAWARD(+WARDID)),"^",2)
    ...s TMP=+WARDID_"^"_WardDesc
    ...s s=s_TMP_$c(1)
    e  d
    .;^PAWARD(0,"WBALL",{WBALL_CTLOC_DR},{PAC_Ward.WARD_RowID},{WBALL_Date},{WBALL_Childsub})
    .q:'$d(^PAWARD(0,"WBALL",+cLoc))
    .s WARDID="" f  s WARDID=$o(^PAWARD(0,"WBALL",+cLoc,WARDID)) q:WARDID=""  d
    ..q:$p($g(^PAWARD(+WARDID)),"^",6)'="Y"
    ..s WardDesc=$p($g(^PAWARD(+WARDID)),"^",2)
    ..s TMP=+WARDID_"^"_WardDesc
    ..s s=s_TMP_$c(1)
   
    q s
}

/*****************************
   ;根据部门组模式取病区
   ;LocMode=0  Dep/Loc/Ward
   ;LocMode=1  Loc/Loc/Ward  ;安贞医院未启用部门组?所以按照ctloc查找病区
   ******************************/
ClassMethod GetWardByDepHosp(cDep)
{
   n (cDep)
   s defHosp=..GetDefaultHosp()
   s LocMode=+$p(defHosp,"/",2)
   s:LocMode=0 ret=..GetWardByDep(cDep)
   s:LocMode=1 ret=..GetWardByLoc(cDep)
   /*
   i defHosp["安贞" d            ;
   .s ret=$$GetWardByLoc(cDep)
   e  d
   .s ret=$$GetWardByDep(cDep)
   */
   q ret
}

/*****************************
   ;取全部部门组
   ;LocMode=0  Dep/Loc/Ward
   ;LocMode=1  Loc/Loc/Ward     ;安贞医院未启用部门组?所以查找ctloc
   ******************************/
ClassMethod GetDepByHosp()
{
   k PLIST
   s defHosp=..GetDefaultHosp()
   s LocMode=+$p(defHosp,"/",2)
   s:LocMode=0 ret=##Class(web.DHCWMRMedBase).getDepartmentALL()
   s:LocMode=1 ret=..getCtlocALL()
   /*
   i defHosp["安贞" d            ;
   .s ret=$$getCtlocALL()
   e  d
   .s ret=$$getDepartmentALL^DHCWMRMedBase()
   */
   q ret
   ;取所有ctloc?执行科室?
}

ClassMethod getCtlocALL()
{
   k PLIST 
   s i=0
   s ctloc=0 f  s ctloc=$o(^CTLOC(ctloc)) q:ctloc=""  d
   .q:$p($g(^CTLOC(ctloc)),"^",13)'="E"
   .s Desc=$p($g(^CTLOC(ctloc)),"^",2)
   .s i=i+1
   .s PLIST(i)=+ctloc_$c(2)_Desc
   s P1=i
   q 0
}

/*****************************
   ;根据Loc取部门组
   ;LocMode=0  Dep/Loc/Ward
   ;LocMode=1  Loc/Loc/Ward    ;安贞医院未启用部门组?所以查找ctloc
   ******************************/
ClassMethod getDepByHospLoc(Loc)
{
    k PLIST 
    s defHosp=..GetDefaultHosp()
    s LocMode=+$p(defHosp,"/",2)
    i LocMode=0 d ##Class(web.DHCWMRMedBase).getDepartment(Loc)
    i LocMode=1 d ..getCtLoc(Loc)
    /*
    i defHosp["安贞" d
    .d getCtLoc(Loc)
    e  d
    .d getDepartment^DHCWMRMedBase(Loc)
    */
    q P1
}

// 根据ctloc取出id?名称

ClassMethod getCtLoc(Loc)
{
    k PLIST 
    s locdesc=$p(^CTLOC(+Loc),"^",2)
    s PLIST(1)=Loc_$c(2)_locdesc
    ;s P1=PLIST(1)              ;by wuqk 2008-1-25
    s P1=1              ;by wuqk 2008-6-25
    q P1
}

/*****************************
   ;根据部门组取Loc列表
   ;LocMode=0  Dep/Loc/Ward
   ;LocMode=1  Loc/Loc/Ward   ;安贞医院未启用部门组?所以根据Loc查找Loc列表
   ******************************/
ClassMethod getLocList(dep)
{
    k PLIST
    s defHosp=..GetDefaultHosp()
    s LocMode=+$p(defHosp,"/",2)
    i LocMode=0 d ##Class(web.DHCWMRMedBase).GetgroupLocDesc2(dep)
    i LocMode=1 d ..getCtLoc(dep)
    /*
    i defHosp["安贞" d
    .d getCtLoc(Loc)
    e  d
    .d GetgroupLocDesc2^DHCWMRMedBase(Loc)
    */
    q P1
    
   ;----------------------------------------------End.
}

ClassMethod UpdateIPMrNo(MrNo, papmi)
{
  ;更新住院病案卍
  n (MrNo,papmi)
  &sql(update pa_person set paper_governcardno=:MrNo where paper_rowid=:papmi)
  q SQLCODE
}

ClassMethod UpdateMrNoA(MrNo, papmi)
{
    ;pa_person.paper_governcardno
   n (MrNo,papmi)
   &sql(update pa_person set paper_governcardno=:MrNo where paper_rowid=:papmi)
   q SQLCODE
}

ClassMethod UpdateMrNoB(MrNo, papmi)
{
    ;PA_PatMas.PAPMI_Medicare
   n (MrNo,papmi)
   &sql(update PA_PatMas set PAPMI_Medicare=:MrNo where PAPMI_RowId=:papmi)
   q SQLCODE
}

// 保存医疗垃圾管理系统的设置

// Create By LiYang 2008-11-16

ClassMethod SaveRubSysSetting(Setting)
{
	n (Setting)
	s tmp = "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	set intCounter = 0
	for intCounter=1:1:$l(Setting,"^")
	{
		set $p(tmp, "^", intCounter) = $p(Setting, "^", intCounter)
	}
	set ^DHCMedHosptial("DHCRub") = tmp
	quit 1
}

// 获取医疗垃圾管理系统的设置

// Create By LiYang 2008-11-16

ClassMethod GetRubSysSetting()
{
	quit $g(^DHCMedHosptial("DHCRub"))
}

ClassMethod GetgroupLocDesc2(CTLOCDepDR)
{
      k PLIST
      ;^CTLOC(0,"DepGrp",{CTLOC_Dep_DR},{CTLOC_RowID})
      q:'$d(^CTLOC(0,"DepGrp",CTLOCDepDR)) 0
      s num=0
      s tmpid=""  f  s tmpid=$o(^CTLOC(0,"DepGrp",CTLOCDepDR,tmpid)) q:tmpid=""  d
      .s locdesc=$p($g(^CTLOC(+tmpid)),"^",2)
      .s num=num+1
      .s MLIST(num)=+tmpid_$c(2)_locdesc      
      m PLIST=MLIST
      k MLIST
      s P1=num 
      q num
}

// 格式化登记号，格式化成8位或者10位

ClassMethod RegNoCon(PAPMINo)
{
    n (PAPMINo)
    q:PAPMINo="" PAPMINo
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	if $l(PAPMINo)<len d
	.s prelen=len-$l(PAPMINo)
	.for i=1:1:prelen s PAPMINo="0"_PAPMINo
	Q PAPMINo
}

// 获取医院代码

ClassMethod GetHospitalCode()
{
    n
    ;^DHCMedHosptial(0)=1/0/0/BeiJing_ZYY/Zebra
    s tmp=$g(^DHCMedHosptial(0))
    s ret=$p(tmp,"/",4)
    q ret
}

}
