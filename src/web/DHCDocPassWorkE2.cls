/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 医生站交班本新版操作类
Class web.DHCDocPassWorkE2 Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/**
	跨日标志：
		0：不跨日
		1：单跨明天
		2：横跨今天和明天
	业务Global：
		^BS.OPDoc.PW
		^BS.OPDoc.PW(LocId,"DeathNum",AdmRowID,$ZD(PatAdmDate,3),DeathNum)=""
		^BS.OPDoc.PW(LocId,PatWorkType,PatAdmRowId,FindDate,PatPassSeq)="1"
**/
/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 查询交班病人基本信息
/// IN  : LocId、FindDate、UserId、FindPatWorkType、FindPatNo、FindBCType
/// OUT :
/// TABL: 
/// d ##class(%ResultSet).RunQuery("web.DHCDocPassWorkE2","FindPassWorkPatList",95,"2019-05-28","","","","M","",0)
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPassWorkE2","FindPassWorkPatList","95","2019-05-22","","","","D","",0)
Query FindPassWorkPatList(LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", FindWard = "", PrevFlag = "") As %Query(ROWSPEC = "PatientID,EpisodeID,PatWorkType,PatNo,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,DDPWDRowID,BCRemarkUserID,BCRemarkUser,AdmDocDesc,PatWorkTypeDesc,BCItemId,fillFlag,TplURL,PatWardDesc,PatWard")
{
}

ClassMethod FindPassWorkPatListExecute(ByRef qHandle As %Binary, LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", FindWard = "", PrevFlag = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ProcedureNum=$i(^BS.DOC.Pilot.TEMPDATA)
	s ^TEMP("qp","FindPassWorkPatList2")=ProcedureNum_","_LocId_","_FindDate_","_UserId_","_FindPatWorkType_","_FindPatNo_","_FindBCType_","_FindWard_","_PrevFlag
	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	i UserId'="" s USERCareID=$P(^SSU("SSUSR",UserId),"^",14)
    e  s USERCareID=""
	i UserId="" s UserId=%session.Data("LOGON.USERID")	//10209
	i FindDate="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i FindBCType="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	
	s FindBCInfo=..GetBCInfoByCode(FindBCType)
	s WORKST=$P(FindBCInfo,"^",3)
	s WORKET=$P(FindBCInfo,"^",4)
	s WORKNextDay=$P(FindBCInfo,"^",5)
	s WORKSeqno=$P(FindBCInfo,"^",6)
	
	s FindType=FindBCType
	s FindDate=..%ZDH(FindDate)
	i (FindDate>(+$h)) s qHandle=$lb(0,repid,0) Quit $$$OK
	s MNode = "M-"_UserId_"-"_FindDate_"-"_FindBCType
	k ^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum)
	s ComPareDate=FindDate
	//是否已经保存过
	s FindPWId=$o(^DDPW(0,"LocDateType",LocId,FindDate,FindBCType,0))
	
	//i (('$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum))&&(ComPareDate>(CurDate-1)))||(FindPWId="")) {
	i ((FindPWId="")&&(ComPareDate>(CurDate-1))) {
		;隔日标志为2，将结束时间变为86399
		;隔日标志为1，例如2月14号的四班为：次日的02:00 ~ 05:00，则将开始时间变为0，结束时间变为86399
		;隔日标志为0，不做改动
		s StartDate=FindDate
		s EndDate=FindDate
		s StartTime=WORKST
		s EndTime=WORKET
		i WORKNextDay=2 s EndTime=86399
		i WORKNextDay=1 s EndTime=86399,StartTime=0
		d ..GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId,ProcedureNum,MNode)
		
	} else {
		//已存在的记录
		s ProcedureNum="QryHistory"
	}
	s ^TEMP("qp","FindPassWorkPatList2","ProcedureNum")=MNode_": "_ProcedureNum
	i '$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum)) s qHandle=$lb(0,repid,0) Quit $$$OK
	//m ^TEMPDOCDATA(ProcedureNum)=^BS.OPDoc.PW(LocId,MNode)
	s PrevAdmidArr=##class(web.DHCDocPassWorkC1).GetPrevBCHasFillPatient(FindBCType,FindDate,LocId)
	s NoDisplayWorkType=$p($g(^CF.OPDoc.PW("GZ","NoDisplay")),$C(1),1)
	s WorkType=0 f  s WorkType=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType)) q:WorkType=""  d
	.q:(FindPatWorkType="")&&(NoDisplayWorkType'="")&&(..InArray(NoDisplayWorkType,WorkType)=1)
	.q:(FindPatWorkType'=WorkType)&&(FindPatWorkType'="")
	.s AdmRowId=0 f  s AdmRowId=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId)) q:AdmRowId=""  d
	..q:(PrevFlag=1)&&(..InArray(PrevAdmidArr,AdmRowId)'=1)
	..s AdmDate=0 f  s AdmDate=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId,AdmDate)) q:AdmDate=""  d
	...s PassSeq=0 f  s PassSeq=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId,AdmDate,PassSeq)) q:PassSeq=""  d
	....s CheckFlag=$g(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId,AdmDate,PassSeq))
	....s PatInfo=##class(web.DHCDocPassWork).GetPatInfo(AdmRowId)
	....s PatientID=$p(PatInfo,"^",1)
	....s EpisodeID=AdmRowId
	....s AdmDocId=$p(^PAADM(EpisodeID),"^",9)
	....s PatWard=$p(^PAADM(EpisodeID),"^",70)
	....i PatWard'="" s PatWard=$p(^PAWARD(PatWard),"^",5)
	....q:(FindWard'="")&&(FindWard'=PatWard)
	....i PatWard'="" s PatWardDesc=$p(^CTLOC(PatWard),"^",2)
	....;s ^TEMP("DOCPW","web.DHCDocPassWorkC1",MNode,PatWard)=PatWardDesc
	....s AdmDocDesc=""
	....i AdmDocId'="" s AdmDocDesc=$p(^CTPCP(AdmDocId,1),"^",2)
	....q:(USERCareID'="")&&(AdmDocId'=USERCareID)
	....s PatWorkType=WorkType
	....s PatWorkTypeDesc=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",1)
	....s isNeedDisplay=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",2)
	....s TplURL=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",4)
	....q:isNeedDisplay'=1
	....s PatNo=$p(PatInfo,"^",2)
	....q:(FindPatNo'="")&&(PatNo'=FindPatNo)
	....s PatName=$p(PatInfo,"^",3)
	....s PatSex=$p(PatInfo,"^",4)
	....s PatAge=$p(PatInfo,"^",5)
	....s PatDiagnos=$p(PatInfo,"^",9)
	....s PatOperName=##class(web.DHCDocPassWorkC1).GetOperNameByAdmid(EpisodeID)
	....s PatMedicareNo=$p(PatInfo,"^",6)
	....s CurBedCode=$p(PatInfo,"^",14)
	....s DDPWDRowID="",BCItemId="",BCRemarkUserID="",BCRemarkUser="",BCRemark=""
	....s SearchDate=FindDate	;$zdh(FindDate,4)
	....s DDPWDRowID="",fillFlag=0
	....s PatPWRowID=0 f  s PatPWRowID=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID)) q:PatPWRowID=""  d
	.....s PatPWSub=0 f  s PatPWSub=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID,PatPWSub)) q:PatPWSub=""  d
	......s MainWorkType=$p($g(^DDPW(PatPWRowID)),"^",4)	;班次
	......s ItemWorkType=$p(^DDPW(PatPWRowID,"Detail",PatPWSub),"^",1)
	......q:ItemWorkType'=WorkType
	......q:MainWorkType'=FindBCType
	......s MainInsertUser=""
	......s MainInsertUserDr=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",8)
	......i MainInsertUserDr'="" s MainInsertUser=$p($g(^SSU("SSUSR",MainInsertUserDr)),"^",2)
	......s BCRemark=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",5)
	......i BCRemark'="" s fillFlag=1
	......e  s fillFlag=2
	......s BCRemarkUserID=MainInsertUserDr
	......s BCRemarkUser=MainInsertUser
	......s BCItemId=PatPWRowID_"||"_PatPWSub
	......s DDPWDRowID=PatPWRowID_"||"_PatPWSub	
	....d OrderCount	//OutputRow1
	
	d OrderOuput
	k ^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum)
	if (ProcedureNum'="QryHistory") {
		k ^BS.OPDoc.PW(LocId,MNode,ProcedureNum)
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OrderCount
	s Data=$lb(PatientID,EpisodeID,PatWorkType,PatNo,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,DDPWDRowID,BCRemarkUserID,BCRemarkUser,AdmDocDesc,PatWorkTypeDesc,BCItemId,fillFlag,TplURL,PatWardDesc,PatWard)
	s disNo=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",3)
	i disNo="" s disNo="999"
	s ^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum,disNo,PatWorkType,EpisodeID)=Data
	
	quit
OrderOuput
	s disNo=""
	f  s disNo=$o(^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum,disNo)) q:disNo=""  d
	.s PatWorkType=""
	.f  s PatWorkType=$o(^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum,disNo,PatWorkType)) q:PatWorkType=""  d
	..s EpisodeID=""
	..f  s EpisodeID=$o(^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum,disNo,PatWorkType,EpisodeID)) q:EpisodeID=""  d
	...s outData=$g(^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum,disNo,PatWorkType,EpisodeID))
	...d OrderOuputRow
	
	quit
	
OrderOuputRow
	Set ^CacheTemp(repid,ind)=outData
	Set ind=ind+1
	quit
OutputRow1
	set Data=$lb(PatientID,EpisodeID,PatWorkType,PatNo,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,DDPWDRowID,BCRemarkUserID,BCRemarkUser,AdmDocDesc,PatWorkTypeDesc,BCItemId,fillFlag,TplURL)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindPassWorkPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPassWorkPatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPassWorkPatListClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPassWorkPatListFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 获取科室交班-汇总数据
/// IN  : Para		->		科室ID^日期^用户ID
/// /	  FindType	->		班次类型
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetPWSummary("110^2019-02-14^4634","D")
ClassMethod GetPWSummary(Para As %String, FindType As %String = "") As %String
{
	Q:(Para="")||(FindType="") ""
	
	//code_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_seqno
	s ProcedureNum="QryHistory"		//$i(^BS.DOC.Pilot.TEMPDATA)
	s FindBCInfo=..GetBCInfoByCode(FindType)
	s WORKST=$P(FindBCInfo,"^",3)
	s WORKET=$P(FindBCInfo,"^",4)
	s WORKNextDay=$P(FindBCInfo,"^",5)
	s WORKSeqno=$P(FindBCInfo,"^",6)
	
	s LocId=$p(Para,"^",1)
	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	s FindDate=$p(Para,"^",2)
	s UserId=$p(Para,"^",3)
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s FindDate=..%ZDH(FindDate)
	s SelectDate=FindDate
	s MNode = "M-"_UserId_"-"_FindDate_"-"_FindType
	
	//k ^BS.OPDoc.PW(LocId) 
	;新版不用在去判断：凌晨查询的夜班应该是昨天的夜班
	;因为在查询的时候，页面上的标签已经明确了查询的是哪天的班次
	s (PreSum,NowSum,OutHospNum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,Note,PWId)=""
	;如果日期为昨天/当天，并且没有保存班次时，则进入实时查询模式。
	;为什么要取到昨天：是因为有些班次是到次日的。
	if (SelectDate>(CurDate-1))&&('$d(^DDPW(0,"LocDateType",LocId,FindDate,FindType))){
		;隔日标志为2，将结束时间变为86399
		;隔日标志为1，例如2月14号的四班为：次日的02:00 ~ 05:00，则将开始时间变为0，结束时间变为86399
		;隔日标志为0，不做改动
		s StartDate=FindDate
		s EndDate=FindDate
		s StartTime=WORKST
		s EndTime=WORKET
		i WORKNextDay=2 s EndTime=86399
		i WORKNextDay=1 s EndTime=86399,StartTime=0
		d BCWork
	}else{
		;查询以前保存的记录
		k ^BS.OPDoc.PW(LocId,MNode,ProcedureNum)
		s DDPWRowID=0 f  s DDPWRowID=$o(^DDPW(0,"LocDate",LocId,FindDate,DDPWRowID)) q:DDPWRowID=""  d
		.s WorkType=$p($g(^DDPW(DDPWRowID)),"^",4)	;班次代码
		.q:WorkType'=FindType
		.s xmlStr=$p($g(^DDPW(DDPWRowID)),"^",5)
		.s PWObj=##class(web.DHCDocPassWork).%New()
		.d PWObj.XMLNodeDeserialize(.PWObj,"PW",xmlStr)
		.s recNoete=$p($g(^DDPW(DDPWRowID)),"^",8)
		.s PreSum=PWObj.PreSum
		.s NowSum=PWObj.NowSum
		.s OutHospNum=PWObj.OutHospNum
		.s InHospNum=PWObj.InHospNum
		.s OutWardNum=PWObj.OutWardNum
		.s InWardNum=PWObj.InWardNum
		.s OperNum=PWObj.OperNum
		.s SeverityNum=PWObj.SeverityNum
		.s CritiNum=PWObj.CritiNum
		.s DeathNum=PWObj.DeathNum
		.s Note=recNoete
		.s PWId=DDPWRowID
		.;构建明细索引
		.s DDPWUserId=$p($g(^DDPW(DDPWRowID)),"^",3)
		.s PatPassSeq=0
		.s DDPWSub=0 f  s DDPWSub=$o(^DDPW(DDPWRowID,"Detail",DDPWSub)) q:DDPWSub=""  d
		..s PatWorkType=$p($g(^DDPW(DDPWRowID,"Detail",DDPWSub)),"^",1)	;病人类型
		..q:PatWorkType=""
		..s PatAdmRowId=$p($g(^DDPW(DDPWRowID,"Detail",DDPWSub)),"^",2)
		..s PatPassSeq=PatPassSeq+1
		..s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,PatWorkType,PatAdmRowId,FindDate,PatPassSeq)="1"
	}
	
	s mData("PreSum")=PreSum
	s mData("NowSum")=NowSum
	s mData("OutHospNum")=OutHospNum
	s mData("InHospNum")=InHospNum
	s mData("OutWardNum")=OutWardNum
	
	s mData("InWardNum")=InWardNum
	s mData("OperNum")=OperNum
	s mData("SeverityNum")=SeverityNum
	s mData("CritiNum")=CritiNum
	s mData("DeathNum")=DeathNum
	
	s mData("Note")=Note
	s mData("PWId")=PWId
	s clsInfo=##class(web.DHCDocPassWork).GetClassPropertyList("web.DHCDocPassWork")
	
	s mRtn="[{"
		s Len=$l(clsInfo,"^")
		f i=1:1:Len {
			s mCode=$p(clsInfo,"^",i)
			i i=1 s mRtn=mRtn_""""_mCode_""":"""_mData(mCode)_""""
			e  s mRtn=mRtn_","""_mCode_""":"""_mData(mCode)_""""
		}
	s mRtn=mRtn_"}]"
	Q mRtn
	/*
	s retStr="["
	s retStr=retStr_"{""PreSum"":"""_PreSum_""",""NowSum"":"""_NowSum_""""
	s retStr=retStr_",""OutHospNum"":"""_OutHospNum_""",""birthday"":"""_(..EvalJSON(birthday))_""""
	s retStr=retStr_",""admDate"":"""_(..EvalJSON(admDate))_""",""admLoc"":"""_(..EvalJSON(admLoc))_"""}"
	s retStr="]"
	
	s retStr=PreSum_"^"_NowSum_"^"_OutHospNum_"^"_InHospNum_"^"_OutWardNum_"^"_InWardNum_"^"_OperNum_"^"_SeverityNum_"^"_CritiNum_"^"_DeathNum_"^"_Note_"^"_PWId
	
	q retStr
	*/
BCWork
	s retShiftStr=..GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId,"",MNode)
	s PreSum=$p(retShiftStr,"^",1)
	s NowSum=$p(retShiftStr,"^",2)
	s OutHospNum=$p(retShiftStr,"^",3)
	s InHospNum=$p(retShiftStr,"^",4)
	s OutWardNum=$p(retShiftStr,"^",5)
	s InWardNum=$p(retShiftStr,"^",6)
	s OperNum=$p(retShiftStr,"^",7)
	s SeverityNum=$p(retShiftStr,"^",8)
	s CritiNum=$p(retShiftStr,"^",9)
	s DeathNum=$p(retShiftStr,"^",10)
	
	q
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 获取实时数据
/// IN  : 
/// OUT : 原有"^"现有"^"出院"^"入院"^"转出"^"转入"^"手术"^"病危"^"病重"^"死亡
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetLocItemSummary("2017-05-01","2017-05-01","0:00","23:00",110,4634)
ClassMethod GetLocItemSummary(StartDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, LocId As %String, UserId As %String, ProcedureNum As %String = "", MNode As %String = "") As %String
{
	s ^TEMP("GetLocItemSummary",1)=$lB(StartDate,EndDate,StartTime,EndTime,LocId,UserId,ProcedureNum)
 	q:(StartDate="")&&(EndDate="")&&(LocId="") ""
 	i ProcedureNum="" s ProcedureNum="DBSave"
 	//i MNode="" s MNode = "M-"_UserId_"-"_StartDate_"-"_FindBCType
 	k ^BS.OPDoc.PW(LocId,MNode,ProcedureNum)
 	i StartDate="" s startDate=..%SysDate()
 	e  s StartDate=..%ZDH(StartDate)
 	i EndDate="" s EndDate=..%SysDate()
 	e  s EndDate=..%ZDH(EndDate)
 	;最多查询一个周内数据,以结束日期为准
 	i (EndDate-StartDate)>7 s StartDate=EndDate-7
 	i StartTime="" s StartTime=0
 	i EndTime="" s EndTime=86399	;23:59:59
 	i UserId="" s UserId=%session.Data("LOGON.USERID")
	s StartDateTime=##class(web.DHCDocPassWork).GetAbsTime(StartDate_","_StartTime)
	s EndDateTime=##class(web.DHCDocPassWork).GetAbsTime(EndDate_","_EndTime)
	;
	s (PreSum,NowSum,OutHospNum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum)=0
	;转入转出
	f AdmDate=StartDate:1:EndDate d
    .s AdmRowID="" f  s AdmRowID=$o(^PAADMi("TransEndDate",AdmDate,AdmRowID)) q:AdmRowID=""  d
    ..s transIndex=0,PreLoc=""
    ..k temp
    ..s ChildSub="" 
    ..;f  s ChildSub=$O(^PAADMi("TransEndDate",AdmDate,AdmRowID,ChildSub),-1) q:(ChildSub="")!(transIndex>2)  d
    ..f  s ChildSub=$o(^PAADM(AdmRowID,"TRANS",ChildSub),-1)  q:(ChildSub="")!(transIndex>2)  d
    ...q:ChildSub=0
    ...s loc=$P(^PAADM(AdmRowID,"TRANS",ChildSub),"^",6)
  	...q:loc=""
	...s transStDate=$P($G(^PAADM(AdmRowID,"TRANS",ChildSub)),"^",1)
  	...s transStTime=$P($G(^PAADM(AdmRowID,"TRANS",ChildSub)),"^",2)
  	...s transEndDate=$P($G(^PAADM(AdmRowID,"TRANS",ChildSub)),"^",3)
    ...s transEndTime=$P($G(^PAADM(AdmRowID,"TRANS",ChildSub)),"^",4)
    ...i loc'=PreLoc d
    ....s transIndex=transIndex+1
    ....s temp(transIndex,AdmRowID,loc)=((transStDate*86400)+transStTime)_"^"_((transEndDate*86400)+transEndTime)_"^"_transStDate_"^"_transStTime_"^"_transEndDate_"^"_transEndTime
    ....s PreLoc=loc
	..;转入	转科记录有两条且最后一条是当前科室的
	..i $d(temp(2,AdmRowID))>0,$g(temp(1,AdmRowID,LocId))'="" d
	...s transDateTime=$p($g(temp(1,AdmRowID,LocId)),"^",1)
	...s transStDate=$p($g(temp(1,AdmRowID,LocId)),"^",3)
    ...i (transDateTime>=StartDateTime)&&(transDateTime<EndDateTime) d
    ....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"InWardNum",AdmRowID))	;6转入
    ....s InWardNum=InWardNum+1
    ....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"InWardNum",AdmRowID,$ZD(transStDate,3),InWardNum)=""
    ..;转出	转科记录倒数第二条是之前科室的，且应该判断倒数第一条得科室得时间是否在今天
    ..i $g(temp(2,AdmRowID,LocId))'="" d
    ...s firstLocid=$o(temp(1,AdmRowID,""))
    ...s transDateTime=$p($g(temp(1,AdmRowID,firstLocid)),"^",1)
    ...s transEndDate=$p($g(temp(1,AdmRowID,firstLocid)),"^",3)
    ...i (transDateTime>=StartDateTime)&&(transDateTime<EndDateTime) d
	....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"OutWardNum",AdmRowID))	;5转出
	....s OutWardNum=OutWardNum+1
    ....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"OutWardNum",AdmRowID,$ZD(transEndDate,3),OutWardNum)=""
    ;------------------------------------------------------------------------
    s AdmDate=0 f  s AdmDate=$o(^PAADMi("TDepDateTime","I",LocId,AdmDate)) q:AdmDate=""  d
 	.s AdmTime=0 f  s AdmTime=$o(^PAADMi("TDepDateTime","I",LocId,AdmDate,AdmTime)) q:AdmTime=""  d
	..s AdmRowID=0 f  s AdmRowID=$o(^PAADMi("TDepDateTime","I",LocId,AdmDate,AdmTime,AdmRowID)) q:AdmRowID=""  d
	...s VisitStatus=$p($g(^PAADM(AdmRowID)),"^",20)
	...;出院
	...i VisitStatus="D" d
	....s DisDate=$p($g(^PAADM(AdmRowID)),"^",17)
    ....s DisTime=$p($g(^PAADM(AdmRowID)),"^",18)
	....s DisDateTime=##class(web.DHCDocPassWork).GetAbsTime(DisDate_","_DisTime)
    ....i (DisDateTime>StartDateTime)&&(DisDateTime<EndDateTime) d
	.....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"OutHospNum",AdmRowID))	;3出院
	.....s OutHospNum=OutHospNum+1
    .....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"OutHospNum",AdmRowID,$zd(DisDate,3),OutHospNum)=""
 	...q:VisitStatus'="A"	;不计算C状态
 	...s NowSum=NowSum+1
	...;入院
	...s AdmDateTime=##class(web.DHCDocPassWork).GetAbsTime(AdmDate_","_AdmTime)
    ...i (AdmDateTime>=StartDateTime)&&(AdmDateTime<EndDateTime) d
    ....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"InHospNum",AdmRowID))	;4入院
    ....s InHospNum=InHospNum+1
    ....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"InHospNum",AdmRowID,$zd(AdmDate,3),InHospNum)=""
	...f PatAdmDate=StartDate:1:EndDate d
	....;病危
	....s BWCode=$p(^CF.OPDoc.PW("GZ","BWCode"),$C(1),1)
    ....;s SeverityNumFlag=##class(web.DHCDocPassWork).IfExistOrder(PatAdmDate,AdmRowID,BWCode,StartTime,EndTime)
    ....s SeverityNumFlag=##class(web.DHCDocPassWorkC1).IsCriticallyIll(AdmRowID)
    ....;s ^TEMP("DHCANT","QP",AdmRowID)=SeverityNumFlag
    ....i SeverityNumFlag=1 d
    .....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"SeverityNum",AdmRowID))	;8病危
    .....s SeverityNum=SeverityNum+1
    .....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"SeverityNum",AdmRowID,$ZD(PatAdmDate,3),SeverityNum)=""
	....;病重
	....s BZCode=$p(^CF.OPDoc.PW("GZ","BZCode"),$C(1),1)
    ....;s CritiNumFlag=##class(web.DHCDocPassWork).IfExistOrder(PatAdmDate,AdmRowID,BZCode,StartTime,EndTime)
    ....s CritiNumFlag=##class(web.DHCDocPassWorkC1).IsSeriouslyIll(AdmRowID)
    ....i CritiNumFlag=1 d
    .....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"CritiNum",AdmRowID))	;9病重
    .....s CritiNum=CritiNum+1
    .....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"CritiNum",AdmRowID,$ZD(PatAdmDate,3),CritiNum)=""
    ....;手术
    ....s SSCode=$p(^CF.OPDoc.PW("GZ","SSCode"),$C(1),1)
    ....s OperNumFlag=##class(web.DHCDocPassWork).IfExistOrder(PatAdmDate,AdmRowID,SSCode,StartTime,EndTime)
    ....i OperNumFlag=1 d
    .....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"OperNum",AdmRowID))	;7手术
    .....s OperNum=OperNum+1
    .....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"OperNum",AdmRowID,$ZD(PatAdmDate,3),OperNum)=""
    ....;死亡
    ....s patientDr=$p(^PAADM(AdmRowID),"^",1)
    ....s IsDeceased=##Class(web.PAPerson).CheckDeceased(patientDr)
    ....i IsDeceased="Y" d
	.....q:$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"DeathNum",AdmRowID))	;10死亡
	.....s DeathNum=DeathNum+1
	.....s NowSum=NowSum-1
	.....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"DeathNum",AdmRowID,$ZD(PatAdmDate,3),DeathNum)=""
	...;现有
	...s ExistStatusFlag=##class(web.DHCDocPassWork).CheckExistStatus(LocId,"InWardNum^OutWardNum^InHospNum^SeverityNum^CritiNum^OperNum^DeathNum",AdmRowID)	//转入^转出^入院^病危^病重^手术^死亡
	...i ExistStatusFlag="N" d
	....s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"NowSum",AdmRowID,$ZD(PatAdmDate,3),NowSum)=""	;2现有
	;原有=现有+死亡+转出+出院-转入-新入
	d ##class(web.DHCDocPassWork).SetPreSumGlobal(StartDate,EndDate,LocId,ProcedureNum,MNode)
	s PreSum=NowSum+DeathNum+OutWardNum+OutHospNum-InWardNum-InHospNum
	q PreSum_"^"_NowSum_"^"_OutHospNum_"^"_InHospNum_"^"_OutWardNum_"^"_InWardNum_"^"_OperNum_"^"_SeverityNum_"^"_CritiNum_"^"_DeathNum
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 初始化汇总表格
/// IN  : 日期
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).InitSummaryTable()
ClassMethod InitSummaryTable() As %String
{
	s mRtn="",noDisRtn=""
	
	k ^TEMP("DHCDoc.DHCDocConfig.PassWork",$j)
	s code="",TotalLen=0,disLen=0,prefix="d"
	f  s code=$o(^CF.OPDoc.PW("WKType",code)) q:code=""  d
	.s desc=$p(^CF.OPDoc.PW("WKType",code),"^",1)
	.s isDisplay=$p(^CF.OPDoc.PW("WKType",code),"^",2)
	.s disNo=$p(^CF.OPDoc.PW("WKType",code),"^",3)
	.i disNo="" s disNo="999"
	.i isDisplay=1 s disLen=disLen+1
	.s TotalLen=TotalLen+1
	.s ^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)=$lb(code,desc,isDisplay,disNo)
	Q:disLen=0 mRtn
	
	s disNo="",curNo=0,noDisLen=TotalLen-disLen,nodisNum=0
	;s curDisTR=0,curNoDisTR=0
	;s disTRLen=disLen\5,nodisTRLen=noDisLen\5,disMod=disLen#5,nodisMod=noDisLen#5
	;i disMod'=0 s disTRLen=disTRLen+1
	;i nodisMod'=0 s nodisTRLen=nodisTRLen+1
	f  s disNo=$o(^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo)) q:disNo=""  d
	.s code=""
	.f  s code=$o(^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)) q:code=""  d
	..s outdata=^TEMP("DHCDoc.DHCDocConfig.PassWork",$j,disNo,code)
	..s isDisplay=$lg(outdata,3)
	..s text=$lg(outdata,2)
	..s id=prefix_"-"_code
	..s style="display:none;"
	..i isDisplay=1 d 
	...s style="",curNo=curNo+1
	...i (curNo#5=1) s mRtn=mRtn_"<tr>"
	...s td="<td style='"_style_"' class='r-label'><label for='"_id_"'>"_text_"</label></td>"
	...s td2="<td style='"_style_"'><input class='c-num textbox' id='"_id_"'/></td>"
	...s mRtn=mRtn_td_td2
	...i curNo=disLen s mRtn=mRtn_"</tr>"
	...i curNo#5=0 s mRtn=mRtn_"</tr>"
	..e  d
	...s nodisNum=nodisNum+1
	...i (nodisNum#5=1) s noDisRtn=noDisRtn_"<tr style='"_style_"'>"
	...s td="<td class='r-label'><label for='"_id_"'>"_text_"</label></td>"
	...s td2="<td><input class='c-num textbox' id='"_id_"'/></td>"
	...s noDisRtn=noDisRtn_td_td2
	...i nodisNum=noDisLen s noDisRtn=noDisRtn_"</tr>"
	...i nodisNum#5=0 s noDisRtn=noDisRtn_"</tr>"
	
	s mRtn=mRtn_noDisRtn
	s mRtn=mRtn_"<tr>"
	s mRtn=mRtn_"<td class='r-label'><label for='d-Note'>备注</label></td>"
	s mRtn=mRtn_"<td colSpan='5'><input id='d-Note' style='width:98%' class='textbox'  /></td>"
	s mRtn=mRtn_"<td class='r-label'><label for='d-Pwd'>密码</label></td>"
	s mRtn=mRtn_"<td><input id='d-Pwd' type='password' class='c-num textbox' /></td>"
	s mRtn=mRtn_"<td colSpan='2' class='c-r'>"
	s mRtn=mRtn_"<a id='work-d-save'>保存</a>"
	s mRtn=mRtn_"</td></tr>"
					
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 初始化查询标签Title
/// IN  : 日期
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).InitBCLabelTitle("2019-02-15",110)
ClassMethod InitBCLabelTitle(FindDate, LocId) As %String
{
	q:FindDate="" ""
	
	//86399 -- 23:59:59
	s mRtn=""
	s ALLBCArr=""
	s ALLBCInfo=..GetAllBCInfo(FindDate,LocId,.ALLBCArr)
	s BCLen=$l(ALLBCInfo,"!")
	s CBCInfo=..GetCurrentBC()
	s CBCSeqno=$p(CBCInfo,"^",6)
	s SearchDate=..%ZDH(FindDate)
	s Yesterday=..%ZD(SearchDate-1)
	s Tomorrow=..%ZD(SearchDate+1)
	//code_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_seqno
	
	//之前班次
	f i=1:1:(CBCSeqno-1) d
	.s iCode=$p(ALLBCArr(i),"^",1)
	.s iName=$p(ALLBCArr(i),"^",2)
	.s iSTime=$p(ALLBCArr(i),"^",3)
	.s iETime=$p(ALLBCArr(i),"^",4)
	.s iNextDay=$p(ALLBCArr(i),"^",5)
	.s idStr="BT-"_iCode
	.s idStr2="LB-"_iCode
	.i iNextDay=1 d
	..s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_Tomorrow_"</span> "_iName_"</span> "_"（"_Tomorrow_" "_..%ZT(iSTime,2)_" ~ "_..%ZT(iETime,2)_"）</label>"
	.e  i iNextDay=2 d
	..s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_FindDate_"</span> "_iName_"</span> "_"（"_FindDate_" "_..%ZT(iSTime,2)_" ~  次日"_..%ZT(iETime,2)_"）</label>"
	.e  d
	..s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_FindDate_"</span> "_iName_"</span> "_"（"_FindDate_" "_..%ZT(iSTime,2)_" ~ "_..%ZT(iETime,2)_"）</label>"
	.i mRtn="" s mRtn=iTitle
	.e  s mRtn=mRtn_"^"_iTitle
	
	//当前
	s iCode=$p(ALLBCArr(CBCSeqno),"^",1)
	s iName=$p(ALLBCArr(CBCSeqno),"^",2)
	s iSTime=$p(ALLBCArr(CBCSeqno),"^",3)
	s iETime=$p(ALLBCArr(CBCSeqno),"^",4)
	s iNextDay=$p(ALLBCArr(CBCSeqno),"^",5)
	s idStr="BT-"_iCode
	s idStr2="LB-"_iCode
	i iNextDay=1 d
	.s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_Tomorrow_"</span> "_iName_"（"_Tomorrow_" "_..%ZT(iSTime,2)_" ~ "_..%ZT(iETime,2)_"）</label>"
	e  i iNextDay=2 d
	.s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_FindDate_"</span> "_iName_"（"_FindDate_" "_..%ZT(iSTime,2)_" ~  次日"_..%ZT(iETime,2)_"）</label>"
	e  d
	.s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_FindDate_"</span> "_iName_"（"_FindDate_" "_..%ZT(iSTime,2)_" ~ "_..%ZT(iETime,2)_"）</label>"
	i mRtn="" s mRtn=iTitle
	e  s mRtn=mRtn_"^"_iTitle
	
	//后续班次
	f i=(CBCSeqno+1):1:BCLen d
	.s iCode=$p(ALLBCArr(i),"^",1)
	.s iName=$p(ALLBCArr(i),"^",2)
	.s iSTime=$p(ALLBCArr(i),"^",3)
	.s iETime=$p(ALLBCArr(i),"^",4)
	.s iNextDay=$p(ALLBCArr(i),"^",5)
	.s idStr="BT-"_iCode
	.s idStr2="LB-"_iCode
	.i iNextDay=1 d
	..s displayDate=Tomorrow,saveDate=FindDate
	..i SearchDate=..%SysDate()  s displayDate=FindDate,saveDate=Yesterday
	..s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_saveDate_"</span> "_iName_"（"_displayDate_" "_..%ZT(iSTime,2)_" ~ "_..%ZT(iETime,2)_"）</label>"
	.e  i iNextDay=2 d
	..s displayDate=FindDate,saveDate=FindDate
	..i SearchDate=..%SysDate()  s displayDate=Yesterday,saveDate=Yesterday
	..s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_saveDate_"</span> "_iName_"（"_displayDate_" "_..%ZT(iSTime,2)_" ~  次日"_..%ZT(iETime,2)_"）</label>"
	.e  d
	..s displayDate=FindDate,saveDate=FindDate
	..i SearchDate=..%SysDate()  s displayDate=Yesterday,saveDate=Yesterday
	..s iTitle="<label name='"_iName_"' id='"_idStr2_"' class='c-label'><span class='bc-title' id='"_idStr_"'>"_saveDate_"</span> "_iName_"（"_displayDate_" "_..%ZT(iSTime,2)_" ~ "_..%ZT(iETime,2)_"）</label>"
	.i mRtn="" s mRtn=iTitle
	.e  s mRtn=mRtn_"^"_iTitle
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 根据日期和科室，得到所有有效的班次信息
/// IN  : 暂时不做根据每天实际的班次进行查询
/// OUT : 
/// TABL: ^DDPW(0,"BCType","D",1)	=	""
/// 		^DDPW(0,"LocDateType",110,65060,"D",1)	=	""
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetAllBCInfo("2019-02-15",110,.mData)
ClassMethod GetAllBCInfo(FindDate, LocId, data) As %String
{
	s mRtn=""
	s FindDate=..%ZDH(FindDate)
	s bolValue=1
	//s bolValue=(FindDate=..%SysDate())
	//s bolValue=(FindDate=..%SysDate())||('$d(^DDPW(0,"LocDateType",LocId,FindDate))&&(FindDate<+$H))
	if (bolValue=1) {
		s seqno=""
		f  s seqno=$o(^CF.Doc.PWBCI("Seqno",seqno)) q:seqno=""  d
		.s rowid=""
		.f  s rowid=$o(^CF.Doc.PWBCI("Seqno",seqno,rowid)) q:rowid=""  d
		..s active=$p(^CF.Doc.PWBC(rowid),"^",7)
		..q:active'=1
		..s code=$p(^CF.Doc.PWBC(rowid),"^",1)
		..s name=$p(^CF.Doc.PWBC(rowid),"^",2)
		..s sTime=$p(^CF.Doc.PWBC(rowid),"^",3)
		..s eTime=$p(^CF.Doc.PWBC(rowid),"^",4)
		..s nextDay=$p(^CF.Doc.PWBC(rowid),"^",5)
		..s note=$p(^CF.Doc.PWBC(rowid),"^",6)
		..s seqno=$p(^CF.Doc.PWBC(rowid),"^",8)
		..s outdata=code_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_seqno
		..s data(seqno)=outdata
		..i mRtn="" s mRtn=outdata
		..e  s mRtn=mRtn_"!"_outdata
	} else {
		q:'$d(^DDPW(0,"LocDateType",LocId,FindDate)) mRtn
		s BCode=""
		f  s BCode=$o(^DDPW(0,"LocDateType",LocId,FindDate,BCode)) q:BCode=""  d
		.s rowid=$o(^DDPW(0,"LocDateType",LocId,FindDate,BCode,""))
		.q:rowid=""
		.s name=$p(^DDPW(rowid),"^",12)
		.s sTime=$p(^DDPW(rowid),"^",13)
		.s eTime=$p(^DDPW(rowid),"^",14)
		.s nextDay=$p(^DDPW(rowid),"^",15)
		.s seqno=$p(^DDPW(rowid),"^",16)
		.s outdata=BCode_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_seqno
		.s data(seqno)=outdata
		.i mRtn="" s mRtn=outdata
		.e  s mRtn=mRtn_"!"_outdata
	} 
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 修改病人类型
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.DHCDocPassWorkE2).UpdatePatWorkType("PreSum","25||72")
ClassMethod UpdatePatWorkType(PatWorkType, BCItemId) As %String
{
	q:(PatWorkType="")||(BCItemId="") -101
	s ^TEMP("UpdatePatWorkType")=$lb(PatWorkType, BCItemId)
	s pwid=+BCItemId,sub=$p(BCItemId,"||",2)
	s admid=$P(^DDPW(pwid,"Detail",sub),"^",2)
	s locid=$P(^DDPW(pwid,"Detail",sub),"^",3)
	s pwdate=$P(^DDPW(pwid,"Detail",sub),"^",4)
	
	s oldNode=$P(^DDPW(pwid,"Detail",sub),"^",1)
	Q:($D(^DDPW(0,"AdmLocTypeDate",admid,locid,PatWorkType,pwdate))) -111
	
	//更改统计值
	s rtn=##class(web.DHCDocPassWorkF1).UpdatePWXML(PatWorkType,pwid,"Edit",oldNode)
	Q:rtn'=0 rtn
	&SQL(Update SQLUser.DHC_DocPassWorkDetail set DDPWD_WorkType=:PatWorkType where DDPWD_RowId=:BCItemId)

	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 得到当前时间上一班次的所属信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetPrevBCInfo(110,154,"6||1")
ClassMethod GetPrevBCInfo(LocId, Admid, inItemid) As %String
{
	s ^TEMP("GetPrevBCInfo",1)=LocId_","_Admid_","_inItemid
	s mRtn = "" ,ErrRtn = ""
	q:(LocId="")||(Admid="")||(inItemid="") ErrRtn
	s CurrentDate = +$h
	s CPwid=+inItemid
	q:CPwid="" ErrRtn
	b ;001
	//s CurrentBCInfo = ..GetCurrentBC()
	s CurrentSeqno = $p(^DDPW(CPwid),"^",16)				//$p(CurrentBCInfo,"^",6)
	s CurrentBCode = $p(^DDPW(CPwid),"^",4)					//$p(CurrentBCInfo,"^",1)
	s PrevDate = $p(^DDPW(CPwid),"^",2)		//CurrentDate
	s PrevSeqno = $o(^CF.Doc.PWBCI("Seqno",CurrentSeqno),-1)
	i PrevSeqno = "" s PrevSeqno = $o(^CF.Doc.PWBCI("Seqno",""),-1),PrevDate=PrevDate-1
	s PrevBCId = $o(^CF.Doc.PWBCI("Seqno",PrevSeqno,""))
	q:PrevBCId="" ErrRtn
	s PrevBCode = $p(^CF.Doc.PWBC(PrevBCId),"^",1)
	s Pwid = $o(^DDPW(0,"LocDateType",LocId,PrevDate,PrevBCode,""))
	q:Pwid="" ErrRtn
	s BCName = $p(^DDPW(Pwid),"^",12)_"("_..%ZD(PrevDate)_")"
	s Itemid = "", mRtn = "[", Count = 0
	f  s Itemid = $o(^DDPW(0,"AdmLocDate",Admid,LocId,PrevDate,Pwid,Itemid)) q:Itemid=""  d
	.s itemType = $p(^DDPW(Pwid,"Detail",Itemid),"^",1)
	.s isNeedDisplay = $p(^CF.OPDoc.PW("WKType",itemType),"^",2)
	.q:isNeedDisplay'=1
	.s itemPatType = $p(^CF.OPDoc.PW("WKType",itemType),"^",1)
	.s itemBCUser = $p(^DDPW(Pwid,"Detail",Itemid),"^",8)
	.s itemBContent = $p(^DDPW(Pwid,"Detail",Itemid),"^",5)
	.;s itemBContent = ##class(web.DHCDocPassWork).FilterValue(itemBContent)
	.s itemBContent = ##class(web.DHCDocPassWorkC1).ShowContentHtml(itemBContent)
	.s itemBCDT = ""
	.i itemBContent'="" d 
	..s itemBCUser = $p(^DDPW(Pwid,"Detail",Itemid),"^",11)
	..s itemBCDate = $p(^DDPW(Pwid,"Detail",Itemid),"^",9)
	..s itemBCTime = $p(^DDPW(Pwid,"Detail",Itemid),"^",10)
	..s itemBCDT = ..%ZD(itemBCDate)_" "_..%ZT(itemBCTime,2)
	..;想查看所有的，去掉底下的一个点
	..i itemBCUser'="" s itemBCUser = $p(^SSU("SSUSR",itemBCUser),"^",2)
	..s Count = Count + 1
	..s newBCName = BCName_" "_itemPatType
	..s Record = ""
	..s Record = "{""BCName"":"""_newBCName_""",""PatType"":"""_itemPatType_""","
	..s Record = Record_"""BCUser"":"""_itemBCUser_""",""BCDT"":"""_itemBCDT_""","
	..s Record = Record_"""BContent"":"""_itemBContent_"""}"
	..i Count = 1 s mRtn = mRtn_Record
	..e  s mRtn = mRtn_","_Record
	s mRtn = mRtn_"]"
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 得到当前时间所属班次信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetCurrentBC()
ClassMethod GetCurrentBC() As %String
{
	s seqno="",mRtn=""
	s findFlag=0,cTime=..%SysTime()
	f  s seqno=$o(^CF.Doc.PWBCI("Seqno",seqno)) q:seqno=""  d
	.s rowid=""
	.f  s rowid=$o(^CF.Doc.PWBCI("Seqno",seqno,rowid)) q:(rowid="")||(findFlag=1)  d
	..s active=$p(^CF.Doc.PWBC(rowid),"^",7)
	..q:active'=1
	..s code=$p(^CF.Doc.PWBC(rowid),"^",1)
	..s name=$p(^CF.Doc.PWBC(rowid),"^",2)
	..s sTime=$p(^CF.Doc.PWBC(rowid),"^",3)
	..s eTime=$p(^CF.Doc.PWBC(rowid),"^",4)
	..s nextDay=$p(^CF.Doc.PWBC(rowid),"^",5)
	..s seqno=$p(^CF.Doc.PWBC(rowid),"^",8)
	..i nextDay=2 d
	...i (sTime<=cTime)&&(cTime<=86400) s findFlag=1
	...i (0<=cTime)&&(cTime<=eTime) s findFlag=1
	..e  i nextDay=1 d
	...i (0<=cTime)&&(cTime<=eTime) s findFlag=1
	..e  d
	...i (sTime<=cTime)&&(cTime<=eTime) s findFlag=1
	..s mRtn=code_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_seqno
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 得到当前时间所属班次提示
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetCurrentBCTip()
ClassMethod GetCurrentBCTip() As %String
{
	s CBCInfo=..GetCurrentBC()
	s cDate=..%ZD(+$H)
	s displayDate=cDate
	s name=$p(CBCInfo,"^",2)
	s nextDay=$p(CBCInfo,"^",5)
	s sTime=..%ZT($p(CBCInfo,"^",3),2)
	s eTime=..%ZT($p(CBCInfo,"^",4),2)
	i nextDay=1 s displayDate=..%ZD(+$H+1)
	i nextDay=2 s eTime="次日 "_eTime
	s mRtn=cDate_" "_name_"（"_displayDate_" "_sTime_" ~ "_eTime_"）"
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 得到当前时间所属班次的代码
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetCurrentBCCode()
ClassMethod GetCurrentBCCode() As %String
{
	s CBCInfo=..GetCurrentBC()
	s mRtn=$p(CBCInfo,"^",1)
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 根据班次代码得到班次信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetBCInfoByCode("D")
ClassMethod GetBCInfoByCode(BCode) As %String
{
	Q:BCode="" ""
	s rowid=$o(^CF.Doc.PWBCI("BCCode",BCode,""))
	Q:rowid="" ""
	s code=$p(^CF.Doc.PWBC(rowid),"^",1)
	s name=$p(^CF.Doc.PWBC(rowid),"^",2)
	s sTime=$p(^CF.Doc.PWBC(rowid),"^",3)
	s eTime=$p(^CF.Doc.PWBC(rowid),"^",4)
	s nextDay=$p(^CF.Doc.PWBC(rowid),"^",5)
	s active=$p(^CF.Doc.PWBC(rowid),"^",7)
	s seqno=$p(^CF.Doc.PWBC(rowid),"^",8)
	s mRtn=code_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_seqno
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 获取保存班次信息标志
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).HasSaveBCInfo()
ClassMethod InitBCTip(LocId As %String, FindDate As %String, BCode As %String) As %String
{
	s mRtn=""
	s FindDate=..%ZDH(FindDate)
	s bol=(FindDate=..%SysDate())
	i '$d(^DDPW(0,"LocDateType",LocId,FindDate,BCode)) d
	.i bol s mRtn="<label class='c-label c-tip2'>提示：请先保存班次信息！</label>"
	.e  s mRtn="<label class='c-label c-tip2'>提示：当天未保存班次信息，无数据！</label>"
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(web.DHCDocPassWorkE2).InArray("I")
ClassMethod InArray(kssarray As %String, docId As %String) As %String
{
	s rtn=0,data=""
	s multiLen=$l(kssarray,",")
	f len=1:1:multiLen {
		s data=$p(kssarray,",",len)
		q:data="" 
		i data=docId{
			s rtn=1	
			q
		}
		
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 查询班次类型
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("web.DHCDocPassWorkE2","QryPassWorkBC")
Query QryPassWorkBC() As %Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod QryPassWorkBCExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s seqno=""
	f  s seqno=$o(^CF.Doc.PWBCI("Seqno",seqno)) q:seqno=""  d
	.s rowid=""
	.f  s rowid=$o(^CF.Doc.PWBCI("Seqno",seqno,rowid)) q:rowid=""  d
	..s active=$p(^CF.Doc.PWBC(rowid),"^",7)
	..q:active'=1
	..s id=$p(^CF.Doc.PWBC(rowid),"^",1)
	..s desc=$p(^CF.Doc.PWBC(rowid),"^",2)
   	..d OutwardRow
   	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(id,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryPassWorkBCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPassWorkBCExecute ]
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
}

ClassMethod QryPassWorkBCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPassWorkBCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 导出数据
/// IN  : LocId、FindDate、UserId、FindPatWorkType、FindPatNo、FindBCType
/// OUT :
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPassWorkE2","ExportData","95","2019-05-23","10209","","","N","","","","")
Query ExportData(LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", Note As %String = "", XmlData As %String = "", FindWard = "", PrevFlag = "") As %Query(ROWSPEC = "FinallyNum:%String:序号,fillFlag:%String:填写标志,PatWorkTypeDesc:%String:类型,PatNo:%String:登记号,PatName:%String:姓名,PatSex:%String:性别,PatAge:%String:年龄,AdmDocDesc:%String:主管医生,PatDiagnos:%String:诊断,PatOperName:%String:手术,PatMedicareNo:%String:住院号,CurBedCode:%String:床号,BCRemark:%String:交班本信息,BCRemarkUser:%String:更新人")
{
}

ClassMethod ExportDataExecute(ByRef qHandle As %Binary, LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", Note As %String = "", XmlData As %String = "", FindWard = "", PrevFlag = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ProcedureNum=$i(^BS.DOC.Pilot.TEMPDATA)
	S ^TEMP("qp","ExportData2")=LocId_"^"_FindDate_"^"_UserId_"^"_FindPatWorkType_"^"_FindPatNo_"^"_FindBCType
	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	i UserId'="" s USERCareID=$P(^SSU("SSUSR",UserId),"^",14)
    e  s USERCareID=""
	i UserId="" s UserId=%session.Data("LOGON.USERID")
	i FindDate="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i FindBCType="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s FindBCInfo=..GetBCInfoByCode(FindBCType)
	s WORKST=$P(FindBCInfo,"^",3)
	s WORKET=$P(FindBCInfo,"^",4)
	s WORKNextDay=$P(FindBCInfo,"^",5)
	s WORKSeqno=$P(FindBCInfo,"^",6)
	
	s FindType=FindBCType
	s inBCInfo=##class(web.DHCDocPassWorkE2).GetBCInfoByCode(FindBCType)
	s outBCInfo=FindDate_" "_$p(inBCInfo,"^",2)
	s FindDate=..%ZDH(FindDate)
	i (FindDate>(+$h)) s qHandle=$lb(0,repid,0) Quit $$$OK
	s MNode = "M-"_UserId_"-"_FindDate_"-"_FindBCType
	k ^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum)
	s ComPareDate=FindDate
	//是否已经保存过
	s FindPWId=$o(^DDPW(0,"LocDateType",LocId,FindDate,FindBCType,0))
	
	//i ('$d(^BS.OPDoc.PW(LocId,ProcedureNum))&&(ComPareDate>(CurDate-1))) {
	i ((FindPWId="")&&(ComPareDate>(CurDate-1))) {
		;隔日标志为2，将结束时间变为86399
		;隔日标志为1，例如2月14号的四班为：次日的02:00 ~ 05:00，则将开始时间变为0，结束时间变为86399
		;隔日标志为0，不做改动
		s StartDate=FindDate
		s EndDate=FindDate
		s StartTime=WORKST
		s EndTime=WORKET
		i WORKNextDay=2 s EndTime=86399
		i WORKNextDay=1 s EndTime=86399,StartTime=0
		d ..GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId,ProcedureNum,MNode)
		
	}else {
		//已存在的记录
		s ProcedureNum="QryHistory"
	}
	i '$d(^BS.OPDoc.PW(LocId,MNode,ProcedureNum)) s qHandle=$lb(0,repid,0) Quit $$$OK
	
	s FinallyNum=0	//序号
	s PrevAdmidArr=##class(web.DHCDocPassWorkC1).GetPrevBCHasFillPatient(FindBCType,FindDate,LocId)
	s NoDisplayWorkType=$p($g(^CF.OPDoc.PW("GZ","NoDisplay")),$C(1),1)
	s WorkType=0 f  s WorkType=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType)) q:WorkType=""  d
	.q:(FindPatWorkType="")&&(NoDisplayWorkType'="")&&(..InArray(NoDisplayWorkType,WorkType)=1)
	.q:(FindPatWorkType'=WorkType)&&(FindPatWorkType'="")
	.s AdmRowId=0 f  s AdmRowId=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId)) q:AdmRowId=""  d
	..q:(PrevFlag=1)&&(..InArray(PrevAdmidArr,AdmRowId)'=1)
	..s AdmDate=0 f  s AdmDate=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId,AdmDate)) q:AdmDate=""  d
	...s PassSeq=0 f  s PassSeq=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId,AdmDate,PassSeq)) q:PassSeq=""  d
	....s CheckFlag=$g(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,WorkType,AdmRowId,AdmDate,PassSeq))
	....s PatInfo=##class(web.DHCDocPassWork).GetPatInfo(AdmRowId)
	....s PatientID=$p(PatInfo,"^",1)
	....s EpisodeID=AdmRowId
	....s AdmDocId=$p(^PAADM(EpisodeID),"^",9)
	....s PatWard=$p(^PAADM(EpisodeID),"^",70)
	....i PatWard'="" s PatWard=$p(^PAWARD(PatWard),"^",5)
	....q:(FindWard'="")&&(FindWard'=PatWard)
	....i AdmDocId'="" s AdmDocDesc=$p(^CTPCP(AdmDocId,1),"^",2)
	....q:(USERCareID'="")&&(AdmDocId'=USERCareID)
	....s PatWorkType=WorkType
	....s PatWorkTypeDesc=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",1)
	....s isNeedDisplay=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",2)
	....q:isNeedDisplay'=1
	....s PatNo=$p(PatInfo,"^",2)
	....q:(FindPatNo'="")&&(PatNo'=FindPatNo)
	....s PatName=$p(PatInfo,"^",3)
	....s PatSex=$p(PatInfo,"^",4)
	....s PatAge=$p(PatInfo,"^",5)
	....s PatDiagnos=$p(PatInfo,"^",9)
	....s PatOperName=##class(web.DHCDocPassWorkC1).GetOperNameByAdmid(EpisodeID)
	....s PatMedicareNo=$p(PatInfo,"^",6)
	....s CurBedCode=$p(PatInfo,"^",14)
	....s DDPWDRowID="",BCItemId="",BCRemarkUserID="",BCRemarkUser="",BCRemark=""
	....s SearchDate=FindDate	;$zdh(FindDate,4)
	....s DDPWDRowID="",fillFlag=0
	....s PatPWRowID=0 f  s PatPWRowID=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID)) q:PatPWRowID=""  d
	.....s PatPWSub=0 f  s PatPWSub=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID,PatPWSub)) q:PatPWSub=""  d
	......s MainWorkType=$p($g(^DDPW(PatPWRowID)),"^",4)	;班次
	......s ItemWorkType=$p(^DDPW(PatPWRowID,"Detail",PatPWSub),"^",1)
	......q:ItemWorkType'=WorkType
	......q:MainWorkType'=FindBCType
	......s MainInsertUser=""
	......s MainInsertUserDr=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",8)
	......i MainInsertUserDr'="" s MainInsertUser=$p($g(^SSU("SSUSR",MainInsertUserDr)),"^",2)
	......s BCRemark=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",5)
	......i BCRemark'="" s fillFlag=1
	......e  s fillFlag=2
	......s BCRemarkUserID=MainInsertUserDr
	......s BCRemarkUser=MainInsertUser
	......s BCItemId=PatPWRowID_"||"_PatPWSub
	......s DDPWDRowID=PatPWRowID_"||"_PatPWSub	
	....s FinallyNum=FinallyNum+1
	....s BCRemark=##class(web.DHCDocPassWork).FilterValue(BCRemark)
	....s PatDiagnos=##class(web.DHCDocPassWork).FilterValue(PatDiagnos)
	....s PatOperName=##class(web.DHCDocPassWork).FilterValue(PatOperName)
	....i fillFlag=1 s fillFlag="已填写"
	....e  i fillFlag=2 s fillFlag="未填写"
	....e  s fillFlag="未保存"
	....d OutputRow12
	
	//导出非表格数据
	s (FinallyNum,fillFlag,PatWorkTypeDesc,PatNo,PatName,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser)=""
	//导出班次信息
	s FinallyNum=outBCInfo
	d OutputRow12
	s FinallyNum=""
	
	f noH=1:1:3 d
	.i noH=1 d
	..s fillFlag="原有",PatWorkTypeDesc=$p(XmlData,"^",1)
	..s PatNo="出院",PatName=$p(XmlData,"^",2)
	..s PatSex="入院",PatAge=$p(XmlData,"^",3)
	..s AdmDocDesc="转出",PatDiagnos=$p(XmlData,"^",4)
	..s PatOperName="转入",PatMedicareNo=$p(XmlData,"^",5)
	.i noH=2 d
	..s fillFlag="手术",PatWorkTypeDesc=$p(XmlData,"^",6)
	..s PatNo="病危",PatName=$p(XmlData,"^",7)
	..s PatSex="病重",PatAge=$p(XmlData,"^",8)
	..s AdmDocDesc="死亡",PatDiagnos=$p(XmlData,"^",9)
	..s PatOperName="现有",PatMedicareNo=$p(XmlData,"^",10)
	.i noH=3 d
	..s Note=##class(web.DHCDocPassWork).FilterValue(Note)
	..s (FinallyNum,fillFlag,PatWorkTypeDesc,PatNo,PatName,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser)=""
	..s fillFlag="备注",PatWorkTypeDesc=Note
	.d OutputRow12
	k ^TEMP("web.DHCDocPassWorkE2","FindPassWorkPatList",MNode,ProcedureNum)
	if (ProcedureNum'="QryHistory") {
		k ^BS.OPDoc.PW(LocId,MNode,ProcedureNum)
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow12
	;PatientID,EpisodeID,PatWorkType,PatNo,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,DDPWDRowID,BCRemarkUserID,BCRemarkUser,AdmDocDesc,PatWorkTypeDesc,BCItemId,fillFlag
	set Data=$lb(FinallyNum,fillFlag,PatWorkTypeDesc,PatNo,PatName,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,BCRemark,BCRemarkUser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ExportDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExportDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExportDataClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ExportDataFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// ========================================================================================

// =================================扩展功能===============================================

// ========================================================================================

/// CTOR: QP
/// DATE: 2019-02-13
/// DESC: 查询本科室病区
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPassWorkE2","QryWard",154)
Query QryWard(rowid As %String, inHosp = "") As %Library.Query(ROWSPEC = "LINKCTLocDesc,LINKCTLOCDR,LINKCode")
{
}

ClassMethod QryWardExecute(ByRef qHandle As %Library.Binary, rowid As %String, inHosp = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i rowid'="" {
		s CTLOCRowID=rowid,LINKChildsub=0,LINKCode=""
		for{
			s LINKChildsub=$o(^CTLOC(CTLOCRowID,"LINK",LINKChildsub)) q:LINKChildsub=""
			s LINKRowId=CTLOCRowID_"||"_LINKChildsub
			s LINKParRef=rowid
			s LINKCTLocDesc=""
			s LINKCTLOCDR=$p($g(^CTLOC(CTLOCRowID,"LINK",LINKChildsub)),"^",1)
			s:LINKCTLOCDR'="" LINKCTLocDesc=$p($g(^CTLOC(LINKCTLOCDR)),"^",2)       //科室名
			i (LINKChildsub>0)
			{
				d OuputRow3
			}
		}
	} else {
		s wardDr=0
		f  s wardDr=$o(^PAWARD(wardDr)) q:wardDr=""  d
		.q:(wardDr="BED_BedType_DR")||(wardDr="BED_Room_DR")
		.s active=$p(^PAWARD(wardDr),"^",6)
		.q:active'="Y"
		.s LINKCTLOCDR=$p(^PAWARD(wardDr),"^",5)
		.q:LINKCTLOCDR=""
		.s LINKCTLocDesc=$p(^CTLOC(LINKCTLOCDR),"^",2)
		.s LINKCode=$p(^CTLOC(LINKCTLOCDR),"^",43)
		.d OuputRow3
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow3
	//set Data=$lb(LINKRowId,LINKParRef,LINKCTLocDesc,LINKCTLOCDR)
	set hosp=$p(^CTLOC(LINKCTLOCDR),"^",22)
	q:(inHosp'="")&&(hosp'=inHosp)
	set Data=$lb(LINKCTLocDesc,LINKCTLOCDR,LINKCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryWardFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryWardExecute ]
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

ClassMethod QryWardClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryWardFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 得到模板信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetTPLInfo("PreSum")
ClassMethod GetTPLInfo(PatWorkType) As %String
{
	s mRtn = ""
	q:PatWorkType="" mRtn
	q:'$d(^CF.OPDoc.PW("WKType",PatWorkType)) mRtn
	s mRtn=$p(^CF.OPDoc.PW("WKType",PatWorkType),"^",5)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 得到第一班次信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWorkE2).GetFirstBCInfo()
ClassMethod GetFirstBCInfo() As %String
{
	s currentTime=..%SysTime()
	s mRtn=""
	s seqno=1,fistSTime="",rowid=""
	f  s rowid=$o(^CF.Doc.PWBCI("Seqno",seqno,rowid)) q:rowid=""  d
	.s active=$p(^CF.Doc.PWBC(rowid),"^",7)
	.q:active'=1
	.s code=$p(^CF.Doc.PWBC(rowid),"^",1)
	.s name=$p(^CF.Doc.PWBC(rowid),"^",2)
	.s sTime=$p(^CF.Doc.PWBC(rowid),"^",3)
	.s eTime=$p(^CF.Doc.PWBC(rowid),"^",4)
	.s nextDay=$p(^CF.Doc.PWBC(rowid),"^",5)
	.s note=$p(^CF.Doc.PWBC(rowid),"^",6)
	.s seqno=$p(^CF.Doc.PWBC(rowid),"^",8)
	.s mRtn=code_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_note_"^"_seqno
	
	Q mRtn
}

}
