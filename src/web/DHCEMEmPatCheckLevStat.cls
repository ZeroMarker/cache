/// Creator:qqa
/// Create date:2017-07-17
Class web.DHCEMEmPatCheckLevStat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 统计医生出诊工作量，一个下午或一个上午算半天
/// / d ##class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QueryGetDoctorCZ","2015-09-15","2015-09-15","")	
Query QueryGetDoctorCZ(SDate As %String, EDate As %String, ordDepId As %String = "") As %Query(ROWSPEC = "Name:%String,num:%String,Locdesc:%String") [ SqlProc ]
{
}

ClassMethod QueryGetDoctorCZExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, ordDepId As %String = "") As %Status
{
	;n (qHandle,SDate,EDate,ICDList)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" ) Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
 	k ^TEMPDHCWLCSH($j)

   	f day=SDate:1:EDate d
   	.s ParRef=0   f  s ParRef=$O(^RBAS(ParRef))  q:ParRef=""  d
   	..s SessStartTime=0   f  s SessStartTime=$O(^RBAS(ParRef,0,"DateSTime",day,SessStartTime))  q:SessStartTime=""  d
   	...s ChildSub=0   f  s ChildSub=$O(^RBAS(ParRef,0,"DateSTime",day,SessStartTime,ChildSub))  q:ChildSub=""  d
   	....;b ;
   	....s Resdr=$P(^RBAS(ParRef,ChildSub,"DHC"),"^",1)  
   	....s rangedr=$P(^RBAS(ParRef,ChildSub,"DHC"),"^",17)  //出诊时段
    ....s ^TEMPDHCWLCSH($j,"GetDoctorCZ",Resdr,"Qty")=$g(^TEMPDHCWLCSH($j,"GetDoctorCZ",Resdr,"Qty"))+1
   
    s rowid=0 f  s rowid=$O(^TEMPDHCWLCSH($j,"GetDoctorCZ",rowid))  q:rowid=""  d
    .s Name=$P(^RB("RES",rowid),"^",17)   ///医生名字
    .s ctlocdr=$P(^RB("RES",rowid),"^",1)   
    .s Locdesc=$P($P(^CTLOC(ctlocdr),"^",2),"-",2)  ///科室名称
    .s num=^TEMPDHCWLCSH($j,"GetDoctorCZ",rowid,"Qty")
    .s num=num*0.5
    .do QueryGetDoctorCZInformation
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
    
QueryGetDoctorCZInformation
	s Data=$lb(Name,num,Locdesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGetDoctorCZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetDoctorCZExecute ]
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

ClassMethod QueryGetDoctorCZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetDoctorCZExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 分诊红区各种来院途径人数以及病人明细
/// / d ##class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide","2017-03-14","2017-04-24")	
Query QueryEmPatCheckGuide(SDate As %String, EDate As %String) As %Query(ROWSPEC = "chekLev:%String,way:%String,name:%String,patNo:%String,cardNo:%String,patSex:%String,patAge:%String,date:%String,time:%String,symptom:%String") [ SqlProc ]
{
}

ClassMethod QueryEmPatCheckGuideExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	n (qHandle,SDate,EDate)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" ) Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
	k ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide")
	
	f Date=SDate:1:EDate  d
	.s PclDr = "" 
	.f  s PclDr = $o(^DHCEMPCL(0,"CreateDate",Date,PclDr)) q:PclDr=""  d
	..q:'$d(^DHCEMPCL(PclDr))
	..s NurCheckLev = $p(^DHCEMPCL(PclDr),"^",7)
	..q:(NurCheckLev'=1)&(NurCheckLev'=2)            //红区
	..s NurCheckLev=NurCheckLev_"级"
	..s PCLSouDr = $p(^DHCEMPCL(PclDr),"^",15)
	..s:PCLSouDr="" PCLSouDesc="未知"
	..s:PCLSouDr'="" PCLSouDesc = $p(^DHCEMPSO(PCLSouDr),"^",2)
	..s PatDr = $p(^DHCEMPCL(PclDr),"^",1)
	..q:'$d(^PAPER(PatDr))            ///QQA 2017-08-22 过滤错误数据
	..s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr)
	..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PclDr)   ;$p(pclData,"^",4 )
	..s PatName = $p(PatInfo,"^",2)
	..s PatNo = $p(PatInfo,"^",1)
	..s CardNo = $p(PatInfo,"^",12)
	..s PatSex = $p(PatInfo,"^",3)
	..s PatAge = $p(PatInfo,"^",4)
	..;s Symptom=$p(^DHCEMPCL(PclDr),"^",25)        //症状   
    ..s Symptom=$p(pclData,"^",4 ) ;##Class(web.DHCEMECheck).GetSymDesc(PclDr) ;##class(web.DHCEMRegister).TrNumto(Symptom,"")
    ..;s Symptom=$tr(Symptom,"!","")
    ..;s Symptom=$tr(Symptom,"#",",")
    ..s PclDate = $p(^DHCEMPCL(PclDr),"^",4)
    ..s PclDate = $zd(PclDate,3)
    ..s PclTime = $p(^DHCEMPCL(PclDr),"^",5)
    ..s PclTime = $zt(PclTime)
	..i $d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc)) d
	...s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc,""),-1)+1
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc,Num)=$lb(NurCheckLev,PCLSouDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
	..i '$d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc)) d
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc,1)=$lb(NurCheckLev,PCLSouDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
    
    do QueryEmPatCheckGuideInformation
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
    
QueryEmPatCheckGuideInformation
	s PCLSouDesc=""
	f  s PCLSouDesc = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc)) q:PCLSouDesc=""  d
	.s Num=""
	.f  s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc,Num)) q:Num=""  d
	..s Data=^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc,Num)
    ..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	.s PCLSouNum = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide",PCLSouDesc,""),-1)
 	.s ^CacheTemp(repid,ind)=$lb("",PCLSouDesc,"","","","","","","","共"_PCLSouNum_"人")
 	.s ind=ind+1
	q
}

ClassMethod QueryEmPatCheckGuideFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmPatCheckGuideExecute ]
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

ClassMethod QueryEmPatCheckGuideClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmPatCheckGuideExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckGuide")
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc","2017-03-14","2017-04-24")	
Query QueryEmPatCheckLoc(SDate As %String, EDate As %String, LocDesc As %String, HOSPID As %String) As %Query(ROWSPEC = "NurCheckLev:%String,checkLocDesc:%String,name:%String,patNo:%String,cardNo:%String,patSex:%String,patAge:%String,date:%String,time:%String,symptom:%String") [ SqlProc ]
{
}

ClassMethod QueryEmPatCheckLocExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, LocDesc As %String, HOSPID As %String) As %Status
{
	n (qHandle,SDate,EDate,LocDesc,HOSPID)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" ) Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
	k ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc")
	
	f Date=SDate:1:EDate  d
	.s PclDr = "" 
	.f  s PclDr = $o(^DHCEMPCL(0,"CreateDate",Date,PclDr)) q:PclDr=""  d
	..q:'$d(^DHCEMPCL(PclDr))
	..s PatLocID=$p(^DHCEMPCL(PclDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
	..s NurCheckLev = $p(^DHCEMPCL(PclDr),"^",7)
	..s NurCheckLev=NurCheckLev_"级"
	..s NurCheckLev=##class(web.DHCEMCommonUtil).LevFormat(NurCheckLev) //hxy 2020-02-27
	..s PCLSouDr = $p(^DHCEMPCL(PclDr),"^",15)
	..s LocDr = ""
	..;s PCLLocDr = $p(^DHCEMPCL(PclDr),"^",10)
	..s PCLLocDr=""
	..s PCLPCCDr = $o(^DHCEMPCC(0,"PatCheckLev",PclDr,""),-1)
	..s:PCLPCCDr'="" PCLLocDr = $p(^DHCEMPCC(PCLPCCDr),"^",3)
	..s PCLToLocDr = $p(^DHCEMPCL(PclDr),"^",41)
	..s:+PCLLocDr'=0 LocDr=PCLLocDr
	..s:+PCLToLocDr'=0 LocDr=PCLToLocDr
	..q:+LocDr=0
	..s PCLLocDesc = $p(^CTLOC(LocDr),"^",2)
	..s:+PCLLocDr=0 PCLLocDesc="(转)"_PCLLocDesc
	..q:(LocDesc'="")&(LocDesc'=PCLLocDesc)
	..s PatDr = $p(^DHCEMPCL(PclDr),"^",1)
	..q:'$d(^PAPER(PatDr))            ///QQA 2017-08-22 过滤错误数据
	..s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr,HOSPID) //hxy 2020-06-11 HOSPID
	..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PclDr)   ;$p(pclData,"^",4 )
	..s PatName = $p(PatInfo,"^",2)
	..s PatNo = $p(PatInfo,"^",1)
	..s CardNo = $p(PatInfo,"^",12)
	..s PatSex = $p(PatInfo,"^",3)
	..s PatAge = $p(PatInfo,"^",4)
	..s Symptom=$p(pclData,"^",4 ) ;##Class(web.DHCEMECheck).GetSymDesc(PclDr) ;$p(^DHCEMPCL(PclDr),"^",25)        //症状   
    ..s PclDate = $p(^DHCEMPCL(PclDr),"^",4)
    ..s PclDate = $zd(PclDate,3)
    ..s PclTime = $p(^DHCEMPCL(PclDr),"^",5)
    ..s PclTime = $zt(PclTime)	

	..i $d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc)) d
	...s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc,""),-1)+1
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc,Num)=$lb(NurCheckLev,PCLLocDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
	..i '$d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc)) d
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc,1)=$lb(NurCheckLev,PCLLocDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
    do QueryEmPatCheckLocInformation
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
    
QueryEmPatCheckLocInformation
	s PCLLocDesc=""
	f  s PCLLocDesc = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc)) q:PCLLocDesc=""  d
	.s Num=""
	.f  s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc,Num)) q:Num=""  d
	..s Data=^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc",PCLLocDesc,Num)
    ..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	q
}

ClassMethod QueryEmPatCheckLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmPatCheckLocExecute ]
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

ClassMethod QueryEmPatCheckLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmPatCheckLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryEmPatCheckLoc")
 	Quit $$$OK
}

/// 分诊红区各种来院途径人数以及病人带明细
/// / d ##class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QueryPclGuide","2017-03-14","2017-04-24")	
Query QueryPclGuide(SDate As %String, EDate As %String, HOSPID As %String) As %Query(ROWSPEC = "way:%String,num:%String") [ SqlProc ]
{
}

ClassMethod QueryPclGuideExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, HOSPID As %String) As %Status
{
	n (qHandle,SDate,EDate,HOSPID)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" ) Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
	k ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide")
	
		
	f Date=SDate:1:EDate  d
	.s PclDr = "" 
	.f  s PclDr = $o(^DHCEMPCL(0,"CreateDate",Date,PclDr)) q:PclDr=""  d
	..q:'$d(^DHCEMPCL(PclDr))
	..s NurCheckLev = $p(^DHCEMPCL(PclDr),"^",7)
	..q:(NurCheckLev'=1) //hxy 2020-02-25&(NurCheckLev'=2)            //红区
	..s PatLocID=$p(^DHCEMPCL(PclDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
	..s PCLSouDr = $p(^DHCEMPCL(PclDr),"^",16)
	..s:PCLSouDr="" PCLSouDesc="未知"
	..s:PCLSouDr'="" PCLSouDesc = $p(^DHCEMPADW(PCLSouDr),"^",2)
	..i $d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide",PCLSouDesc)) d
	...s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide",PCLSouDesc,""),-1)+1
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide",PCLSouDesc,Num)=$lb(NurCheckLev,PCLSouDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
	..i '$d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide",PCLSouDesc)) d
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide",PCLSouDesc,1)=$lb(NurCheckLev,PCLSouDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
    do QueryEmPatCheckGuide999
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
QueryEmPatCheckGuide999
	s PCLSouDesc=""
	f  s PCLSouDesc = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide",PCLSouDesc)) q:PCLSouDesc=""  d
	.s Num=""
	.s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide",PCLSouDesc,Num),-1)
	.s Data = $lb(PCLSouDesc,Num)
    .s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	q
}

ClassMethod QueryPclGuideFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPclGuideExecute ]
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

ClassMethod QueryPclGuideClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPclGuideExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclGuide")
 	Quit $$$OK
}

/// 分诊红区各种来院途径人数以及病人明细
/// / d ##class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QueryPclPatInfo","2018-09-06","2018-09-06","未知")	
Query QueryPclPatInfo(SDate As %String, EDate As %String, Guide As %String, HOSPID As %String) As %Query(ROWSPEC = "chekLev:%String,way:%String,name:%String,patNo:%String,cardNo:%String,patSex:%String,patAge:%String,date:%String,time:%String,symptom:%String") [ SqlProc ]
{
}

ClassMethod QueryPclPatInfoExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, Guide As %String, HOSPID As %String) As %Status
{
	n (qHandle,SDate,EDate,Guide,HOSPID)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" ) Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
	k ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo")
	
	f Date=SDate:1:EDate  d
	.s PclDr = "" 
	
	.f  s PclDr = $o(^DHCEMPCL(0,"CreateDate",Date,PclDr)) q:PclDr=""  d
	..q:'$d(^DHCEMPCL(PclDr))
	..s NurCheckLev = $p(^DHCEMPCL(PclDr),"^",7)
	..q:(NurCheckLev'=1) //hxy 2020-02-25&(NurCheckLev'=2)            //红区
	..s NurCheckLev=NurCheckLev_"级"
	..s NurCheckLev=##class(web.DHCEMCommonUtil).LevFormat(NurCheckLev) //hxy 2020-02-25
	..s PCLSouDr = $p(^DHCEMPCL(PclDr),"^",16)
	..s:PCLSouDr="" PCLSouDesc="未知"
	..s:PCLSouDr'="" PCLSouDesc = $p(^DHCEMPADW(PCLSouDr),"^",2)
	..b ;2
	..q:(Guide'="")&(PCLSouDesc'=Guide)
	..s PatDr = $p(^DHCEMPCL(PclDr),"^",1)
	..q:'$d(^PAPER(PatDr))            ///QQA 2017-08-22 过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PclDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
	..s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr,HOSPID) //hxy 2020-06-11
	..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PclDr)   ;
	..s PatName = $p(PatInfo,"^",2)
	..s PatNo = $p(PatInfo,"^",1)
	..s CardNo = $p(PatInfo,"^",12)
	..s PatSex = $p(PatInfo,"^",3)
	..s PatAge = $p(PatInfo,"^",4)
	..;s Symptom=$p(^DHCEMPCL(PclDr),"^",25)        //症状   
    ..s Symptom=$p(pclData,"^",4 ) ;##Class(web.DHCEMECheck).GetSymDesc(PclDr) ;##class(web.DHCEMRegister).TrNumto(Symptom,"")
    ..;s Symptom=$tr(Symptom,"!","")
    ..;s Symptom=$tr(Symptom,"#",",")
    ..s PclDate = $p(^DHCEMPCL(PclDr),"^",4)
    ..s PclDate = $zd(PclDate,3)
    ..s PclTime = $p(^DHCEMPCL(PclDr),"^",5)
    ..s PclTime = $zt(PclTime)
    ..b ;11 
	..i $d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc)) d
	...b ;12
	...s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc,""),-1)+1
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc,Num)=$lb(NurCheckLev,PCLSouDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
	..i '$d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc)) d
	...b ;23
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc,1)=$lb(NurCheckLev,PCLSouDesc,PatName,PatNo,CardNo,PatSex,PatAge,PclDate,PclTime,Symptom)
    b ;data
    do QueryEmPatInfo
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
    
QueryEmPatInfo
	s PCLSouDesc=""
	f  s PCLSouDesc = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc)) q:PCLSouDesc=""  d
	.s Num=""
	.f  s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc,Num)) q:Num=""  d
	..s Data=^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc,Num)
    ..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	.s PCLSouNum = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo",PCLSouDesc,""),-1)
 	.s ind=ind+1
	q
}

ClassMethod QueryPclPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPclPatInfoExecute ]
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

ClassMethod QueryPclPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPclPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclPatInfo")
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QueryPclLoc","2017-03-14","2017-04-24")	
Query QueryPclLoc(SDate As %String, EDate As %String, HOSPID As %String) As %Query(ROWSPEC = "checkLocDesc:%String,num:%String") [ SqlProc ]
{
}

ClassMethod QueryPclLocExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, HOSPID As %String) As %Status
{
	n (qHandle,SDate,EDate,HOSPID)
	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" ) Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
	k ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc")
	f Date=SDate:1:EDate  d
	.s PclDr = "" 
	.f  s PclDr = $o(^DHCEMPCL(0,"CreateDate",Date,PclDr)) q:PclDr=""  d
	..q:'$d(^DHCEMPCL(PclDr))
	..s PAPMIDr=$p(^DHCEMPCL(PclDr),"^",1) //hxy 2022-10-20 st
	..Q:$d(^PAPER(PAPMIDr))=0 //ed
	..s PatLocID=$p(^DHCEMPCL(PclDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
	..s LocDr = ""
	..;s PCLLocDr = $p(^DHCEMPCL(PclDr),"^",10)
	..s PCLLocDr=""
	..s PCLPCCDr = $o(^DHCEMPCC(0,"PatCheckLev",PclDr,""),-1)
	..s:PCLPCCDr'="" PCLLocDr = $p(^DHCEMPCC(PCLPCCDr),"^",3)
	..s PCLToLocDr = $p(^DHCEMPCL(PclDr),"^",41)
	..s:+PCLLocDr'=0 LocDr=PCLLocDr
	..s:+PCLToLocDr'=0 LocDr=PCLToLocDr
	..q:+LocDr=0
	..s PCLLocDesc = $p(^CTLOC(LocDr),"^",2)
	..s:+PCLLocDr=0 PCLLocDesc="(转)"_PCLLocDesc
	..b ;PCLLocDesc
	..q:PCLLocDesc=""
	..i $d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc",PCLLocDesc)) d
	...s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc",PCLLocDesc,""),-1)+1
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc",PCLLocDesc,Num)=""
	..i '$d(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc",PCLLocDesc)) d
	...s ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc",PCLLocDesc,1)=""
	b ;date
    do QueryPclLoc999
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
    
QueryPclLoc999
	s PCLLocDesc=""
	f  s PCLLocDesc = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc",PCLLocDesc)) q:PCLLocDesc=""  d
	.s Num=""
 	.s Num = $o(^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc",PCLLocDesc,""),-1)
 	.s ^CacheTemp(repid,ind)=$lb(PCLLocDesc,Num)
 	.s ind=ind+1
	q
}

ClassMethod QueryPclLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPclLocExecute ]
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

ClassMethod QueryPclLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPclLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Kill ^TEMP("dhcem","web.DHCEMEmPatCheckLevStat","QueryPclLoc")
 	Quit $$$OK
}

/// ==============================================以下华西医院急诊统计程序==============================================
/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     床位使用率统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       留观科室^床位使用率((一段时间内留观病人总数/天数)/固定床位数)
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryTakBedRateStat","2018-01-01","2018-12-31")
Query QryTakBedRateStat(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "Ward:%String,PatNum:%String,UsRate:%String") [ SqlProc ]
{
}

ClassMethod QryTakBedRateStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 床位使用率统计
	D ..GetTakBedRateStat(StartDate, EndDate, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryTakBedRateStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTakBedRateStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryTakBedRateStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTakBedRateStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     床位使用率统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       留观科室^床位使用率((一段时间内留观病人总数/天数)/固定床位数)
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetTakBedRateStat("2018-01-01","2018-12-31")
ClassMethod GetTakBedRateStat(StartDate As %String, EndDate As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	F dd=StartDate:1:EndDate D
	.s VsID=""
	.F  s VsID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID)) Q:VsID=""  D
	..s VsCode=$p(^DHCPACVisitStatus(VsID),"^",1)
	..Q:(VsCode'="Stay")&(VsCode'="Salvage")
	..s ID=""
	..F  s ID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID,ID)) Q:ID=""  D
	...s WardID=$p(^DHCADMVisitStatus(ID),"^",10)
	...Q:WardID=""
	...s Ward=$p($g(^PAWARD(+WardID)),"^",2)  /// 病区描述
	...i $g(TmpCstArr(WardID))="" s TmpCstArr(WardID)=Ward_"^"_1
	...E  D
	....s $p(TmpCstArr(WardID),"^",2)=$p(TmpCstArr(WardID),"^",2)+1
	..
	
	/// 床位使用率统计
    s WardID=""
	F  s WardID=$o(TmpCstArr(WardID))  Q:WardID=""  D
	.Q:$g(TmpCstArr(WardID))=""
	.s BedNums=+$o(^PAWARD(WardID,"BED",""),-1)
	.Q:BedNums=0
	.s PatNums=$p(TmpCstArr(WardID),"^",2)      /// 科室留观病人总数
	.s UsRate=$FN(((PatNums/(EndDate-StartDate+1))/BedNums)*100,"",2)_"%"
	.s $p(TmpCstArr(WardID),"^",3)=UsRate
	.
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     科室死亡率统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       留观科室^科室死亡率(一段时间内留观病人死亡总数/留观病人总数)
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryLocDeathRateStat","2018-01-01","2018-12-31")
Query QryLocDeathRateStat(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "Ward:%String,PatNum:%String,UsRate:%String") [ SqlProc ]
{
}

ClassMethod QryLocDeathRateStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 科室死亡率统计
	D ..GetLocDeathRateStat(StartDate, EndDate, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryLocDeathRateStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocDeathRateStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryLocDeathRateStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocDeathRateStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     科室死亡率统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       留观科室^留观病人总数^留观病人死亡数^科室死亡率(一段时间内留观病人死亡总数/留观病人总数)
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetLocDeathRateStat("2018-01-01","2018-12-31")
ClassMethod GetLocDeathRateStat(StartDate As %String, EndDate As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	F dd=StartDate:1:EndDate D
	.s VsID=""
	.F  s VsID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID)) Q:VsID=""  D
	..s VsCode=$p(^DHCPACVisitStatus(VsID),"^",1)
	..Q:(VsCode'="Stay")&(VsCode'="Salvage")
	..s ID=""
	..F  s ID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID,ID)) Q:ID=""  D
	...s WardID=$p(^DHCADMVisitStatus(ID),"^",10)
	...Q:WardID=""
	...s Ward=$p($g(^PAWARD(+WardID)),"^",2)  /// 病区描述
	...s EpisodeID=$p(^DHCADMVisitStatus(ID),"^",1)  /// 就诊ID
	...s DeathFlag=..GetDeathFlag(EpisodeID)  /// 病人是否死亡
	...i $g(TmpCstArr(WardID))="" D
	....s TmpCstArr(WardID)=Ward_"^"_1
	....i DeathFlag="Y" s $p(TmpCstArr(WardID),"^",3)=$p(TmpCstArr(WardID),"^",3)+1
	...E  D
	....s $p(TmpCstArr(WardID),"^",2)=$p(TmpCstArr(WardID),"^",2)+1
	....i DeathFlag="Y" s $p(TmpCstArr(WardID),"^",3)=$p(TmpCstArr(WardID),"^",3)+1
	..
	
	/// 科室死亡率统计
    s WardID=""
	F  s WardID=$o(TmpCstArr(WardID))  Q:WardID=""  D
	.Q:$g(TmpCstArr(WardID))=""
	.s PatNums=$p(TmpCstArr(WardID),"^",2)      /// 科室留观病人总数
	.s DeathNums=$p(TmpCstArr(WardID),"^",3)    /// 科室留观病人死亡总数
	.s UsRate=$FN((DeathNums/PatNums)*100,"",2)_"%"
	.s $p(TmpCstArr(WardID),"^",4)=UsRate
	.
	Q ""
}

/// Descript:  病人是否死亡  2447||1 - 尸体料理
ClassMethod GetDeathFlag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s Ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:Ord="" "N"
	Q:$D(^OEORDi(0,"ARCIM",Ord,"2447||1")) "Y"
    Q "N"
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     分诊准确率统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       分诊总数^分诊错误总数^分诊准确总数
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryEmChkPreRateStat","2018-10-16","2018-10-16")
Query QryEmChkPreRateStat(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "TakeNum:%String,misTakeNum:%String,AccTakeNum:%String,UsRate:%String,SRate:%String") [ SqlProc ]
{
}

ClassMethod QryEmChkPreRateStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 分诊准确率统计
	D ..GetEmChkPreRateStat(StartDate, EndDate, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryEmChkPreRateStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmChkPreRateStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryEmChkPreRateStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmChkPreRateStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     分诊准确率统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       分诊总数^分诊错误总数^分诊准确总数
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetEmChkPreRateStat("2018-01-01","2018-12-31")
ClassMethod GetEmChkPreRateStat(StartDate As %String, EndDate As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s TakeNum=0, misTakeNum=0, AccTakeNum=0
	F dd=StartDate:1:EndDate D
	.s EmPCLvID = "" 
	.F  s EmPCLvID = $o(^DHCEMPCL(0,"CreateDate",dd,EmPCLvID)) Q:EmPCLvID=""  D
	..q:'$d(^DHCEMPCL(EmPCLvID))
	..s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	..s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	..s NurseLevel=NurseLevel_"级"
	..s EpisodeID=..GetEmPatCheckLvAdm(EmPCLvID)
	..Q:EpisodeID=""
	..s Priority=$p($g(^PAADM(+EpisodeID)),"^",33) /// 就诊级别
	..s PAAdmPriority=$p($g(^CT("ACU",+Priority)),"^",1)
	..i NurseLevel'=PAAdmPriority s misTakeNum=misTakeNum+1
	..E  s AccTakeNum=AccTakeNum+1
	..s TakeNum=TakeNum+1
	.

	s TmpCstArr(1)=TakeNum_"^"_misTakeNum_"^"_AccTakeNum
	
	/// 分诊错误率统计
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.Q:$g(TmpCstArr(index))=""
	.s TakeNum=$p(TmpCstArr(index),"^",1)      /// 分诊总数
	.s misTakeNum=$p(TmpCstArr(index),"^",2)   /// 变更分诊数
	.s UsRate=$FN((misTakeNum/TakeNum)*100,"",2)_"%"
	.s $p(TmpCstArr(index),"^",4)=UsRate
	.
	/// 分诊准确率统计
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.Q:$g(TmpCstArr(index))=""
	.s TakeNum=$p(TmpCstArr(index),"^",1)      /// 分诊总数
	.s AccTakeNum=$p(TmpCstArr(index),"^",3)   /// 非变更分诊数
	.s SRate=$FN((AccTakeNum/TakeNum)*100,"",2)_"%"
	.s $p(TmpCstArr(index),"^",5)=SRate
	.
	Q ""
}

/// Descript:   取预检分诊就诊ID
/// W ##Class(web.DHCEMEmPatCheckLevStat).GetEmPatCheckLvAdm("67")
ClassMethod GetEmPatCheckLvAdm(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	s TmpEpisodeID=""
	s EmAdmID=""
	F  s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",EmPCLvID,EmAdmID)) Q:(EmAdmID="")||(TmpEpisodeID'="")  D
	.s EpisodeID=$p(^DHCEMPCA(EmAdmID),"^",2)
	.Q:$p(^PAADM(EpisodeID),"^",20)="C"
	.s TmpEpisodeID=EpisodeID
	Q TmpEpisodeID
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     非计划重返抢救室率（72小时内重返抢救室的病人，第二次入抢救室）
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       抢救总人数^72小时重返总数^72小时重返抢救室率
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryPatToResAgaStat","2018-01-01","2018-12-31")
Query QryPatToResAgaStat(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "ResNums:%String,ResAgaNums:%String,ResRate:%String") [ SqlProc ]
{
}

ClassMethod QryPatToResAgaStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 非计划重返抢救室率
	D ..GetPatToResAgaStat(StartDate, EndDate, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryPatToResAgaStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatToResAgaStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryPatToResAgaStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatToResAgaStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     非计划重返抢救室率（72小时内重返抢救室的病人，第二次入抢救室）
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       抢救总人数^72小时重返总数^72小时重返抢救室率
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetPatToResAgaStat("2018-01-01","2018-12-31")
ClassMethod GetPatToResAgaStat(StartDate As %String, EndDate As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	s VsID=$o(^DHCPACVisitStatus(0,"Code","SALVAGE",""))
	Q:VsID="" ""
	
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID,ID)) Q:ID=""  D
	..s WardID=$p(^DHCADMVisitStatus(ID),"^",10)
	..Q:WardID=""
	..s Ward=$p($g(^PAWARD(+WardID)),"^",2)  /// 病区描述
	..s EpisodeID=$p(^DHCADMVisitStatus(ID),"^",1)  /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..i $g(TmpCstArr(PatientID))="" s TmpCstArr(PatientID)=ID
	..E  D
	...s TmpCstArr(PatientID)= TmpCstArr(PatientID)_"^"_ID
	..
	
	/// 非计划重返抢救室率
	s ResNums=0,ResAgaNums=0
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ResNums=ResNums+1
	.Q:$L(TmpCstArr(index),"^")=1
	.Q:..isRetFlag($g(TmpCstArr(index)))=0
	.s ResAgaNums=ResAgaNums+1
	.
	k TmpCstArr
	s ResRate=$FN((ResAgaNums/ResNums)*100,"",2)_"%"
	s TmpCstArr(1)=ResNums_"^"_ResAgaNums_"^"_ResRate
	Q ""
}

/// Descript:  72小时重返
/// D ##Class(web.DHCEMEmPatCheckLevStat).isRetFlag("2018-01-01","2018-12-31")
ClassMethod isRetFlag(mListData As %String)
{
	n (mListData)
	s Num=0         //重返次数
	F i=1:1:$L(mListData,"^")-1 Q:Num'=0  D
	.s ID=$p(mListData,"^",i)
	.s SID=$p(mListData,"^",i+1)
	.s firDate=$p(^DHCEMPCL(firId),"^",8) 	/// 设置抢救日期
	.s firTime=$p(^DHCEMPCL(firId),"^",9) 	/// 设置抢救时间
	.s secDate=$p(^DHCEMPCL(secId),"^",8) 	/// 设置抢救日期
	.s secTime=$p(^DHCEMPCL(secId),"^",9) 	/// 设置抢救时间
	.s timeSpace=(firTime-secTime)/3600+(firDate-secDate)*24
	.Q:$SYSTEM.SQL.ABS(timeSpace)>72
	.s Num=Num+1
	Q Num
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     急诊患者输血前HB的比例
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       HB≤60比例,60<HB≤70比例,70<HB≤100比例
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryEmPatHBRateStat","2020-02-25","2020-02-24")
Query QryEmPatHBRateStat(StartDate As %String, EndDate As %String, HOSPID As %String) As %Query(ROWSPEC = "HBRates:%String,HBRates1:%String,HBRates2:%String") [ SqlProc ]
{
}

ClassMethod QryEmPatHBRateStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HOSPID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 急诊患者输血前HB的比例
	D ..GetEmPatHBRateStat(StartDate, EndDate,HOSPID, .TmpCstArr) //hxy 2020-06-16 HospID
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryEmPatHBRateStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmPatHBRateStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryEmPatHBRateStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmChkPreRateStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     急诊患者输血前HB的比例
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       HB≤60,60<HB≤70,70<HB≤100
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetEmPatHBRateStat("2018-01-01","2018-12-31")
ClassMethod GetEmPatHBRateStat(StartDate As %String, EndDate As %String, HOSPID As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate,HOSPID, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s HBRate=0, HBRate1=0, HBRate2=0, HBRate3=0
	F dd=StartDate:1:EndDate D
	.s EmPCLvID = "" 
	.F  s EmPCLvID = $o(^DHCEMPCL(0,"CreateDate",dd,EmPCLvID)) Q:EmPCLvID=""  D
	..q:'$d(^DHCEMPCL(EmPCLvID))
	..s EpisodeID=..GetEmPatCheckLvAdm(EmPCLvID)
	..Q:EpisodeID=""
	..Q:##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)'=HOSPID //hxy 2020-06-16
	..s ItmsValue=..LabItmsValue(EpisodeID,"17228||1")
	..i ItmsValue'>60 s HBRate1=HBRate1+1
	..i (ItmsValue>60)&(ItmsValue<70) s HBRate2=HBRate2+1
	..i (ItmsValue>70)&(ItmsValue<100) s HBRate3=HBRate3+1
	..s HBRate=HBRate+1
	.
	
	s HBRate1="",HBRate2="",HBRate3=""
	/// 急诊患者输血前HB的比例
	i +HBRate'=0 d
	.s HBRate1=$FN(HBRate1/HBRate*100,"",2)   /// HB≤60
	.s HBRate2=$FN(HBRate2/HBRate*100,"",2)	 /// 60<HB≤70
	.s HBRate3=$FN(HBRate3/HBRate*100,"",2)	 /// 70<HB≤100
	i +HBRate=0 d
	.s HBRate1=$FN(0,"",2)   /// HB≤60
	.s HBRate2=$FN(0,"",2)	 /// 60<HB≤70
	.s HBRate3=$FN(0,"",2)	 /// 70<HB≤100
	s TmpCstArr(1)=HBRate_"^"_HBRate1_"^"_HBRate2_"^"_HBRate3
	
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     急诊离院原因统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       离院原因^离院人数
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryEmDisReasonStat","2018-01-01","2018-12-31")
Query QryEmDisReasonStat(StartDate As %String, EndDate As %String, HospID As %String) As %Query(ROWSPEC = "DisReason:%String,DisPatNums:%String") [ SqlProc ]
{
}

ClassMethod QryEmDisReasonStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 急诊离院原因统计
	D ..GetEmDisReasonStat(StartDate, EndDate, HospID, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryEmDisReasonStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmDisReasonStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryEmDisReasonStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmDisReasonStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     急诊离院原因统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       离院原因^离院人数
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetEmDisReasonStat("2018-01-01","2018-12-31")
ClassMethod GetEmDisReasonStat(StartDate As %String, EndDate As %String, HospID As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, HospID, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s:HospID="" HospID="1"
	
	s VsID=$o(^DHCPACVisitStatus(0,"Code","DISCHARGE",""))   /// 离院状态字典ID
	Q:VsID="" ""
	
	s TypeID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4("DIS"),HospID,""))
	Q:TypeID="" ""
	s ID=""
	F  s ID=$o(^DHCEMCDI(0,"Type",TypeID,ID)) Q:ID=""  D
	.Q:$p(^DHCEMCDI(ID),"^",3)'="Y"
	.s itmDesc=$p(^DHCEMCDI(ID),"^",2)
	.s TmpCstArr(itmDesc)=itmDesc_"^"_0
	.
	
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID,ID)) Q:ID=""  D
	..s vsNote=$p($g(^DHCADMVisitStatus(+ID)),"^",11)
	..Q:vsNote=""        /// 状态备注
	..s $p(TmpCstArr(vsNote),"^",2)=$p(TmpCstArr(vsNote),"^",2)+1
	.
	
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-17
/// Descript:     急诊转入院48小时发生感染统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号^感染诊断^感染日期^感染科室
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryEmTraInHosStat","2018-01-01","2018-12-31")
Query QryEmTraInHosStat(StartDate As %String, EndDate As %String, HospID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatDiag:%String,BillType:%String,PatLoc:%String,PatWard:%String,PatBed:%String,InfDiag:%String,InfDate:%String,InfLoc:%String") [ SqlProc ]
{
}

ClassMethod QryEmTraInHosStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 急诊离院原因统计
	D ..GetEmTraInHosStat(StartDate, EndDate, HospID, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryEmTraInHosStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmTraInHosInfStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryEmTraInHosStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmTraInHosInfStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     急诊转入院48小时发生感染统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号^感染诊断^感染日期^感染科室
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetEmTraInHosStat("2018-01-01","2018-12-31")
ClassMethod GetEmTraInHosStat(StartDate As %String, EndDate As %String, HospID As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, HospID, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s:HospID="" HospID="1"
	
	s VsID=$o(^DHCPACVisitStatus(0,"Code","INHOSPITAL",""))   /// 入院状态字典ID
	Q:VsID="" ""
	
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCADMVisitStatus(ID),"^",1)     /// 就诊ID
	..S EDate=$p(^DHCADMVisitStatus(ID),"^",5)  	   /// 就诊日期
	..S ETime=$p(^DHCADMVisitStatus(ID),"^",6) 		   /// 就诊时间
	..s PatEssInfo=..GetPatEssInfo(EpisodeID)          /// 病人基本信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	..s EpisodeID=""
	..F  s EpisodeID=$o(^PAPERdr(PatientID,"ADM","I",EpisodeID)) Q:EpisodeID=""  D
	...S InDate=$p(^PAADM(EpisodeID),"^",6)  		   /// 就诊日期
	...S InTime=$p(^PAADM(EpisodeID),"^",7)  		   /// 就诊时间
	...Q:(InDate<EDate)||(InDate>(EDate+2))            /// 48小时有效
	...Q:(InDate=EDate)&(InTime<ETime)
	...Q:(InDate=(EDate+2))&(InTime>ETime)
	...s InHosPatInfCon=..GetInHosPatInfCon(EpisodeID)  /// 病人后入院感染信息
	...Q:InHosPatInfCon=""
	...F i=1:1:$L(InHosPatInfCon,"#") D
	....s TmpCstArr(EpisodeID,i)=PatEssInfo_"^"_$p(InHosPatInfCon,"#",i)
	.
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-17
/// Descript:     病人后入院感染信息
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       感染诊断1^感染日期1^感染科室1#感染诊断2^感染日期2^感染科室2#感染诊断3^感染日期3^感染科室3
/// W ##Class(web.DHCEMEmPatCheckLevStat).GetPatEssInfo("")
ClassMethod GetInHosPatInfCon(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ListData=##Class(DHCHAI.CUS.ToClinReport).GetRepByEpisode(EpisodeID)
	Q ListData
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-17
/// Descript:     危重病人 APACHE II评分表统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号^APACHE II评分分值
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryEmApacheStat","2018-01-01","2018-12-31")
Query QryEmApacheStat(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatDiag:%String,BillType:%String,PatLoc:%String,PatWard:%String,PatBed:%String,Score:%String") [ SqlProc ]
{
}

ClassMethod QryEmApacheStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 危重病人 APACHE II评分表统计
	D ..GetEmApacheStat(StartDate, EndDate, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryEmApacheStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmApacheStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryEmApacheStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmApacheStatExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     危重病人 APACHE II评分表统计
/// InPut:        StartDate - 开始日期， EndDate - 结束日期
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号^APACHE II评分分值
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetEmApacheStat("2018-01-01","2018-12-31")
ClassMethod GetEmApacheStat(StartDate As %String, EndDate As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	F dd=StartDate:1:EndDate D
	.s EpisodeID=""
	.F  s EpisodeID=$o(^DHCEMSCORE(0,"Create",dd,EpisodeID)) Q:EpisodeID=""  D
	..s ID=""
	..F  s ID=$o(^DHCEMSCORE(0,"Create",dd,EpisodeID,ID)) Q:ID=""  D
	...s EpisodeID=$p(^DHCEMSCORE(ID),"^",1)            /// 就诊ID
	...s PatEssInfo=..GetPatEssInfo(EpisodeID)          /// 病人基本信息
	...s Score=..GetApacheScore(EpisodeID)              /// Apache分值
	...Q:Score'>15
	...s TmpCstArr(EpisodeID)=PatEssInfo_"^"_Score
	.
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-15
/// Descript:     危重病人 APACHE II评分表统计
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       APACHE II分数
/// W ##Class(web.DHCEMEmPatCheckLevStat).GetApacheScore("186")
ClassMethod GetApacheScore(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s MaxScore=0
	s ID=""
	F  s ID=$o(^DHCEMSCORE(0,"Adm",EpisodeID,ID)) Q:ID=""  D
	.s Score=$p(^DHCEMSCORE(ID,"I",1),"^",3)
	.Q:Score'>15
	.i Score>MaxScore s MaxScore=Score
	.
	Q MaxScore
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-17
/// Descript:     病人基本信息
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号
/// W ##Class(web.DHCEMEmPatCheckLevStat).GetPatEssInfo("")
ClassMethod GetPatEssInfo(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
    s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) /// 年龄
	s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)       /// 诊断
	;i $L(PatDiag)>80 s PatDiag=$E(PatDiag,1,80)_"..."
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		        /// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2)   /// 病区描述
	s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s PatBed = $replace(PatBed,"床","")
	s:PatBed'="" PatBed=PatBed_##class(web.DHCEMCommonUtil).GetTrans("","床")
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	s PatWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWard)
	s PatLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc)
	S BillType=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSocialStatus","SSDesc","",BillType)
	s ListData=EpisodeID_"^"_PatientID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge
	s ListData=ListData_"^"_PatDiag_"^"_BillType_"^"_PatLoc_"^"_PatWard_"^"_PatBed
	Q ListData
}

/// Descript:检验项目值  17228||1 - 血常规, HB指标
ClassMethod LabItmsValue(EpisodeID As %String, arcimid As %String) As %String
{
	n (EpisodeID, arcimid)
	s Ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:Ord="" ""
	Q:$D(^OEORDi(0,"ARCIM",Ord,arcimid)) ""
	s itm=$o(^OEORDi(0,"ARCIM",Ord,arcimid,""))
	Q:itm="" ""
	s LabEpisode=$p(^OEORD(Ord,"I",itm,3),"^",20)     /// 检验号
	s LabTestSetRow=$p(^OEORD(ord,"I",itm,3),"^",35)  /// 报告ID
	s VisitNumberTestSetDR=LabTestSetRow
	Q:VisitNumberTestSetDR="" ""
	//报告信息
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
	q:'$l(VisitNumberDR) ""
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	q:'$l(WorkGroupMachineDR) ""
	s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	q:'$l(OrderNo) ""
	s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
 	q:'$l(ReportDR) ""
 	q:$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)'=3 ""
 	s TestCodeDR="", ItemResult=""
 	f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:(TestCodeDR="")||(ItemResult'="")  d
 	.Q:'$d(^dbo.BTTestSetLayoutI("IndexTestCode",TestCodeDR,TestSetDR,WorkGroupDR))
 	.s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	.s ItemCode=$lg(TestCodeData,2)    //检验项目代码
 	.Q:ItemCode'="HB"
	.s ItemDesc=$lg(TestCodeData,3)    //检验项目描述
	.s TCSync=$lg(TestCodeData,7)
 	.s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
 	.q:'$l(ResultDR)
 	.s ResultData=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	.s ItemResult=$lg(ResultData,5)  //结果
	.s ItemUnit=$lg(ResultData,11)   //检验项目的单位
	.s AbnorFlag=$lg(ResultData,9)   //异常标记
	.s ItmRange=$lg(ResultData,12)   //参考范围
	.
	Q ItemResult
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     1、急诊抢救就诊次数(病人挂号的诊室为'急诊抢救室'的急诊科就诊人次);
/// 			  2、急诊抢救死亡就诊次数(病人挂号的诊室为'急诊抢救室'且有尸体料理医嘱的急诊人次);
/// InPut:        StartDate - 开始日期， EndDate - 结束日期， IsDeathFlag - 是否死亡
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号^APACHE II评分分值
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryEmResVisNum","2019-06-04","2019-06-04","")
Query QryEmResVisNum(StartDate As %String, EndDate As %String, IsDeathFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatDiag:%String,BillType:%String,PatLoc:%String,PatWard:%String,PatBed:%String") [ SqlProc ]
{
}

ClassMethod QryEmResVisNumExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, IsDeathFlag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpArr
    
    /// 急诊抢救就诊次数统计
	D ..GetEmResVisNum(StartDate, EndDate, IsDeathFlag,.TmpArr)
	
    s index=""
	F  s index=$o(TmpArr(index))  Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryEmResVisNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmResVisNumExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryEmResVisNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmResVisNumExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     1、急诊抢救就诊次数(病人挂号的诊室为'急诊抢救室'的急诊科就诊人次);
/// 			  2、急诊抢救死亡就诊次数(病人挂号的诊室为'急诊抢救室'且有尸体料理医嘱的急诊人次);
/// InPut:        StartDate - 开始日期， EndDate - 结束日期， IsDeathFlag - 是否死亡
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetEmResVisNum("2019-06-04","2019-06-04")
ClassMethod GetEmResVisNum(StartDate As %String, EndDate As %String, IsDeathFlag As %String, TmpArr As %String) As %String
{
	n (StartDate, EndDate, IsDeathFlag, TmpArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	F dd=StartDate:1:EndDate D
	.s EmPCLvID = "" 
	.F  s EmPCLvID = $o(^DHCEMPCL(0,"CreateDate",dd,EmPCLvID)) Q:EmPCLvID=""  D
	..q:'$d(^DHCEMPCL(EmPCLvID))
	..s EpisodeID=..GetEmPatCheckLvAdm(EmPCLvID)
	..Q:'..isResPatFlag(EmPCLvID)		               /// 就诊科室【急诊抢救室】
	..i IsDeathFlag="Y" Q:..isTakDeathArc(EpisodeID)=0
	..s PatEssInfo=..GetPatEssInfo(EpisodeID)          /// 病人基本信息
	..s TmpArr(EpisodeID)=PatEssInfo
	.
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     是否是急诊抢救室病人
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       1-是，0-不是
/// W ##Class(web.DHCEMEmPatCheckLevStat).isResPatFlag("186")
ClassMethod isResPatFlag(EmPCLvID As %String) As %String
{
	n (EmPCLvID)
	s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,"")) 
	Q:EmPccID="" 0
	s EmCareID=$p(^DHCEMPCC(EmPccID),"^",2)   /// 预检号别
	Q:EmCareID="" 0
 	Q:##Class(web.DHCEMPatCheckLev).GetCareMarkDepID(EmCareID)'="701" 0
 	Q 1
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     是否有死亡料理医嘱 (2447||1-尸体料理)
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       1-有，0-没有
/// W ##Class(web.DHCEMEmPatCheckLevStat).isTakDeathArc("186")
ClassMethod isTakDeathArc(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s Ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:Ord="" 0
	s arcimid="2447||1"
	Q:'$D(^OEORDi(0,"ARCIM",Ord,arcimid)) 0
	Q 1
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     1、急诊心肺复苏例数(急诊病人'心肺复苏术'医嘱数量;);
/// 			  2、急诊心肺复苏失败例数(两次心肺复苏术间隔小于等于24小时的值+1,最后一次心肺复苏术后有尸体料理医嘱的,不考虑时间差一律+1);
/// InPut:        StartDate - 开始日期， EndDate - 结束日期， , IsFailFlag - Y(失败例数)N(全部例数)
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号^APACHE II评分分值
/// D ##Class(%ResultSet).RunQuery("web.DHCEMEmPatCheckLevStat","QryEmRoscNum","2019-06-04","2019-06-04","1")
Query QryEmRoscNum(StartDate As %String, EndDate As %String, IsFailFlag As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatDiag:%String,BillType:%String,PatLoc:%String,PatWard:%String,PatBed:%String,Num:%String") [ SqlProc ]
{
}

ClassMethod QryEmRoscNumExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, IsFailFlag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpArr
    
    /// 急诊心肺复苏例数统计
	D ..GetEmRoscNum(StartDate, EndDate, IsFailFlag,.TmpArr)
	
    s index=""
	F  s index=$o(TmpArr(index))  Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryEmRoscNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEmRoscNumExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryEmRoscNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEmRoscNumExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {                // if there are no more rows, finish fetching
	    Set AtEnd=1
	    Set Row=""
	 }
	 Else {         
	        Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     1、急诊心肺复苏例数(急诊病人'心肺复苏术'医嘱数量;);
/// 			  2、急诊心肺复苏失败例数(两次心肺复苏术间隔小于等于24小时的值+1,最后一次心肺复苏术后有尸体料理医嘱的,不考虑时间差一律+1);
/// InPut:        StartDate - 开始日期， EndDate - 结束日期， , IsFailFlag - Y(失败例数)N(全部例数)
/// OutPut:       就诊ID^病人ID^登记号^姓名^姓别^年龄^诊断^费别^就诊科室^病区^床号
/// D ##Class(web.DHCEMEmPatCheckLevStat).GetEmRoscNum("2019-06-04","2019-06-04","")
ClassMethod GetEmRoscNum(StartDate As %String, EndDate As %String, IsFailFlag As %String, TmpArr As %String) As %String
{
	n (StartDate, EndDate, IsFailFlag, TmpArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	F dd=StartDate:1:EndDate D
	.s EmPCLvID = "" ,Num = 0
	.F  s EmPCLvID = $o(^DHCEMPCL(0,"CreateDate",dd,EmPCLvID)) Q:EmPCLvID=""  D
	..q:'$d(^DHCEMPCL(EmPCLvID))
	..s EpisodeID=..GetEmPatCheckLvAdm(EmPCLvID)
	..i IsFailFlag="Y" s Num=..GetTakRoscFailNum(EpisodeID)
	..E  s Num=..GetTakRoscNum(EpisodeID)
	..Q:Num=0
	..s PatEssInfo=..GetPatEssInfo(EpisodeID)          /// 病人基本信息
	..s TmpArr(EpisodeID)=PatEssInfo_"^"_Num
	.
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     指定医嘱的数量 (2495||1-心肺复苏术)
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       数量
/// W ##Class(web.DHCEMEmPatCheckLevStat).GetTakRoscNum("70022537")
ClassMethod GetTakRoscNum(EpisodeID As %String) As %String
{
	n (EpisodeID, IsFailFlag)
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:ord="" 0
	s arcimid="2495||1" 
	s dd="",Num=0
	F  s dd=$o(^OEORDi(0,"ARCIM",ord,arcimid,dd)) Q:dd=""  D
	.s itm=""
	.F  s itm=$o(^OEORDi(0,"ARCIM",ord,arcimid,dd,itm)) Q:itm=""  D
	..s Num=Num+1
	.
	Q Num
}

/// Creator:      bianshuai
/// CreateDate:   2019-06-04
/// Descript:     指定医嘱的数量 (2495||1-心肺复苏术)
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       数量
/// W ##Class(web.DHCEMEmPatCheckLevStat).GetTakRoscFailNum("70022537")
ClassMethod GetTakRoscFailNum(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:ord="" 0
	s Num=0
	s arcimid="2495||1" 
	s dd="",Num=0, TmpDate="",TmpTime=""
	F  s dd=$o(^OEORDi(0,"ARCIM",ord,arcimid,dd)) Q:dd=""  D
	.s itm=""
	.F  s itm=$o(^OEORDi(0,"ARCIM",ord,arcimid,dd,itm)) Q:itm=""  D
	..s StartDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)  /// 医嘱开始日期
	..s StartTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10) /// 医嘱开始时间
	..i ((StartDate*86400+StartTime)-(TmpDate*86400+TmpTime))<86400 D
	...s Num=Num+1
	..s TmpDate=StartDate,TmpTime=StartTime
	..
	i $d(^OEORDi(0,"ARCIM",ord,arcimid))&(..isTakDeathArc(EpisodeID)) s Num=Num+1 /// 死亡
	Q Num
}

/// ==============================================以上华西医院急诊统计程序==============================================

}
