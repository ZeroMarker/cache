/// Descript:   平均急诊留观时间
/// Creator:    huaxiaoying
/// CreateDate: 2017-07-17
/// d ##class(%ResultSet).RunQuery("web.DHCEMAvgObservationTime","observationTimeQuery","2017-08-16","2022-08-16","1","2")
Class web.DHCEMAvgObservationTime Extends %RegisteredObject
{

Query observationTimeQuery(stDate, edDate, type, HOSPID = "") As %Query(ROWSPEC = "PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,stayDate:%String,stayTime:%String,GoDate:%String,GoTime:%String,Hours:%Double,PatDiag:%String,PCLNurseLevel:%String") [ SqlProc ]
{
}

/// type 1:抢救/2:留观
ClassMethod observationTimeQueryExecute(ByRef qHandle As %Binary, stDate, edDate, type, HOSPID = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMAvgObservationTime","observationTimeQuery","2018-03-16","2018-03-16")
	;d ##class(%ResultSet).RunQuery("web.DHCEMAvgObservationTime","observationTimeQuery","","")
	
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    i (stDate="")||(edDate="" ) Quit $$$OK
  	//编码开始
  	s stDate= $zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
  	f date = stDate:1:edDate d
  	.s PCLRowID=0 
  	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",date,PCLRowID))  q:PCLRowID=""  d
    ..s PatientID=$p(^DHCEMPCL(PCLRowID),"^",1)      /// 病人ID
    ..q:+PatientID=0
 	..q:'$d(^PAPER(PatientID))  ;2017-11-27 lvpeng 58上错误数据过滤
 	..s PatLocID=$p(^DHCEMPCL(PCLRowID),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:(HOSPID'="")&&(CurHospID'=HOSPID) //ed
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  ///护士分级
    ..s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-25
    ..s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)	///病人登记号
	..s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)    ///病人姓名
	..s PatSex=""
	..s sexId=$p($g(^PAPER(PatientID,"ALL")),"^",7)      /// 性别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge= ##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(PCLRowID)
	..s birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)   /// 出生日期
	..i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) 
	..s PCARowID="",EpisodeID=""
	..s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,PCARowID)) ///就诊号   预检分级就诊表
	..i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2)
	..q:EpisodeID=""
	..S PatDiag=""
	..i EpisodeID'="" s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDescForRunQian(EpisodeID) //诊断
	..s AdmWardId=$p(^PAADM(EpisodeID),"^",70)
	..q:+AdmWardId=0
	..s AdmWard = $p(^PAWARD(AdmWardId),"^",2)
	..q:(type=1)&&(AdmWard'["抢救")
	..q:(type=2)&&(AdmWard'["留观")
	..///离院日期时间
	..s GoDate="",GoTime="",Dadvid=""     //取最后一次离院时间
	..i EpisodeID'="" d
	...s Dadvid=""
	...s Dadvid =$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid),-1)
	...q:Dadvid=""
    ...s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    ...q:+DadvStu'=6
    ...s GoDate=$p(^DHCADMVisitStatus(Dadvid),"^",5)  //离院时间
    ...s GoTime=$p(^DHCADMVisitStatus(Dadvid),"^",6)
	.. ///留观日期时间   	
   	..s stayDateInfo = ##class(web.DHCEMInComUseMethod).GetFirstInSeatDate(EpisodeID)
   	..s stayDate = $p(stayDateInfo,"^",1)
   	..s stayTime = $p(stayDateInfo,"^",2)
   	..q:+stayDate=0    //没有留观过直接Q
   	..i GoDate="" d
   	...s Hours=(+$h-stayDate)*24+$j(($p($h,",",2)-stayTime)/3600,2,2)
    ..e  d
    ...s Hours=(GoDate-stayDate)*24+$j((GoTime-stayTime)/3600,2,2)
    ..s:GoDate'="" GoDate=$zd(GoDate,3) ;##class(web.DHCEMCommonUtil).DateLogicalToHtml(GoDate) 
    ..s:GoTime'="" GoTime=$zt(GoTime)
    ..s:stayDate'="" stayDate=$zd(stayDate,3) ;##class(web.DHCEMCommonUtil).DateLogicalToHtml(stayDate) 
    ..s:stayTime'="" stayTime=$zt(stayTime)
	..d OutputRow1
    //编码结束
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatNo,PatName,PatSex,PatAge,stayDate,stayTime,GoDate,GoTime,Hours,PatDiag,PCLNurseLevel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod observationTimeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = observationTimeQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod observationTimeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = observationTimeQueryExecute ]
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

/// Description: 取中位数
/// Creator:     Yuliping
/// CreateDate:  2019-12-05
/// Input:  	 numStr
/// Return: 	 中位数
/// w ##class(web.DHCEMAvgObservationTime).getMedian("82.40^254.43^47.85^121.35^120")
ClassMethod getMedian(numStr)
{
	q:numStr="" ""
	s ^shy("000")=numStr
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getMedian")
	s length=$l(numStr,"^")
	q:length=1 numStr
	q:length=0 ""
	s flag=length#2   //判断奇偶
	
	s i=0
	f i=1:1:length  d
	.s value=($p(numStr,"^",i))*100
	.i $d(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getMedian",value)) d        //数字相同的，计数器+1
	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getMedian",value)=^TMP("DHCEM","web.DHCEMPatCheckLevStat","getMedian",value)+1
	.e  s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","getMedian",value)=1
	
	
	s newNumStr=""
	s num=0
	f  s num=$o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","getMedian",num))  q:num=""  d
	.s count=^TMP("DHCEM","web.DHCEMPatCheckLevStat","getMedian",num)
	.s sameNum=""
	.i count>1 d				//count>1，证明有多个相同的,拼到串里
	..f j=1:1:count d
	...i sameNum="" s sameNum=num
	...e  s sameNum=num_"^"_sameNum
	.e  s sameNum=num
	.i newNumStr="" s newNumStr=sameNum
	.e  s newNumStr=newNumStr_"^"_sameNum
	b
	s rtn=0
	i flag=1 s rtn=$p(newNumStr,"^",((length/2)+1))/100
	i flag=0 s rtn=($p(newNumStr,"^",((length/2)))+$p(newNumStr,"^",((length/2)+1)))/200
	s rtn=$justify(rtn,3,2)
	q rtn
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMAvgObservationTime","medTimeQuery")
/// d ##class(%ResultSet).RunQuery("web.DHCEMAvgObservationTime","medTimeQuery","2022-07-18","2022-07-18","1","2")
Query medTimeQuery(stDate, edDate, type, HOSPID) As %Query(ROWSPEC = "MedTime:%String") [ SqlProc ]
{
}

ClassMethod medTimeQueryExecute(ByRef qHandle As %Binary, stDate, edDate, type, HOSPID) As %Status
{
	;tro 
	
	s ^qqa("medTimeQueryExecute")=$lb(stDate, edDate, type, HOSPID)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
        Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    i (stDate="")||(edDate="" ) Quit $$$OK
  	//编码开始
  	s stDate= $zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	s Str=""
  	f date = stDate:1:edDate d
  	.s PCLRowID=0 
  	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",date,PCLRowID))  q:PCLRowID=""  d
    ..s PatientID=$p(^DHCEMPCL(PCLRowID),"^",1)      /// 病人ID
    ..q:+PatientID=0
 	..q:'$d(^PAPER(PatientID))  ;2017-11-27 lvpeng 58上错误数据过滤
 	..s PatLocID=$p(^DHCEMPCL(PCLRowID),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLRowID),"^",7)  ///护士分级
    ..s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-25
    ..s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)	///病人登记号
	..s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)    ///病人姓名
	..s PatSex=""
	..s sexId=$p($g(^PAPER(PatientID,"ALL")),"^",7)      /// 性别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge= ##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(PCLRowID)
	..s birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)   /// 出生日期
	..i birthday'="" s birthday=##class(web.DHCEMCommonUtil).DateLogicalToHtml(birthday) 
	..s PCARowID="",EpisodeID=""
	..s PCARowID=$o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,PCARowID)) ///就诊号   预检分级就诊表
	..i PCARowID'="" s EpisodeID=$p($g(^DHCEMPCA(PCARowID)),"^",2)
	..q:EpisodeID=""
	..S PatDiag=""
	..i EpisodeID'="" s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",") //诊断
	..s AdmWardId=$p(^PAADM(EpisodeID),"^",70)
	..q:+AdmWardId=0
	..s AdmWard = $p(^PAWARD(AdmWardId),"^",2)
	..q:(type=1)&&(AdmWard'["抢救")
	..q:(type=2)&&(AdmWard'["留观")
	..///离院日期时间
	..s GoDate="",GoTime="",Dadvid=""     //取最后一次离院时间
	..i EpisodeID'="" d
	...s Dadvid=""
	...s Dadvid =$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,Dadvid),-1)
	...q:Dadvid=""
    ...s DadvStu=$p(^DHCADMVisitStatus(Dadvid),"^",2)
    ...q:+DadvStu'=6
    ...s GoDate=$p(^DHCADMVisitStatus(Dadvid),"^",5)  //离院时间
    ...s GoTime=$p(^DHCADMVisitStatus(Dadvid),"^",6)
	.. ///留观日期时间   	
   	..s stayDateInfo = ##class(web.DHCEMInComUseMethod).GetFirstInSeatDate(EpisodeID)
   	..s stayDate = $p(stayDateInfo,"^",1)
   	..s stayTime = $p(stayDateInfo,"^",2)
   	..q:+stayDate=0    //没有留观过直接Q
   	..i GoDate="" d
   	...s Hours=(+$h-stayDate)*24+$j(($p($h,",",2)-stayTime)/3600,2,2)
    ..e  d
    ...s Hours=(GoDate-stayDate)*24+$j((GoTime-stayTime)/3600,2,2)
    ..s:Str'="" Str=Str_"^"_Hours
    ..s:Str="" Str=Hours
    ..s:GoDate'="" GoDate=$zd(GoDate,3) ;##class(web.DHCEMCommonUtil).DateLogicalToHtml(GoDate) 
    ..s:GoTime'="" GoTime=$zt(GoTime)
    ..s:stayDate'="" stayDate=$zd(stayDate,3) ;##class(web.DHCEMCommonUtil).DateLogicalToHtml(stayDate) 
    ..s:stayTime'="" stayTime=$zt(stayTime)
  	//编码开始
	s MedTime=..getMedian(Str)
	d OutputRow2
    //编码结束
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(MedTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod medTimeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = medTimeQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod medTimeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = medTimeQueryExecute ]
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

}
