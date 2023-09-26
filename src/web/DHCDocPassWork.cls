/// CTOR: QP
/// DATE: 2018-10-22
/// DESC: 医生站交班本操作类
Class web.DHCDocPassWork Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

/// 1原有
Property PreSum As %String(TRUNCATE = 1);

/// 2现有
Property NowSum As %String(TRUNCATE = 1);

/// 3出院		
Property OutHospNum As %String(TRUNCATE = 1);

/// 4入院
Property InHospNum As %String(TRUNCATE = 1);

/// 5转出
Property OutWardNum As %String(TRUNCATE = 1);

/// 6转入
Property InWardNum As %String(TRUNCATE = 1);

/// 7手术
Property OperNum As %String(TRUNCATE = 1);

/// 8病危
Property SeverityNum As %String(TRUNCATE = 1);

/// 9病重
Property CritiNum As %String(TRUNCATE = 1);

/// 10死亡
Property DeathNum As %String(TRUNCATE = 1);

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 初始化交班本数据
/// IN  : 科室ID
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).InitPassWorkData()
ClassMethod InitPassWorkData() As %String
{
	S ^CF.OPDoc.PW("BC","D")="白班"
	S ^CF.OPDoc.PW("BC","N")="夜班"
	S ^CF.OPDoc.PW("BCTime","S")="08:00"
	S ^CF.OPDoc.PW("BCTime","E")="18:00"
	S ^CF.OPDoc.PW("WKType","PreSum")="原有^1^1^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","OutHospNum")="出院^1^2^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","InHospNum")="入院^1^3^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","OutWardNum")="转出^1^4^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","InWardNum")="转入^1^5^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","OperNum")="手术^1^6^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","SeverityNum")="病危^1^7^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","CritiNum")="病重^1^8^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","DeathNum")="死亡^1^9^dhcdoc.passwork.tpl.csp^950,445"
	S ^CF.OPDoc.PW("WKType","NowSum")="现有^1^10^dhcdoc.passwork.tpl.csp^950,445"
	s ^CF.OPDoc.PW("GZ","PreSum")="NowSum!1^DeathNum!1^OutWardNum!1^OutHospNum!1^InWardNum!0^InHospNum!0"_$C(1)_"原有计算方式"
	//哪些类型不需要默认显示的根据项目情况进行配置，默认都显示
	s ^CF.OPDoc.PW("GZ","NoDisplay")=""_$C(1)_"无需显示的类型"	//PreSum,NowSum
	s ^CF.OPDoc.PW("GZ","BWCode")="WFY000810"_$C(1)_"病危代码"
	s ^CF.OPDoc.PW("GZ","BZCode")="WFY000811"_$C(1)_"病重代码"
	s ^CF.OPDoc.PW("GZ","SSCode")="WFY001899"_$C(1)_"手术申请代码"
	Q 1
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 根据科室ID获取科室描述
/// IN  : 科室ID
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetDepDescByID(1)
ClassMethod GetDepDescByID(LocRowID As %String) As %String
{
	q:LocRowID="" ""
	s DepDesc=$p($g(^CTLOC(LocRowID)),"^",2)
	i DepDesc["-" s DepDesc=$p(DepDesc,"-",2)
	Q DepDesc
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 取科室交班汇总数据
/// IN  : 科室ID^日期^用户ID
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetPWSummary("103^2018-10-31^2295","N")
ClassMethod GetPWSummary(Para As %String, FindType As %String = "") As %String
{
	Q:Para="" ""
	Q:FindType="" ""
	s WORKTIME=..GetWorkTime()
	s WORKST=$P(WORKTIME,"^",1)
	s WORKET=$P(WORKTIME,"^",2)
	s LocId=$p(Para,"^",1)
	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	s FindDate=$p(Para,"^",2)
	s UserId=$p(Para,"^",3)
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	;s FindType=..GetWorkType(FindDate,CurDate,CurTime)
	s FindDate=..%ZDH(FindDate)
	s SelectDate=FindDate
	k ^BS.OPDoc.PW(LocId) 
	;凌晨查询的夜班应该是昨天的夜班 下方会判断+1
	if (FindDate=CurDate)&&(CurTime<WORKST) s FindDate=FindDate-1
	s (DayPreSum,DayNowSum,DayOutHospNum,DayInHospNum,DayOutWardNum,DayInWardNum,DayOperNum,DaySeverityNum,DayCritiNum,DayDeathNum,DayNote,DayPWId)=""
	s (NightPreSum,NightNowSum,NightOutHospNum,NightInHospNum,NightOutWardNum,NightInWardNum,NightOperNum,NightSeverityNum,NightCritiNum,NightDeathNum,NightNote,NightPWId)=""
	if (SelectDate>=(CurDate-1))&&(FindType'="")&&('$d(^DDPW(0,"LocDateType",LocId,FindDate,FindType))){
		i ((FindType="D")&&(SelectDate=CurDate)){
			;查询白班
			s StartDate=FindDate
			s EndDate=FindDate
			s StartTime=WORKST
			s EndTime=WORKET
			d DayWork
		}
		if (FindType="N"){
			;查询夜班
			s StartDate=FindDate
			s EndDate=FindDate	//+1
			s StartTime=WORKST
			s EndTime=WORKET
			d NightWork
		}
	}else{
		;查询以前记录
		s DDPWRowID=0 f  s DDPWRowID=$o(^DDPW(0,"LocDate",LocId,FindDate,DDPWRowID)) q:DDPWRowID=""  d
		.s WorkType=$p($g(^DDPW(DDPWRowID)),"^",4)
		.q:(WorkType'=FindType)&&(FindType'="")
		.s xmlStr=$p($g(^DDPW(DDPWRowID)),"^",5)
		.s PWObj=##class(web.DHCDocPassWork).%New()
		.d PWObj.XMLNodeDeserialize(.PWObj,"PW",xmlStr)
		.s recNoete=$p($g(^DDPW(DDPWRowID)),"^",8)
		.i WorkType="D" d
		..s DayPreSum=PWObj.PreSum
		..s DayNowSum=PWObj.NowSum
		..s DayOutHospNum=PWObj.OutHospNum
		..s DayInHospNum=PWObj.InHospNum
		..s DayOutWardNum=PWObj.OutWardNum
		..s DayInWardNum=PWObj.InWardNum
		..s DayOperNum=PWObj.OperNum
		..s DaySeverityNum=PWObj.SeverityNum
		..s DayCritiNum=PWObj.CritiNum
		..s DayDeathNum=PWObj.DeathNum
		..s DayNote=recNoete
		..s DayPWId=DDPWRowID
		
		.i WorkType="N" d
		..s NightPreSum=PWObj.PreSum
		..s NightNowSum=PWObj.NowSum
		..s NightOutHospNum=PWObj.OutHospNum
		..s NightInHospNum=PWObj.InHospNum
		..s NightOutWardNum=PWObj.OutWardNum
		..s NightInWardNum=PWObj.InWardNum
		..s NightOperNum=PWObj.OperNum
		..s NightSeverityNum=PWObj.SeverityNum
		..s NightCritiNum=PWObj.CritiNum
		..s NightDeathNum=PWObj.DeathNum
		..s NightNote=recNoete
		..s NightPWId=DDPWRowID
		
		.s DDPWUserId=$p($g(^DDPW(DDPWRowID)),"^",3)
		.s PatPassSeq=0
		.s DDPWSub=0 f  s DDPWSub=$o(^DDPW(DDPWRowID,"Detail",DDPWSub)) q:DDPWSub=""  d
		..s PatWorkType=$p($g(^DDPW(DDPWRowID,"Detail",DDPWSub)),"^",1)
		..q:PatWorkType=""
		..s PatAdmRowId=$p($g(^DDPW(DDPWRowID,"Detail",DDPWSub)),"^",2)
		..s PatPassSeq=PatPassSeq+1
		..s ^BS.OPDoc.PW(LocId,PatWorkType,PatAdmRowId,FindDate,PatPassSeq)="1"
	}
	s retStr=DayPreSum_"^"_DayNowSum_"^"_DayOutHospNum_"^"_DayInHospNum_"^"_DayOutWardNum_"^"_DayInWardNum_"^"_DayOperNum_"^"_DaySeverityNum_"^"_DayCritiNum_"^"_DayDeathNum_"^"_DayNote_"^"_DayPWId
	s retStr=retStr_"@"_NightPreSum_"^"_NightNowSum_"^"_NightOutHospNum_"^"_NightInHospNum_"^"_NightOutWardNum_"^"_NightInWardNum_"^"_NightOperNum_"^"_NightSeverityNum_"^"_NightCritiNum_"^"_NightDeathNum_"^"_NightNote_"^"_NightPWId
	q retStr
DayWork
	s retShiftStr=##class(web.DHCDocPassWork).GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId)
	s DayPreSum=$p(retShiftStr,"^",1)
	s DayNowSum=$p(retShiftStr,"^",2)
	s DayOutHospNum=$p(retShiftStr,"^",3)
	s DayInHospNum=$p(retShiftStr,"^",4)
	s DayOutWardNum=$p(retShiftStr,"^",5)
	s DayInWardNum=$p(retShiftStr,"^",6)
	s DayOperNum=$p(retShiftStr,"^",7)
	s DaySeverityNum=$p(retShiftStr,"^",8)
	s DayCritiNum=$p(retShiftStr,"^",9)
	s DayDeathNum=$p(retShiftStr,"^",10)
	
	q
NightWork
	s retShiftStr=##class(web.DHCDocPassWork).GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId)
	s NightPreSum=$p(retShiftStr,"^",1)
	s NightNowSum=$p(retShiftStr,"^",2)
	s NightOutHospNum=$p(retShiftStr,"^",3)
	s NightInHospNum=$p(retShiftStr,"^",4)
	s NightOutWardNum=$p(retShiftStr,"^",5)
	s NightInWardNum=$p(retShiftStr,"^",6)
	s NightOperNum=$p(retShiftStr,"^",7)
	s NightSeverityNum=$p(retShiftStr,"^",8)
	s NightCritiNum=$p(retShiftStr,"^",9)
	s NightDeathNum=$p(retShiftStr,"^",10)
	
	q
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 获取原始数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetLocItemSummary("2017-05-01","2017-05-01","0:00","23:00",110,4634)
ClassMethod GetLocItemSummary(StartDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, LocId As %String, UserId As %String) As %String
{
 	i (StartDate="")&&(EndDate="")&&(LocId="")  q ""
 	i StartDate="" s startDate=..%SysDate()
 	e  s StartDate=..%ZDH(StartDate)
 	;i StartDate["-" s StartDate=$zdh(StartDate,3)
	;i StartDate["/" s StartDate=$zdh(StartDate,4)
 	i EndDate="" s EndDate=..%SysDate()
 	e  s EndDate=..%ZDH(EndDate)
 	;i EndDate["-" s EndDate=$zdh(EndDate,3)
	;i EndDate["/" s EndDate=$zdh(EndDate,4)
 	;最多查询一个周内数据,以结束日期为准
 	i (EndDate-StartDate)>7 s StartDate=EndDate-7
 	i StartTime="" s StartTime=0
 	i EndTime="" s EndTime=86399
 	i UserId="" s UserId=%session.Data("LOGON.USERID")
	s StartDateTime=##class(web.DHCDocPassWork).GetAbsTime(StartDate_","_StartTime)
	s EndDateTime=##class(web.DHCDocPassWork).GetAbsTime(EndDate_","_EndTime)
	;
	s (PreSum,NowSum,OutHospNum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NewInHospNum)=0
	;转入转出
	f AdmDate=StartDate:1:EndDate d
    .s AdmRowID="" f  s AdmRowID=$o(^PAADMi("TransEndDate",AdmDate,AdmRowID)) q:AdmRowID=""  d
    ..s transIndex=0,PreLoc=""
    ..k temp
    ..s ChildSub="" 
    ..f  s ChildSub=$O(^PAADMi("TransEndDate",AdmDate,AdmRowID,ChildSub),-1) q:(ChildSub="")!(transIndex>2)  d
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
	...s transDateTime=$p($g(temp(1,AdmRowID,locId)),"^",1)
	...s transStDate=$p($g(temp(1,AdmRowID,locId)),"^",3)
    ...i (transDateTime>=StartDateTime)&&(transDateTime<EndDateTime) d
    ....q:$d(^BS.OPDoc.PW(LocId,"InWardNum",AdmRowID))	;6转入
    ....s InWardNum=InWardNum+1
    ....s ^BS.OPDoc.PW(LocId,"InWardNum",AdmRowID,$ZD(transStDate,3),InWardNum)=""
    ..;转出	转科记录倒数第二条是之前科室的
    ..i $g(temp(2,AdmRowID,LocId))'="" d
    ...s transDateTime=$p($g(temp(2,AdmRowID,locId)),"^",2)
    ...s transEndDate=$p($g(temp(2,AdmRowID,locId)),"^",5)
    ...i (transDateTime>=StartDateTime)&&(transDateTime<EndDateTime) d
	....q:$d(^BS.OPDoc.PW(LocId,"OutWardNum",AdmRowID))	;5转出
	....s OutWardNum=OutWardNum+1
    ....s ^BS.OPDoc.PW(LocId,"OutWardNum",AdmRowID,$ZD(transEndDate,3),OutWardNum)=""
    ;---------------------
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
	.....q:$d(^BS.OPDoc.PW(LocId,"OutHospNum",AdmRowID))	;3出院
	.....s OutHospNum=OutHospNum+1
    .....s ^BS.OPDoc.PW(LocId,"OutHospNum",AdmRowID,$zd(DisDate,3),OutHospNum)=""
 	...q:VisitStatus'="A"	;不计算C状态
 	...s NowSum=NowSum+1
	...;入院
	...s AdmDateTime=##class(web.DHCDocPassWork).GetAbsTime(AdmDate_","_AdmTime)
    ...i (AdmDateTime>=StartDateTime)&&(AdmDateTime<EndDateTime) d
    ....q:$d(^BS.OPDoc.PW(LocId,"InHospNum",AdmRowID))	;4入院
    ....s InHospNum=InHospNum+1
    ....s ^BS.OPDoc.PW(LocId,"InHospNum",AdmRowID,$zd(AdmDate,3),InHospNum)=""
	...f PatAdmDate=StartDate:1:EndDate d
	....;病危
    ....s SeverityNumFlag=##class(web.DHCDocPassWork).IfExistOrder(PatAdmDate,AdmRowID,"ZT0033",StartTime,EndTime)
    ....i SeverityNumFlag=1 d
    .....q:$d(^BS.OPDoc.PW(LocId,"SeverityNum",AdmRowID))	;8病危
    .....s SeverityNum=SeverityNum+1
    .....s ^BS.OPDoc.PW(LocId,"SeverityNum",AdmRowID,$ZD(PatAdmDate,3),SeverityNum)=""
	....;病重
    ....s CritiNumFlag=##class(web.DHCDocPassWork).IfExistOrder(PatAdmDate,AdmRowID,"ZT0032",StartTime,EndTime)
    ....i CritiNumFlag=1 d
    .....q:$d(^BS.OPDoc.PW(LocId,"CritiNum",AdmRowID))	;9病重
    .....s CritiNum=CritiNum+1
    .....s ^BS.OPDoc.PW(LocId,"CritiNum",AdmRowID,$ZD(PatAdmDate,3),CritiNum)=""
    ....;手术
    ....s OperNumFlag=##class(web.DHCDocPassWork).IfExistOrder(PatAdmDate,AdmRowID,"ZT0471",StartTime,EndTime)
    ....i OperNumFlag=1 d
    .....q:$d(^BS.OPDoc.PW(LocId,"OperNum",AdmRowID))	;7手术
    .....s OperNum=OperNum+1
    .....s ^BS.OPDoc.PW(LocId,"OperNum",AdmRowID,$ZD(PatAdmDate,3),OperNum)=""
    ....;死亡
    ....s MRAdmId=$p(^PAADM(AdmRowID),"^",61)
	....s DisconId=$p($g(^MR(MRAdmId,"PRO",1)),"^",10)
	....i DisconId'="" s DisconDeadFlag=$p($g(^PAC("DISCON",DisconId)),"^",3)
	....e  s DisconDeadFlag=""
	....i DisconDeadFlag="D" d
	.....s papmiId=$p(^PAADM(AdmRowID),"^",1)
	.....s DeceasedDate=$p($g(^PAPER(papmiId,"ALL")),"^",13)
    .....s DeceasedTime=$p($g(^PAPER(papmiId,"ALL")),"^",8)
	.....s DeceasedDateTime=##class(web.DHCDocPassWork).GetAbsTime(DeceasedDate_","_DeceasedTime)
    .....i (DeceasedDateTime>=StartDateTime)&&(DeceasedDateTime<EndDateTime) d
	......q:$d(^BS.OPDoc.PW(LocId,"DeathNum",AdmRowID))	;10死亡
	......s DeathNum=DeathNum+1
	......s NowSum=NowSum-1
	......s ^BS.OPDoc.PW(LocId,"DeathNum",AdmRowID,$ZD(PatAdmDate,3),DeathNum)=""
	...;现有
	...s ExistStatusFlag=##class(web.DHCDocPassWork).CheckExistStatus(LocId,"InWardNum^OutWardNum^InHospNum^SeverityNum^CritiNum^OperNum^DeathNum",AdmRowID)	//转入^转出^入院^病危^病重^手术^死亡
	...i ExistStatusFlag="N" d
	....s ^BS.OPDoc.PW(LocId,"NowSum",AdmRowID,$ZD(PatAdmDate,3),NowSum)=""	;2现有
	;原有=现有+死亡+转出+出院-转入-新入
	d ##class(web.DHCDocPassWork).SetPreSumGlobal(StartDate,EndDate,LocId)
	s PreSum=NowSum+DeathNum+OutWardNum+OutHospNum-InWardNum-InHospNum
	q PreSum_"^"_NowSum_"^"_OutHospNum_"^"_InHospNum_"^"_OutWardNum_"^"_InWardNum_"^"_OperNum_"^"_SeverityNum_"^"_CritiNum_"^"_DeathNum
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 计算原有
/// IN  : 科室ID
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).SetPreSumGlobal()
ClassMethod SetPreSumGlobal(StartDate As %String, EndDate As %String, LocId As %String, ProcedureNum As %String, MNode As %String) As %String
{
	K ^TEMP($j,"web.DHCDocPassWork")
	s GZStr=$p($g(^CF.OPDoc.PW("GZ","PreSum")),$C(1),1)
	s GZLen=$l(GZStr,"^")
	f PatAdmDate=StartDate:1:EndDate d
	.f i=1:1:GZLen d
	..s curRecord=$P(GZStr,"^",i)
	..s node=$P(curRecord,"!",1),nodeFlag=$P(curRecord,"!",2)
	..s nodeDate=$ZD(PatAdmDate,3)
	..s admId="" 
	..f  s admId=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,node,admId)) q:admId=""  d
	...s sortNum="" f  s sortNum=$o(^BS.OPDoc.PW(LocId,MNode,ProcedureNum,node,admId,nodeDate,sortNum)) q:sortNum=""  d
	....i nodeFlag=1 s ^TEMP($j,"web.DHCDocPassWork",LocId,MNode,ProcedureNum,"PreSum",admId,nodeDate)=""
	....e  k ^TEMP($j,"web.DHCDocPassWork",LocId,MNode,ProcedureNum,"PreSum",admId,nodeDate)
	
	s sortNum=1,admId=""
	f  s admId=$o(^TEMP($j,"web.DHCDocPassWork",LocId,MNode,ProcedureNum,"PreSum",admId)) q:admId=""  d
	.s nodeDate=""
	.f  s nodeDate=$o(^TEMP($j,"web.DHCDocPassWork",LocId,MNode,ProcedureNum,"PreSum",admId,nodeDate)) q:nodeDate=""  d
	..s ^BS.OPDoc.PW(LocId,MNode,ProcedureNum,"PreSum",admId,nodeDate,sortNum)=""
	..s sortNum=sortNum+1
	
	Q ""
}

/// 取日期+时间的数字格式
ClassMethod GetAbsTime(DateTime As %String) As %String
{
	Q:DateTime="" 0
	s Date=$p(DateTime,",",1)
	s Time=$p(DateTime,",",2)
	Q (Date*24*3600)+Time
}

/// EpisodeID就诊号
/// ordDate 医嘱日期
/// ArcimCodes  医嘱的代码的组合,如:"c001^003"
/// 判断ordDate EpisodeID是否有ArcimCodes医嘱
/// w ##class(web.DHCDocPassWork).IfExistOrder("64874","715","WFY000533","0","59637")
ClassMethod IfExistOrder(OrdDate As %String, EpisodeID As %String, ARCIMCodes As %String, STime As %String = "", ETime As %String = "") As %String
{
	s ret=0
	Q:EpisodeID="" ret
	s OrdRowID=$o(^OEORD(0,"Adm",EpisodeID,0))
	Q:OrdRowID="" ret
	s Num=$l(ARCIMCodes,"^")
	f ARCIMSeq=1:1:Num {
		Q:ret=1
		s ARCIMCode=$p(ARCIMCodes,"^",ARCIMSeq)
		Q:ARCIMCode=""
		s ARCIMMain=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ARCIMCode),0))
		Q:ARCIMMain=""
		s ARCIMRowID=ARCIMMain_"||"_"1"
		s OrdStDate=0 f {
			s OrdStDate=$o(^OEORDi(0,"ARCIM",OrdRowID,ARCIMRowID,OrdStDate))
			Q:OrdStDate=""
			s OrdSub="" f {
				s OrdSub=$o(^OEORDi(0,"ARCIM",OrdRowID,ARCIMRowID,OrdStDate,OrdSub))
				Q:OrdSub=""
				continue:'$d(^OEORD(OrdRowID,"I",OrdSub,1))
				s OrdPriorityDR=$p($g(^OEORD(OrdRowID,"I",OrdSub,1)),"^",8)
				s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(OrdPriorityDR)
				;日期 长期不能大于今天 临时等于今天
				continue:(ISLongOrderPrior=1)&&(OrdStDate>OrdDate)
				continue:(ISLongOrderPrior'=1)&&(OrdStDate'=OrdDate)
				s OrdEndDate=$p($g(^OEORD(OrdRowID,"I",OrdSub,3)),"^",34)
				continue:(OrdEndDate<OrdDate)&&(OrdEndDate'="")
				;时间
				s OrdStTime=$p($g(^OEORD(OrdRowID,"I",OrdSub,1)),"^",10)
				s OrdEndTime=$p($g(^OEORD(OrdRowID,"I",OrdSub,2)),"^",15)
				continue:(OrdStDate=OrdDate)&&(OrdStTime>ETime)
				continue:(OrdEndDate=OrdDate)&&(OrdEndTime<STime)
				;状态 长期只算核实停止 临时只算核实
				s OrdStatDr=$p($g(^OEORD(OrdRowID,"I",OrdSub,1)),"^",13)
				continue:(ISLongOrderPrior=1)&&(OrdStatDr'="1")&&(OrdStatDr'="4")
				continue:(ISLongOrderPrior'=1)&&(OrdStatDr'="1")
				s ret=1
			}
		}
	}
	Q ret
}

/// 判断就诊id是否存在某种状态
ClassMethod CheckExistStatus(LocID As %String, CheckStatus As %String, CheckAdmID As %String) As %String
{
	q:(LocID="")||(CheckStatus="")||(CheckAdmID="") ""
	s ExistStatusFlag="N"
	f StatusSeq=1:1:$l(CheckStatus,"^") {
		s OneStatus=$p(CheckStatus,"^",StatusSeq)
		continue:OneStatus=""
		i $d(^BS.OPDoc.PW(LocID,OneStatus,CheckAdmID)) s ExistStatusFlag="N"
	}
	Q ExistStatusFlag
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 获取班次时间
/// IN  : 
/// OUT : 白班时间、夜班时间
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetWorkTime()
ClassMethod GetWorkTime() As %String
{
	s sTime=$g(^CF.OPDoc.PW("BCTime","S"))
	s eTime=$g(^CF.OPDoc.PW("BCTime","E"))
	s sTime=..%ZTH(sTime,2),eTime=..%ZTH(eTime,2)
	q sTime_"^"_eTime
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 获取班次
/// IN  : 
/// OUT : D/N (白班、夜班)
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetWorkType()
ClassMethod GetWorkType(SearchDate As %String = "", CurDate As %String = "", CurTime As %String = "") As %String
{
	s mRtn=""
	
	i CurDate="" s CurDate=..%SysDate()
	i CurTime="" s CurTime=..%SysTime()
	i SearchDate="" s SearchDate=..%SysDate()
	e  s SearchDate=..%ZDH(SearchDate)
	s workTime=..GetWorkTime()
	s sTime=$p(workTime,"^",1),eTime=$p(workTime,"^",2)
	i (SearchDate=CurDate)&&(CurTime>=sTime)&&(CurTime<=eTime) s mRtn="D"	;06:00-18:00
	i (SearchDate=CurDate)&&(CurTime>eTime) s mRtn="N"	;18:00-24:00
	i (SearchDate=CurDate)&&(CurTime<sTime) s mRtn="N"	;00:00-06:00
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 判断是否可以修改
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).IfEnableEdit("2018-10-22")
ClassMethod IfEnableEdit(selectDate) As %String
{
	s mRtn=""
	s workType=..GetWorkType()
	
	s selectDate=..%ZDH(selectDate)
	s curDate=..%ZDH(+$h)
	q:selectDate>curDate "NO-ALL"
	q:selectDate<curDate "OK-ALL"
	i workType="D" s mRtn="OK-D"
	i workType="N" s mRtn="OK-ALL"
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-2
/// DESC: 查询交班本类型
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("web.DHCDocPassWork","QryPassWorkType")
Query QryPassWorkType() As %Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod QryPassWorkTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^TEMP("web.DHCDocPassWork","QryPassWorkType",$j)
    s id=""
    f  s id=$o(^CF.OPDoc.PW("WKType",id)) q:id=""  d
    .s desc=$p(^CF.OPDoc.PW("WKType",id),"^",1)
    .s isDisplay=$p(^CF.OPDoc.PW("WKType",id),"^",2)
    .q:isDisplay'=1
    .s disNo=$p(^CF.OPDoc.PW("WKType",id),"^",3)
	.i disNo="" s disNo="999"
    .s ^TEMP("web.DHCDocPassWork","QryPassWorkType",$j,disNo,id)=$lb(id,desc)
    
    s disNo=""
	f  s disNo=$o(^TEMP("web.DHCDocPassWork","QryPassWorkType",$j,disNo)) q:disNo=""  d
	.s code=""
	.f  s code=$o(^TEMP("web.DHCDocPassWork","QryPassWorkType",$j,disNo,code)) q:code=""  d
	..s outdata=^TEMP("web.DHCDocPassWork","QryPassWorkType",$j,disNo,code)
	..d OutwardRow
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
 	Set ^CacheTemp(repid,ind)=outdata
 	Set ind=ind+1
	quit
}

ClassMethod QryPassWorkTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPassWorkTypeExecute ]
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

ClassMethod QryPassWorkTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPassWorkTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 保存交班本主表信息
/// IN  : 科室^交班日期^交班人^班类型^XML串
/// OUT : 
/// TABL: DHC_DocPassWork
/// EXEC: w ##class(web.DHCDocPassWork).SavePassWork("110^2018-10-23^4634^D^<PW><PreSum>1</PreSum><NowSum>2</NowSum><OutHospNum>3</OutHospNum><InHospNum>4</InHospNum><OutWardNum>5</OutWardNum><InWardNum>6</InWardNum><OperNum>7</OperNum><SeverityNum>8</SeverityNum><CritiNum>9</CritiNum><DeathNum>10</DeathNum></PW>")
ClassMethod SavePassWork(DefaultValue As %String, FindDDPWRowID As %String = "", DNote As %String = "") As %String
{
	q:DefaultValue="" ""
	set DDPWRowID=""
	
	if (FindDDPWRowID'=""){
		s DDPWObj=##class(User.DHCDocPassWork).%OpenId(FindDDPWRowID)
	} else {
		s DDPWObj=##class(User.DHCDocPassWork).%New()	
	}
	s WORKTIME=..GetWorkTime()
	s WORKST=$P(WORKTIME,"^",1)
	s WORKET=$P(WORKTIME,"^",2)
	if $IsObject(DDPWObj) {
		set LocDR=$p(DefaultValue,"^",1)
		do DDPWObj.DDPWLocDRSetObjectId(LocDR)
		set CareDate=$p(DefaultValue,"^",2)
		set WorkType=$p(DefaultValue,"^",4)
		set CareDate=..%ZDH(CareDate)
		;if CareDate["-" s CareDate=$zdh(CareDate,3)
		;if CareDate["/" s CareDate=$zdh(CareDate,4)
		;凌晨查询的夜班应该是昨天的夜班
		s CurDate=..%SysDate(),CurTime=..%SysTime()
		if (CareDate=CurDate)&&(CurTime<WORKST) s CareDate=CareDate-1
		set DDPWObj.DDPWCareDate=CareDate
		set UserDR=$p(DefaultValue,"^",3)
		set xmlStr=$p(DefaultValue,"^",5)
		set BCName=$p(DefaultValue,"^",6)
		set BCSTime=$p(DefaultValue,"^",7)
		set BCETime=$p(DefaultValue,"^",8)
		set BCNextDay=$p(DefaultValue,"^",9)
		set BCSeqno=$p(DefaultValue,"^",10)
		
		do DDPWObj.DDPWCareUserDRSetObjectId(UserDR)
		set DDPWObj.DDPWWorkType=WorkType
		set DDPWObj.DDPWXML=xmlStr
		set DDPWObj.DDPWInsertDate=CurDate
		set DDPWObj.DDPWInsertTime=CurTime
		set DDPWObj.DDPWUpdateDate=CurDate
		set DDPWObj.DDPWUpdateTime=CurTime
		set DDPWObj.DDPWNote=DNote
		set DDPWObj.DDPWBCName=BCName
		set DDPWObj.DDPWBCSTime=BCSTime
		set DDPWObj.DDPWBCETime=BCETime
		set DDPWObj.DDPWBCIsNextDay=BCNextDay
		set DDPWObj.DDPWBCSeqno=BCSeqno
		do DDPWObj.DDPWUpdateUserDRSetObjectId(UserDR)
		set sc=DDPWObj.%Save()
		if $$$ISERR(sc) {
			Quit
		}
		do DDPWObj.%Close()
		if FindDDPWRowID="" set DDPWRowID=DDPWObj.%Id()
		else  set DDPWRowID=FindDDPWRowID
	}
	Q DDPWRowID
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 保存交班本明细
/// IN  : 类型^就诊ID^科室ID^交班日期^交班人^ID
/// OUT : 0成功
/// TABL: DHC_DocPassWorkDetail
/// EXEC: w ##class(web.DHCDocPassWork).SavePWDetail("1","OutWardNum^2^110^^这是一个测试^4634^")
ClassMethod SavePWDetail(DDPWRowID As %String, PatDetail As %String, BCNote As %String = "", Action = "") As %String
{
	s mRtn=0
	Q:PatDetail="" "-1"
	s ^TEMP("QP","SavePatDetail")=DDPWRowID_","_PatDetail
	set DDPWDRowIDALL=""
	set PatLen=$l(PatDetail,"!")
	for PatSeq=1:1:PatLen {
		Q:mRtn'=0
		set OnePatInfo=$p(PatDetail,"!",PatSeq)
		continue:OnePatInfo=""
		set PatWorkType=$p(OnePatInfo,"^",1)
		continue:PatWorkType=""
		set EpisodeID=$p(OnePatInfo,"^",2)
		continue:EpisodeID=""
		set LocDR=$p(OnePatInfo,"^",3)
		;set CareDate=$p(OnePatInfo,"^",4)
		;i CareDate'="" s CareDate=..%ZDH(CareDate)
		;e  s CareDate=..%SysDate()
		set CareDate=$p(^DDPW(DDPWRowID),"^",2)	;根据主表定交班日期
		;if CareDate["-" s CareDate=$zdh(CareDate,3)
		;if CareDate["/" s CareDate=$zdh(CareDate,4)
		;凌晨查询的夜班应该是昨天的夜班
		s CurDate=..%SysDate(),CurTime=..%SysTime()
		;if (CareDate=CurDate)&&(CurTime<(+^DHCDocPassWorkTime)) s CareDate=CareDate-1
		set Remark=BCNote
		set UpdateUserID=$p(OnePatInfo,"^",5)
		set TempFlag=..EnableEdit(UpdateUserID,DDPWRowID)
		i TempFlag'=1  s mRtn="-103" 
		q:TempFlag'=1
		set CareUserDR=$p(^DDPW(DDPWRowID),"^",3)	;根据主表定交班人
		//if (Remark="") s RemarkUserID=""
		set OneDDPWDRowID=$p(OnePatInfo,"^",6)
		kill PLIST
		set PLIST(0)=DDPWRowID
		set PLIST(3)=PatWorkType
		set PLIST(4)=EpisodeID
		set PLIST(5)=LocDR
		set PLIST(6)=CareDate
		set PLIST(7)=Remark
		set PLIST(8)=CurDate
		set PLIST(9)=CurTime
		set PLIST(10)=CareUserDR
		set PLIST(11)=CurDate
		set PLIST(12)=CurTime
		set PLIST(13)=UpdateUserID
		if (OneDDPWDRowID=""){
			&sql(INSERT INTO SQLUser.DHC_DocPassWorkDetail VALUES :PLIST())
			i SQLCODE {
				set DDPWDRowID=EpisodeID_","_SQLCODE
				set mRtn=SQLCODE
			}else{
				set DDPWDRowID=$p(%ROWID,$c(1))
			}
		}else{
			&sql(UPDATE SQLUser.DHC_DocPassWorkDetail(DDPWD_Remark,DDPWD_FDate,DDPWD_FTime,DDPWD_UpdateUserDR) 
				VALUES(:Remark,:CurDate,:CurTime,:UpdateUserID)
				WHERE DDPWD_RowId=:OneDDPWDRowID)
			i SQLCODE {
				set DDPWDRowID=EpisodeID_","_SQLCODE
				set mRtn=SQLCODE
			}else{
				set DDPWDRowID=OneDDPWDRowID
			}
		}
		if DDPWDRowIDALL="" set DDPWDRowIDALL=DDPWDRowID
		else  set DDPWDRowIDALL=DDPWDRowIDALL_"^"_DDPWDRowID
		i Action="Add" {
			d ##class(web.DHCDocPassWorkF1).UpdatePWXML(PatWorkType,DDPWRowID,"Add","")	
		}
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 修改交班内容
/// IN  : 用户^子表ID^备注
/// OUT : 0成功
/// TABL: DHC_DocPassWorkDetail
/// EXEC: w ##class(web.DHCDocPassWork).SavePWDetail("1","OutWardNum^2^110^^这是一个测试^4634^")
ClassMethod EditPWDetail(UserId As %String = "", ItemId As %String, BCNote As %String = "") As %String
{
	s mRtn=0
	Q:(ItemId="")||(UserId="") "-1"
	s BCNote=$replace(BCNote,"^","")
	s tempFlag=..EnableEdit(UserId,+ItemId)
	q:tempFlag'=1 "-103"
	s CurDate=..%SysDate(),CurTime=..%SysTime()
	&SQL(UPDATE SQLUser.DHC_DocPassWorkDetail(DDPWD_Remark,DDPWD_FDate,DDPWD_FTime,DDPWD_UpdateUserDR) 
				VALUES(:BCNote,:CurDate,:CurTime,:UserId)
				WHERE DDPWD_RowId=:ItemId)
	i SQLCODE {
		set mRtn=SQLCODE
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 插入/更新DHC_DocPassWorkDetail表记录,调用的触发程序
/// IN  : 
/// OUT : 1(成功)
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).OnTrigger()
ClassMethod OnTrigger(parref As %String, type As %String = "") As %Status
{
	;s $zt="QueueStatusErr"
	s rtn=1
	s ParObj=##class(User.DHCDocPassWorkDetail).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		s content=ParObj.DDPWDRemark
		s user=ParObj.DDPWDUpdateUserDRGetObjectId()
		s param=parref_"^"_content_"^"_user
		s rtn=..InsertPassWorkLog(param)
		i rtn=0 s rtn=1
		else  s rtn="ERROR"_rtn
	}

	Q rtn
QueueStatusErr
	Q 0
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 插入DHC_DocPassWorkLog表记录
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).InsertPassWorkLog()
ClassMethod InsertPassWorkLog(insertinfo)
{
 s LogParRef=$p(insertinfo,"^",1)
 i LogParRef="" Q -1
 s logContent=$p(insertinfo,"^",2)
 s logUserID=$p(insertinfo,"^",3)
 s logDate=..%SysDate()
 s logTime=..%SysTime()
 TStart
   &SQL(INSERT INTO sqluser.DHC_DocPassWorkLog(LOG_ParRef,DDPWDL_User,DDPWDL_Content,DDPWDL_Date,DDPWDL_Time) 
   VALUES(:LogParRef,:logUserID,:logContent,:logDate,:logTime))
 	i SQLCODE=0 D
	.TCommit  
   e  d
	.Trollback
	
	q SQLCODE
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 返回默认日期
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetDefaultDate()
ClassMethod GetDefaultDate()
{
	;i $d(^CF.OPDoc.PW("Default","Date")) s mRtn=$g(^CF.OPDoc.PW("Default","Date"))
	;e  s mRtn=..%SysDate()
	s mRtn=..%SysDate()
	s mRtn=..%ZD(mRtn)
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 获取病人基本信息
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetPatInfo(2)
ClassMethod GetPatInfo(AdmRowID As %String) As %String
{
	s PAPMIRowID=$p($g(^PAADM(AdmRowID)),"^",1)
	s PatNo=$p($g(^PAPER(PAPMIRowID,"PAT",1)),"^",1)
	s PatMedicareNo=$p($g(^PAPER(PAPMIRowID,"PAT",1)),"^",22)
	s PatName=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",1)
	s PatSexDesc=""
	s PatSexId=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",7)
	i PatSexId'="" s PatSexDesc=$p($g(^CT("SEX",PatSexId)),"^",2)
	s PatBirth=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",6)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PAPMIRowID,AdmRowID)
	S PatHomeAddres=$g(^PAPER(PAPMIRowID,"PER","ADD"))		;家庭住址
	s PatHomeTel=$p($g(^PAPER(PAPMIRowID,"PER",1)),"^",11)	;家庭电话
	s PatWorkTel=$p($g(^PAPER(PAPMIRowID,"PER",1)),"^",9)	;工作电话
	s PatHandTel=$p($g(^PAPER(PAPMIRowID,"PER",4)),"^",21)	;手机
    ;
	s AdmLocId=$p($g(^PAADM(AdmRowID)),"^",4)
	s AdmLocDesc=$p($g(^CTLOC(AdmLocId)),"^",2)
	s AdmDocDesc=""
	s AdmDocId=$p(^PAADM(AdmRowID),"^",9)
	i AdmDocId'="" s AdmDocDesc=$p($g(^CTPCP(AdmDocId,1)),"^",2)
	s CurWardDesc=""
	s CurWardId=$p($g(^PAADM(AdmRowID)),"^",70)
	i CurWardId'="" s CurWardDesc=$p($g(^PAWARD(CurWardId)),"^",1)
	s AdmRoomDesc=""
	s AdmRoomId=$p(^PAADM(AdmRowID),"^",69)
	i AdmRoomId'="" s AdmRoomDesc=$p($g(^PAROOM(AdmRoomId)),"^",2)
	s CurBedCode=""
	s CurBedId=$p($g(^PAADM(AdmRowID)),"^",73)
	i CurBedId'="" s CurBedCode=$p($g(^PAWARD(+CurBedId,"BED",$p(CurBedId,"||",2))),"^",1)
	s MRDiagnos=""
    s MRAdmId=$p($g(^PAADM(AdmRowID)),"^",61)
    s MRDiagnos=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(MRAdmId,";")
    /*s MRAdmSub=0 f  s MRAdmSub=$o(^MR(MRAdmId,"DIA",MRAdmSub)) q:MRAdmSub=""  d
    .s ICDCodeDesc=""
	.s ICDCodeDr=$p($g(^MR(MRAdmId,"DIA",MRAdmSub)),"^",1)
	.i ICDCodeDr'="" s ICDCodeDesc=$p($g(^MRC("ID",ICDCodeDr)),"^",2)
	.s DescSub=$o(^MR(MRAdmId,"DIA",MRAdmSub,"DES",0))
	.i DescSub'="" d
	..i ICDCodeDesc="" s ICDCodeDesc=$g(^MR(MRAdmId,"DIA",MRAdmSub,"DES",DescSub))
	..e  s ICDCodeDesc=ICDCodeDesc_$g(^MR(MRAdmId,"DIA",MRAdmSub,"DES",DescSub))
	.i MRDiagnos="" s MRDiagnos=ICDCodeDesc
	.e  s MRDiagnos=MRDiagnos_","_ICDCodeDesc*/
    s retStr=PAPMIRowID_"^"_PatNo_"^"_PatName_"^"_PatSexDesc_"^"_PatAge_"^"_PatMedicareNo_"^"_PatHomeTel_"  "_PatWorkTel_"  "_PatHandTel_"^"_PatHomeAddres_"^"_MRDiagnos_"^"_AdmLocDesc_"^"_AdmDocDesc_"^"_CurWardDesc_"^"_AdmRoomDesc_"^"_CurBedCode
    q retStr
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 获取病人基本信息
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPassWork","FindPassWorkPatList","110","2019-01-03","4634","","","D")
Query FindPassWorkPatList(LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "") As %Query(ROWSPEC = "PatientID,EpisodeID,PatWorkType,PatNo,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,DayRemark,NightRemark,DDPWDRowID,DayRemarkUserID,DayRemarkUser,NightRemarkUserID,NightRemarkUser,AdmDocDesc,PatWorkTypeDesc,DItemId,NItemId")
{
}

ClassMethod FindPassWorkPatListExecute(ByRef qHandle As %Binary, LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	S ^TEMP("qp","FindPassWorkPatList")=LocId_"^"_FindDate_"^"_UserId_"^"_FindPatWorkType_"^"_FindPatNo_"^"_FindBCType
	i UserId'="" s USERCareID=$P(^SSU("SSUSR",UserId),"^",14)
    e  s USERCareID=""
	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	i UserId="" s UserId=%session.Data("LOGON.USERID")
	i FindDate="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i FindBCType="" s qHandle=$lb(0,repid,0) Quit $$$OK
	;i (FindDate'["-")&&(FindDate'["/") s FindDate=$zd(FindDate,4)
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s WORKTIME=..GetWorkTime()
	s WORKST=$P(WORKTIME,"^",1)
	s WORKET=$P(WORKTIME,"^",2)
	s FindType=FindBCType	;##class(web.DHCDocPassWork).GetWorkType(FindDate,CurDate,CurTime)
	s FindDate=..%ZDH(FindDate)
	;凌晨查询的夜班应该是昨天的夜班 下方会判断+1
	i (FindDate>(+$h)) s qHandle=$lb(0,repid,0) Quit $$$OK
	/*i ((..IfStorageData(FindDate,LocId)=0)&&(FindDate'=(+$h))) {
		B ;;02
		s qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}*/
	s ComPareDate=FindDate
	if (FindDate=CurDate)&&(CurTime<WORKST) s FindDate=FindDate-1
	i ('$d(^BS.OPDoc.PW(LocId))&&(FindType'="")&&(ComPareDate>=(CurDate-1))) {
		i (FindType="D")&&(ComPareDate=CurDate){
			s StartDate=FindDate	;$zdh(FindDate,4)
			s EndDate=FindDate		;$zdh(FindDate,4)
			s StartTime=WORKST
			s EndTime=WORKET
			d ##class(web.DHCDocPassWork).GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId)
		}
		i (FindType="N"){
			s StartDate=FindDate	;$zdh(FindDate,4)
			s EndDate=FindDate		;$zdh(FindDate,4)+1
			s StartTime=WORKST
			s EndTime=WORKET
			d ##class(web.DHCDocPassWork).GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId)
		}
		
	}
	i '$d(^BS.OPDoc.PW(LocId)) s qHandle=$lb(0,repid,0) Quit $$$OK
	s NoDisplayWorkType=$p($g(^CF.OPDoc.PW("GZ","NoDisplay")),$C(1),1)
	s WorkType=0 f  s WorkType=$o(^BS.OPDoc.PW(LocId,WorkType)) q:WorkType=""  d
	.q:(FindPatWorkType="")&&(NoDisplayWorkType'="")&&(..InArray(NoDisplayWorkType,WorkType)=1)
	.q:(FindPatWorkType'=WorkType)&&(FindPatWorkType'="")
	.s AdmRowId=0 f  s AdmRowId=$o(^BS.OPDoc.PW(LocId,WorkType,AdmRowId)) q:AdmRowId=""  d
	..s AdmDate=0 f  s AdmDate=$o(^BS.OPDoc.PW(LocId,WorkType,AdmRowId,AdmDate)) q:AdmDate=""  d
	...s PassSeq=0 f  s PassSeq=$o(^BS.OPDoc.PW(LocId,WorkType,AdmRowId,AdmDate,PassSeq)) q:PassSeq=""  d
	....s CheckFlag=$g(^BS.OPDoc.PW(LocId,WorkType,AdmRowId,AdmDate,PassSeq))
	....s PatInfo=##class(web.DHCDocPassWork).GetPatInfo(AdmRowId)
	....s PatientID=$p(PatInfo,"^",1)
	....s EpisodeID=AdmRowId
	....s AdmDocId=$p(^PAADM(EpisodeID),"^",9)
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
	....s PatOperName=""
	....s PatMedicareNo=$p(PatInfo,"^",6)
	....s CurBedCode=$p(PatInfo,"^",14)
	....s DayRemark="",NightRemark=""
	....s DDPWDRowID=""
	....s DayRemarkUserID="",DayRemarkUser="",NightRemarkUserID="",NightRemarkUser=""
	....s SearchDate=FindDate	;$zdh(FindDate,4)
	....s DDPWDRowID="",DItemId="",NItemId=""
	....s PatPWRowID=0 f  s PatPWRowID=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID)) q:PatPWRowID=""  d
	.....s PatPWSub=0 f  s PatPWSub=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID,PatPWSub)) q:PatPWSub=""  d
	......s MainWorkType=$p($g(^DDPW(PatPWRowID)),"^",4)	;班次
	......s ItemWorkType=$p(^DDPW(PatPWRowID,"Detail",PatPWSub),"^",1)
	......q:ItemWorkType'=WorkType
	......q:MainWorkType'=FindBCType
	......s MainInsertUser=""
	......s MainInsertUserDr=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",8)
	......i MainInsertUserDr'="" s MainInsertUser=$p($g(^SSU("SSUSR",MainInsertUserDr)),"^",2)
	......i MainWorkType="D"  d
	.......s DayRemark=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",5)
	.......s DayRemarkUserID=MainInsertUserDr
	.......s DayRemarkUser=MainInsertUser
	.......s DItemId=PatPWRowID_"||"_PatPWSub
	......i MainWorkType="N"  d
	.......s NightRemark=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",5)
	.......s NightRemarkUserID=MainInsertUserDr
	.......s NightRemarkUser=MainInsertUser
	.......s NItemId=PatPWRowID_"||"_PatPWSub
	......if (MainWorkType=FindType) s DDPWDRowID=PatPWRowID_"||"_PatPWSub
	
	....s PatDetail=PatientID_"^"_EpisodeID_"^"_PatWorkType_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDiagnos_"^"_PatOperName_"^"_PatMedicareNo_"^"_CurBedCode_"^"_DayRemark_"^"_NightRemark_"^"_DDPWDRowID_"^"_DayRemarkUserID_"^"_DayRemarkUser_"^"_NightRemarkUserID_"^"_NightRemarkUser
	....d OutputRow1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatientID,EpisodeID,PatWorkType,PatNo,PatName,PatSex,PatAge,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,DayRemark,NightRemark,DDPWDRowID,DayRemarkUserID,DayRemarkUser,NightRemarkUserID,NightRemarkUser,AdmDocDesc,PatWorkTypeDesc,DItemId,NItemId)
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
/// DATE: 2018-10-23
/// DESC: 判断所查询日期是否存储过
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).IfStorageData("64944", 110)
ClassMethod IfStorageData(selectDate, locid)
{
	s mRtn=0
	i $d(^DDPW(0,"LocDate",locid,selectDate)) s mRtn=1
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-2
/// DESC: 查询交班本类型
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("web.DHCDocPassWork","QryPassWorkBC")
Query QryPassWorkBC() As %Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod QryPassWorkBCExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s id=""
    f  s id=$o(^CF.OPDoc.PW("BC",id)) q:id=""  d
    .s desc=$g(^CF.OPDoc.PW("BC",id))
   	.d OutwardRow
   	
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
/// DATE: 2018-10-23
/// DESC: 根据登记号获取当前的有效住院记录ID
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetAdmIdByPatNo("0000000035")
ClassMethod GetAdmIdByPatNo(PapmiNo)
{
	s mRtn=""
	q:PapmiNo="" mRtn
	s PAPMI=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	q:PAPMI="" mRtn
	s PAAdm="" f  s PAAdm=$O(^PAPERdr(PAPMI,"ADM","I",PAAdm)) Q:(PAAdm="")||(mRtn'="")  d
  	.s VistiStatus=$P($g(^PAADM(PAAdm)),"^",20)
  	.q:VistiStatus'="A"
  	.S mRtn=PAAdm
  	
  	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-24
/// DESC: 保存班次信息
/// IN  : BaseInfo: 科室^用户^密码^日期^班次
/// OUT : 0 成功
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).SaveBCInfo(^TEMP("QP",1),^TEMP("QP",2),^TEMP("QP",3))
ClassMethod SaveBCInfo(BaseInfo As %String, XMLStr As %String, Note As %String)
{
	s mRtn=0
	s ^TEMP("QP",1)=BaseInfo
	s ^TEMP("QP",2)=XMLStr
	s ^TEMP("QP",3)=Note
	s LocDR=$p(BaseInfo,"^",1)
	s UserId=$p(BaseInfo,"^",2)
	s PassWd=$p(BaseInfo,"^",3)
	s CDate=$p(BaseInfo,"^",4)
	s BCType=$p(BaseInfo,"^",5)
	s BCInfo=##class(web.DHCDocPassWorkE2).GetBCInfoByCode(BCType)
	//code_"^"_name_"^"_sTime_"^"_eTime_"^"_nextDay_"^"_seqno
	s BCName=$p(BCInfo,"^",2)
	s BCSTime=$p(BCInfo,"^",3)
	s BCETime=$p(BCInfo,"^",4)
	s BCNextDay=$p(BCInfo,"^",5)
	s BCSeqno=$p(BCInfo,"^",6)
	s flag=##class(web.DHCOEOrdItem).PinNumberValid(UserId,PassWd)
	Q:flag'=0 "2"	;密码错误
	;凌晨查询的夜班应该是昨天的夜班
	s CurDate=..%SysDate(),CurTime=..%SysTime()
	s WORKTIME=..GetWorkTime()
	s WORKST=$P(WORKTIME,"^",1)
	s WORKET=$P(WORKTIME,"^",2)
	s CDate=..%ZDH(CDate)
	if (CDate=CurDate)&&(CurTime<WORKST) s CDate=CDate-1
	s FindDDPWRowID=$o(^DDPW(0,"LocDateType",LocDR,CDate,BCType,0))
	i FindDDPWRowID'="" {
		s isEditOK=..EnableEdit(UserId,FindDDPWRowID)
		Q:isEditOK'=1 "3"	;不是交班人不允许修改
		//已存在记录
		&SQL(UPDATE SQLUser.DHC_DocPassWork(DDPW_XML,DDPW_Note,DDPW_UpdateDate,DDPW_UpdateTime,DDPW_UpdateUserDR) 
			VALUES(:XMLStr,:Note,:CurDate,:CurTime,:UserId) 
			WHERE DDPW_RowId=:FindDDPWRowID)
		i SQLCODE {
			s mRtn=SQLCODE
		}
	} else {
		//科室^交班日期^交班人^班类型^XML串
		s InPara=LocDR_"^"_CDate_"^"_UserId_"^"_BCType_"^"_XMLStr_"^"_BCName_"^"_BCSTime_"^"_BCETime_"^"_BCNextDay_"^"_BCSeqno
		s DDPWRowID=..SavePassWork(InPara,"",Note)
		Q:DDPWRowID="" "-201"	//主表保存失败
		s MNode = "M-"_UserId_"-"_CDate_"-"_BCType
		s SaveNode="DBSave"
		s GlobalDate=$zd(CDate,3)
		s WorkType=0 f  s WorkType=$o(^BS.OPDoc.PW(LocDR,MNode,SaveNode,WorkType)) q:WorkType=""  d
		.s cfgInfo=$g(^CF.OPDoc.PW("WKType",WorkType))
		.q:cfgInfo=""
		.s isDisplay=$p(^CF.OPDoc.PW("WKType",WorkType),"^",2)
		.q:isDisplay'=1
		.s AdmRowId=0 f  s AdmRowId=$o(^BS.OPDoc.PW(LocDR,MNode,SaveNode,WorkType,AdmRowId)) q:AdmRowId=""  d
		..s PassSeq=0 f  s PassSeq=$o(^BS.OPDoc.PW(LocDR,MNode,SaveNode,WorkType,AdmRowId,GlobalDate,PassSeq)) q:PassSeq=""  d
		...s PatDetail=WorkType_"^"_AdmRowId_"^"_LocDR_"^"_CDate_"^"_UserId
		...s ret=##class(web.DHCDocPassWork).SavePWDetail(DDPWRowID,PatDetail)
		
		;清理Global
		k ^BS.OPDoc.PW(LocDR,MNode,SaveNode)
		Q 0
	}
	
	
  	
  	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-24
/// DESC: 保存班次信息
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).BuildXML("{ PreSum:44, NowSum: 44, OutHospNum: 0, InHospNum: 0, OutWardNum: 0, InWardNum: 0, OperNum: 0, SeverityNum: 0, CritiNum: 0, DeathNum: 0}")
ClassMethod BuildXML(ParaJson As %String)
{
	s mRtn=""
	s XMLNodes=##class(web.DHCBL.UDHCCommFunLibary).GetClassPropertyList("web.DHCDocPassWork")
	s PWOBJ=##Class(web.DHCDocPassWork).%New()
	d ##class(ext.util.JsonObject).JSONStreamToObject(ParaJson,.PWOBJ)
	s a=PWOBJ_".PreSum"
	q a
	q 1 
	s Len=$l(XMLNodes,"^")
	f i=1:1:Len d
	.s node=$p(XMLNodes,"^",i)
	.s value=PWOBJ_"."_node
	.w value
	
	/*
	s str="{""PreSum"":""yyyyyy"",""InWardNum"":""2""}"
	w str,!
	s obj=##Class(web.DHCDocPassWork).%New()
	d ##class(ext.util.JsonObject).JSONStreamToObject(str,.obj,"")
	w obj.PreSum,!
	*/
	
	q 1
}

/// CTOR: QP
/// DATE: 2018-10-24
/// DESC: 得到所有病人类型
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetClassPropertyList("web.DHCDocPassWork")
ClassMethod GetClassPropertyList(cls As %String) As %String
{
	
	s myItems=""
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(cls)
	s myCount = myobj.Properties.Count()
	
	s mylist=""	;$p(ClassName,".",$l(ClassName,"."))
	
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		continue:myName="%%OID"	
		s cfgInfo=$g(^CF.OPDoc.PW("WKType",myName))
		continue:cfgInfo=""
		s isDisplay=$p(cfgInfo,"^",2)
		continue:isDisplay'=1
		if (mylist="")
		{
			s mylist= myName
		}else
		{
	    	s mylist=mylist_"^"_myName
		}
	}
	i mylist'="" s mylist=mylist_"^PWId^Note"
	q mylist
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 判断此人是否已经存在
/// IN  : 主表ID^就诊ID^科室ID
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).IfHasPat("17^313^95^OutWardNum")
ClassMethod IfHasPat(InPara) As %String
{
	s ^TEMP("QP",1111)=InPara
	s mRtn=0
	s PPWId=$p(InPara,"^",1)
	s AdmId=$p(InPara,"^",2)
	s LocId=$p(InPara,"^",3)
	s wType=$p(InPara,"^",4)
	q:PPWId="" mRtn
	s CareDate=$p(^DDPW(PPWId),"^",2)
	
	s detailDr=$o(^DDPW(0,"AdmLocTypeDate",AdmId,LocId,wType,CareDate,PPWId,0))
	i detailDr'="" s mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 根据子表ID获取：班次^类型^交班内容
/// IN  : 主表ID^就诊ID^科室ID
/// OUT : 1可以/
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).GetPatInfoByItemID("1||45")
ClassMethod GetPatInfoByItemID(ItemID) As %String
{
	s ^TEMP("QP",1234)=ItemID
	s PAR=$p(ItemID,"||",1),CHL=$p(ItemID,"||",2)
	s BCType=$p(^DDPW(PAR),"^",4)
	s BCDesc=$p(^DDPW(PAR),"^",12)	//$g(^CF.OPDoc.PW("BC",BCType))
	s WorkType=$p(^DDPW(PAR,"Detail",CHL),"^",1)
	s WorkDesc=$p(^CF.OPDoc.PW("WKType",WorkType),"^",1)
	s Content=$p(^DDPW(PAR,"Detail",CHL),"^",5)
	s BCUser=$p(^DDPW(PAR,"Detail",CHL),"^",8)
	s BCDT=""
	i Content'="" d
	.s BCDate=$p(^DDPW(PAR,"Detail",CHL),"^",9)
	.s BCTime=$p(^DDPW(PAR,"Detail",CHL),"^",10)
	.s BCDT=..%ZD(BCDate)_" "_..%ZT(BCTime,2)
	.s BCUser=$p(^DDPW(PAR,"Detail",CHL),"^",11)
	i BCUser'="" s BCUser=$p(^SSU("SSUSR",BCUser),"^",2)
	s admId=$p(^DDPW(PAR,"Detail",CHL),"^",2)
	s PAPMIRowID=$p($g(^PAADM(admId)),"^",1)
	s PatNo=$p($g(^PAPER(PAPMIRowID,"PAT",1)),"^",1)
	s PatName=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",1)
	s MRDiagnos=""
    s MRAdmId=$p($g(^PAADM(admId)),"^",61)
    s MRAdmSub=0 f  s MRAdmSub=$o(^MR(MRAdmId,"DIA",MRAdmSub)) q:MRAdmSub=""  d
    .s ICDCodeDesc=""
	.s ICDCodeDr=$p($g(^MR(MRAdmId,"DIA",MRAdmSub)),"^",1)
	.i ICDCodeDr'="" s ICDCodeDesc=$p($g(^MRC("ID",ICDCodeDr)),"^",2)
	.s DescSub=$o(^MR(MRAdmId,"DIA",MRAdmSub,"DES",0))
	.i DescSub'="" d
	..i ICDCodeDesc="" s ICDCodeDesc=$g(^MR(MRAdmId,"DIA",MRAdmSub,"DES",DescSub))
	..e  s ICDCodeDesc=ICDCodeDesc_$g(^MR(MRAdmId,"DIA",MRAdmSub,"DES",DescSub))
	.i MRDiagnos="" s MRDiagnos=ICDCodeDesc
	.e  s MRDiagnos=MRDiagnos_","_ICDCodeDesc
	
	q BCDesc_$C(1)_WorkDesc_$C(1)_PatNo_$C(1)_PatName_$C(1)_Content_$C(1)_admId_$C(1)_MRDiagnos_$C(1)_BCType_$C(1)_BCDT_$C(1)_BCUser
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 初始化查询标签Title
/// IN  : 日期
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).InitBCLabelTitle("2018-10-26")
ClassMethod InitBCLabelTitle(FindDate) As %String
{
	q:FindDate="" ""
	s WORKTIME=..GetWorkTime()
	s WORKST=$P(WORKTIME,"^",1)
	s WORKET=$P(WORKTIME,"^",2)
	s WORKSTime=..%ZT(WORKST,2)
	s WORKETime=..%ZT(WORKET,2)
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	
	s SearchDate=..%ZDH(FindDate)
	s Yesterday=..%ZD(SearchDate-1)
	s DTitle="白班（<span id='BCD-D'>"_FindDate_"</span> "_WORKSTime_" ~ "_WORKETime_"）"
	i SearchDate=..%SysDate() d
	.s NTitle="夜班（<span id='BCD-N'>"_Yesterday_"</span> "_WORKETime_" ~ 次日"_WORKSTime_"）"
	.i CurTime>WORKET d
	..s NTitle="夜班（<span id='BCD-N'>"_FindDate_"</span> "_WORKETime_" ~ 次日"_WORKSTime_"）"
	e  d
	.s NTitle="夜班（<span id='BCD-N'>"_FindDate_"</span> "_WORKETime_" ~ 次日"_WORKSTime_"）"
	q DTitle_"^"_NTitle
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 判断所选日期是否超过当前日期
/// IN  : 日期
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).EnableSelectDate("2018-10-26")
ClassMethod EnableSelectDate(SelectDate) As %String
{
	q:SelectDate="" ""
	s SearchDate=..%ZDH(SelectDate)
	i SearchDate>(+$H) {
		Q 1	
	}
	Q 0
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 判断所选日期是否超过当前日期
/// IN  : 日期
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocPassWork).EnableEdit("12",1)
ClassMethod EnableEdit(CurUserId, MainId) As %String
{
	s mRtn=1
	q:(CurUserId="")||(MainId="") 0
	s CareUser=$P(^DDPW(MainId),"^",3)
	q:CareUser'=CurUserId 0
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).InArray("I")
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
/// DATE: 2018-10-23
/// DESC: 导出数据
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocPassWork","ExportData","110","2018-10-24","4634","","","D")
Query ExportData(LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", Note As %String = "", XmlData As %String = "") As %Query(ROWSPEC = "FinallyNum:%String:序号,PatWorkTypeDesc:%String:类型,PatNo:%String:登记号,PatName:%String:姓名,PatSex:%String:性别,PatAge:%String:年龄,AdmDocDesc:%String:主管医生,PatDiagnos:%String:诊断,PatOperName:%String:手术,PatMedicareNo:%String:住院号,CurBedCode:%String:床号,DayRemark:%String:白班,NightRemark:%String:夜班,DayRemarkUser:%String:白班更新人,NightRemarkUser:%String:夜班更新人")
{
}

ClassMethod ExportDataExecute(ByRef qHandle As %Binary, LocId As %String, FindDate As %String, UserId As %String, FindPatWorkType As %String = "", FindPatNo As %String = "", FindBCType As %String = "", Note As %String = "", XmlData As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	S ^TEMP("qp","ExportData")=LocId_"^"_FindDate_"^"_UserId_"^"_FindPatWorkType_"^"_FindPatNo_"^"_FindBCType
	i UserId'="" s USERCareID=$P(^SSU("SSUSR",UserId),"^",14)
    e  s USERCareID=""
	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
	i UserId="" s UserId=%session.Data("LOGON.USERID")
	i FindDate="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i FindBCType="" s qHandle=$lb(0,repid,0) Quit $$$OK
	;i (FindDate'["-")&&(FindDate'["/") s FindDate=$zd(FindDate,4)
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s WORKTIME=..GetWorkTime()
	s WORKST=$P(WORKTIME,"^",1)
	s WORKET=$P(WORKTIME,"^",2)
	s FindType=FindBCType	;##class(web.DHCDocPassWork).GetWorkType(FindDate,CurDate,CurTime)
	s FindDate=..%ZDH(FindDate)
	;凌晨查询的夜班应该是昨天的夜班 下方会判断+1
	i (FindDate>(+$h)) s qHandle=$lb(0,repid,0) Quit $$$OK
	/*i ((..IfStorageData(FindDate,LocId)=0)&&(FindDate'=(+$h))) {
		B ;;02
		s qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}*/
	s ComPareDate=FindDate
	if (FindDate=CurDate)&&(CurTime<WORKST) s FindDate=FindDate-1
	i ('$d(^BS.OPDoc.PW(LocId))&&(FindType'="")&&(ComPareDate>=(CurDate-1))) {
		i (FindType="D")&&(ComPareDate=CurDate){
			s StartDate=FindDate	;$zdh(FindDate,4)
			s EndDate=FindDate		;$zdh(FindDate,4)
			s StartTime=WORKST
			s EndTime=WORKET
			d ##class(web.DHCDocPassWork).GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId)
		}
		i (FindType="N"){
			s StartDate=FindDate	;$zdh(FindDate,4)
			s EndDate=FindDate		;$zdh(FindDate,4)+1
			s StartTime=WORKST
			s EndTime=WORKET
			d ##class(web.DHCDocPassWork).GetLocItemSummary(StartDate,EndDate,StartTime,EndTime,LocId,UserId)
		}
		
	}
	i '$d(^BS.OPDoc.PW(LocId)) s qHandle=$lb(0,repid,0) Quit $$$OK
	
	s FinallyNum=0
	s NoDisplayWorkType=$P($g(^CF.OPDoc.PW("GZ","NoDisplay")),$C(1),1)
	s WorkType=0 f  s WorkType=$o(^BS.OPDoc.PW(LocId,WorkType)) q:WorkType=""  d
	.q:(FindPatWorkType="")&&(NoDisplayWorkType'="")&&(..InArray(NoDisplayWorkType,WorkType)=1)
	.q:(FindPatWorkType'=WorkType)&&(FindPatWorkType'="")
	.s AdmRowId=0 f  s AdmRowId=$o(^BS.OPDoc.PW(LocId,WorkType,AdmRowId)) q:AdmRowId=""  d
	..s AdmDate=0 f  s AdmDate=$o(^BS.OPDoc.PW(LocId,WorkType,AdmRowId,AdmDate)) q:AdmDate=""  d
	...s PassSeq=0 f  s PassSeq=$o(^BS.OPDoc.PW(LocId,WorkType,AdmRowId,AdmDate,PassSeq)) q:PassSeq=""  d
	....s CheckFlag=$g(^BS.OPDoc.PW(LocId,WorkType,AdmRowId,AdmDate,PassSeq))
	....s PatInfo=##class(web.DHCDocPassWork).GetPatInfo(AdmRowId)
	....s PatientID=$p(PatInfo,"^",1)
	....s EpisodeID=AdmRowId
	....s AdmDocId=$p(^PAADM(EpisodeID),"^",9)
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
	....s PatOperName=""
	....s PatMedicareNo=$p(PatInfo,"^",6)
	....s CurBedCode=$p(PatInfo,"^",14)
	....s DayRemark="",NightRemark=""
	....s DDPWDRowID=""
	....s DayRemarkUserID="",DayRemarkUser="",NightRemarkUserID="",NightRemarkUser=""
	....s SearchDate=FindDate	;$zdh(FindDate,4)
	....s DDPWDRowID="",DItemId="",NItemId=""
	....s PatPWRowID=0 f  s PatPWRowID=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID)) q:PatPWRowID=""  d
	
	.....s PatPWSub=0 f  s PatPWSub=$o(^DDPW(0,"AdmLocDate",AdmRowId,LocId,SearchDate,PatPWRowID,PatPWSub)) q:PatPWSub=""  d
	......s MainWorkType=$p($g(^DDPW(PatPWRowID)),"^",4)	;班次
	......s ItemWorkType=$p(^DDPW(PatPWRowID,"Detail",PatPWSub),"^",1)
	......q:ItemWorkType'=WorkType
	......q:MainWorkType'=FindBCType
	......s MainInsertUser=""
	......s MainInsertUserDr=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",8)
	......i MainInsertUserDr'="" s MainInsertUser=$p($g(^SSU("SSUSR",MainInsertUserDr)),"^",2)
	......i MainWorkType="D"  d
	.......s DayRemark=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",5)
	.......s DayRemarkUserID=MainInsertUserDr
	.......s DayRemarkUser=MainInsertUser
	.......s DItemId=PatPWRowID_"||"_PatPWSub
	......i MainWorkType="N"  d
	.......s NightRemark=$p($g(^DDPW(PatPWRowID,"Detail",PatPWSub)),"^",5)
	.......s NightRemarkUserID=MainInsertUserDr
	.......s NightRemarkUser=MainInsertUser
	.......s NItemId=PatPWRowID_"||"_PatPWSub
	......if (MainWorkType=FindType) s DDPWDRowID=PatPWRowID_"||"_PatPWSub
	
	....s PatDetail=PatientID_"^"_EpisodeID_"^"_PatWorkType_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDiagnos_"^"_PatOperName_"^"_PatMedicareNo_"^"_CurBedCode_"^"_DayRemark_"^"_NightRemark_"^"_DDPWDRowID_"^"_DayRemarkUserID_"^"_DayRemarkUser_"^"_NightRemarkUserID_"^"_NightRemarkUser
	....s DayRemark=..FilterValue(DayRemark)
	....s NightRemarkUser=..FilterValue(NightRemarkUser)
	....s PatDiagnos=..FilterValue(PatDiagnos)
	....s PatOperName=..FilterValue(PatOperName)
	....s FinallyNum=FinallyNum+1
	....d OutputRow2
	
	//导出非表格数据
	s (FinallyNum,PatWorkTypeDesc,PatNo,PatName,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,DayRemark,NightRemark,DayRemarkUser,NightRemarkUser)=""
	f noH=1:1:3 d
	.i noH=1 d
	..s FinallyNum="原有",PatWorkTypeDesc=$p(XmlData,"^",1)
	..s PatNo="出院",PatName=$p(XmlData,"^",2)
	..s PatSex="入院",PatAge=$p(XmlData,"^",3)
	..s AdmDocDesc="转出",PatDiagnos=$p(XmlData,"^",4)
	..s PatOperName="转入",PatMedicareNo=$p(XmlData,"^",5)
	.i noH=2 d
	..s FinallyNum="手术",PatWorkTypeDesc=$p(XmlData,"^",6)
	..s PatNo="病危",PatName=$p(XmlData,"^",7)
	..s PatSex="病重",PatAge=$p(XmlData,"^",8)
	..s AdmDocDesc="死亡",PatDiagnos=$p(XmlData,"^",9)
	..s PatOperName="现有",PatMedicareNo=$p(XmlData,"^",10)
	.i noH=3 d
	..s Note=..FilterValue(Note)
	..s (FinallyNum,PatWorkTypeDesc,PatNo,PatName,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,DayRemark,NightRemark,DayRemarkUser,NightRemarkUser)=""
	..s FinallyNum="备注",PatWorkTypeDesc=Note
	.d OutputRow2
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(FinallyNum,PatWorkTypeDesc,PatNo,PatName,PatSex,PatAge,AdmDocDesc,PatDiagnos,PatOperName,PatMedicareNo,CurBedCode,DayRemark,NightRemark,DayRemarkUser,NightRemarkUser)
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

/// QP
/// DATE: 2016-08-14
ClassMethod FilterValue(value) As %String
{
	s value=..ReplaceStr(value,",","，")
	s value=..ReplaceStr(value,$C(10),"")
	q value
}

/// QP
/// DATE: 2016-08-14
ClassMethod ReplaceStr(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

}
