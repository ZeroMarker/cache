/// 类名: DtPortal.ND.ND01.ND0102TransferList
/// Creator： 程鹏
/// CreatDate： 2018-12-12
/// Description: 查询护理部重点关注转科患者列表
Class DtPortal.ND.ND01.ND0102TransferList Extends %RegisteredObject
{

/// Creator： 白明哲
/// CreatDate： 2014-8-28
/// Description: 查询某天转科人数各病区分布人数
/// Input：  Date      日期 格式 2018-11-12
/// Return： 
/// 服务编码：ND01.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0102TransferList","ND010201","2019-01-01","2019-09-01")
Query ND010201(startDate As %String = "", endDate As %String = "") As DtPortal.Query(ROWSPEC = "name:%String,y:%String,WardId:%String")
{
}

ClassMethod ND010201Execute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	q:(startDate="")||(endDate="") $$$OK
	
	set:startDate["-" startDate=$zdh(startDate,3)
	set:endDate["-" endDate=$zdh(endDate,3)
	
	//找出有转科记录的病人 就诊ID，存入数组中-----用于相同的PAADM只取一次
	for Date=startDate:1:endDate {
		s TRANSStartTime=""
		f  s TRANSStartTime=$o(^PAADMi("TransDateTime",Date,TRANSStartTime)) q:TRANSStartTime=""  d
		.s PAAdm=""
		.f  s PAAdm=$o(^PAADMi("TransDateTime",Date,TRANSStartTime,PAAdm)) q:PAAdm=""  d
		..s paadmType=$P($g(^PAADM(PAAdm)),"^",2)
		..q:paadmType'="I"
		..s PaadmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
		..q:PaadmVisitStatus'="A"   //出院病人退出---非在院病人
		..s FindWardTodayTransferNum($j,PAAdm)=1	//把有转科的病人存入数组中，用于一个就诊号只存一次
	}
	
	
	s PAAdm="" 
	for{
		s PAAdm=$o(FindWardTodayTransferNum($j,PAAdm))
		q:PAAdm=""
		s numPaadm=1
		s locs=##class(DtPortal.ND.ND01.ND0102TransferList).getPatLocs(PAAdm)
		s count=locs.Count()
		continue:count=1
		f i=1:1:count d
		.s loc= locs.GetAt(i)
		.s no=loc.GetAt("No")
		.q:no=0   //第二条算转科数据
		.s stDate=loc.GetAt("StartDate")
		.q:(stDate<startDate)||(stDate>endDate)
		.;w !,$zd(stDate,3)
		.s WardId = loc.GetAt("WardId")
		.s WardNum(WardId,PAAdm,numPaadm)=""
		.s numPaadm=numPaadm+1
	}
	
	
	
	
	//输出信息
    s Ward=0
    f  s Ward=$o(WardNum(Ward)) q:Ward=""  d
    .s WardNum1=0
    .s PAAdm=0 f  s PAAdm=$o(WardNum(Ward,PAAdm)) q:PAAdm=""  d
    ..s numPaadm="" f  s numPaadm=$o(WardNum(Ward,PAAdm,numPaadm)) q:numPaadm=""  d
    ...s WardNum1=WardNum1+1
    .q:WardNum1=0
    .s WardDesc=$p(^PAWARD(Ward),"^",2)
    .i WardDesc["-" s WardDesc=$p(WardDesc,"-",2)
    .s Data=$lb(WardDesc,WardNum1,Ward)
 	.s ^||CacheTemp(repid,ind)=Data	
 	.s ind=ind+1
    

  	q $$$OK
}

/// Creator： 白明哲
/// CreatDate： 2014-8-28
/// Description: 查询某天转科人数各病区分布明细
/// Input：  WardId      病区ID
/// 		 Date      日期 格式 2018-11-12
/// Return： 
/// 服务编码：ND01.02.02
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0102TransferList","ND010202",1,"2019-08-05","2019-08-05")
Query ND010202(wardId As %String, startDate As %String = "", endDate As %String = "") As DtPortal.Query(ROWSPEC = "BedCode:%String,Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,Diag:%String,firstInWardDesc:%String,secInWardDesc:%String,currWardDesc:%String,tranTime")
{
}

ClassMethod ND010202Execute(ByRef qHandle As %Binary, wardId As %String, startDate As %String = "", endDate As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	q:(startDate="")||(endDate="") $$$OK
	set:startDate["-" startDate=$zdh(startDate,3)
	set:endDate["-" endDate=$zdh(endDate,3)
	
	
	//找出有转科记录的病人 就诊ID，存入数组中-----用于相同的PAADM只取一次
	for Date=startDate:1:endDate {
		s TRANSStartTime=""
		f  s TRANSStartTime=$o(^PAADMi("TransDateTime",Date,TRANSStartTime)) q:TRANSStartTime=""  d
		.s PAAdm=""
		.f  s PAAdm=$o(^PAADMi("TransDateTime",Date,TRANSStartTime,PAAdm)) q:PAAdm=""  d
		..s paadmType=$P($g(^PAADM(PAAdm)),"^",2)
		..q:paadmType'="I"
		..s PaadmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
		..q:PaadmVisitStatus'="A"   //出院病人退出---非在院病人
		..s FindTodayTransferInfo($j,PAAdm)=1	//把有转科的病人存入数组中，用于一个就诊号只存一次
	}
	
	s PAAdm="" 
	for{
		s PAAdm=$o(FindTodayTransferInfo($j,PAAdm))
		q:PAAdm=""
		
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	
		
		s currWardId=$p(^PAADM(PAAdm),"^",70)
		s currWardDesc=$p(^PAWARD(currWardId),"^",2)
		i currWardDesc["-" s currWardDesc=$p(currWardDesc,"-",2)
		s BedCode=$p(patInfoStr,"^",1)
 		s Name=$p(patInfoStr,"^",2)
 		s Sex=$p(patInfoStr,"^",3)
 		s Age=$p(patInfoStr,"^",4)
 		s MedicareNo=$p(patInfoStr,"^",5)   //病案号
 		s AdmReason=$p(patInfoStr,"^",6)    //费用类型
 		s Diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm) //取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
		
		s numPaadm=1
		s locs=##class(DtPortal.ND.ND01.ND0102TransferList).getPatLocs(PAAdm)
		s count=locs.Count()
		continue:count=1
		f i=1:1:count d
		.s loc= locs.GetAt(i)
		.s no=loc.GetAt("No")
		.q:no=0   //第二条算转科数据
		.s stDate=loc.GetAt("StartDate")
		.q:(stDate<startDate)||(stDate>endDate)
		.s secInWardId=loc.GetAt("WardId")
		.q:wardId'=secInWardId
		.s lastLoc=locs.GetAt(i-1)
		.s firstInWardDesc = lastLoc.GetAt("WardDesc")
		.s secInWardDesc=loc.GetAt("WardDesc")
		.s tranTime=$zd(stDate,3)_"&nbsp;"_$zt(loc.GetAt("StartTime"))
		.d TodayTransferInfo
	}
	
	

  	q $$$OK
TodayTransferInfo
    s Data=$lb(BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,firstInWardDesc,secInWardDesc,currWardDesc,tranTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// w ##class(DtPortal.ND.ND01.ND0102TransferList).getPatLocs(5)
ClassMethod getPatLocs(episodId)
{
	s lastLocId=""
	s locs=##class(%ListOfDataTypes).%New()
	s i=0


	s chl="" f  s chl=$O(^PAADM(episodId,"TRANS",chl)) q:chl=""  d
  	.s locId=$P(^PAADM(episodId,"TRANS",chl),"^",6)
  	.i (locId="")&&(lastLocId'="") d
  	..s wardDesc="",bedCode=""
  	..s wardId=$P(^PAADM(episodId,"TRANS",chl),"^",9)
  	..d getWardBed
	..i wardId'="" d loc.SetAt($g(wardId),"WardId")
    ..d loc.SetAt($g(wardDesc),"WardDesc")
	..d loc.SetAt($g(bedCode),"BedCode")	
  	.q:locId=""
  	.s locDesc=$p(^CTLOC(locId),"^",2)
  	.i locDesc["-" s locDesc=$p(locDesc,"-",2)
  	.q:lastLocId=locId
  	.s startDate=$P(^PAADM(episodId,"TRANS",chl),"^",1)
  	.s startTime=$P(^PAADM(episodId,"TRANS",chl),"^",2)
  	.s endDate=$P(^PAADM(episodId,"TRANS",chl),"^",3)
    .s endTime=$P(^PAADM(episodId,"TRANS",chl),"^",4)
    .i (lastLocId'="") d
  	..d loc.SetAt(startDate,"EndDate")
  	..d loc.SetAt(startTime,"EndTime")
  	..d locs.Insert(loc)
    .s loc=##class(%ArrayOfDataTypes).%New()
    .d loc.SetAt(locId,"LocId")
    .d loc.SetAt(locDesc,"LocDesc")
    .d loc.SetAt(startDate,"StartDate")
    .d loc.SetAt(startTime,"StartTime")
    .d loc.SetAt(i,"No")
    .s i=i+1
    .s lastLocId=locId
    i $g(loc)'="" d
    .d loc.SetAt("","EndDate")
  	.d loc.SetAt("","EndTime")
  	.d locs.Insert(loc)
  	.;d removeSameLoc
	s admType=$p($g(^PAADM(episodId)),"^",2)
	q:(admType="E") ##class(Nur.DoctorOrderSheet).getPatLocsWard(episodId)
	q locs
    //q ##class(Nur.JSON).Encode(locs)
getWardBed
	
	

	i wardId'="" d
	.s wardDesc=$P(^PAWARD(wardId),"^",2)
	.i wardDesc["-" s wardDesc=$P(wardDesc,"-",2)
	.s transSub=chl-1,bedSub=""
	.f  s transSub=$o(^PAADM(episodId,"TRANS",transSub)) q:(transSub="")!(bedCode'="")  d
	..s bedDr = $P(^PAADM(episodId,"TRANS",transSub),"^",8)
	..q:wardId'=+bedDr
	..s bedCode=$p(^PAADM(episodId,"TRANS",transSub),"^",33)
	..i bedCode="" d
	...s bedSub=$p($g(bedDr),"||",2)
	...s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
	
	i loc.GetAt("WardId")'="" {
		s wardId=loc.GetAt("WardId")
		s wardDesc=$P(^PAWARD(wardId),"^",2)
		i wardDesc["-" s wardDesc=$P(wardDesc,"-",2)
	}

	i loc.GetAt("BedCode")'="" {
		s bedCode=loc.GetAt("BedCode")
	}
	
	
	/*
	i wardId'="" d
	.s wardDesc=$P(^PAWARD(wardId),"^",2)
	.i wardDesc["-" s wardDesc=$P(wardDesc,"-",2)
	.s transSub="",bedSub=""
	.b
	.f  s transSub=$o(^PAADM(episodId,"TRANS",transSub),-1) q:(transSub="")!(bedSub'="")  d
	..s bedDr = $P(^PAADM(episodId,"TRANS",transSub),"^",8)
	..q:wardId'=+bedDr
	..s bedCode=$p(^PAADM(episodId,"TRANS",transSub),"^",33)
	..i bedCode="" d
	...s bedSub=$p($g(bedDr),"||",2)
	...s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)	
	*/
	q
}

}
