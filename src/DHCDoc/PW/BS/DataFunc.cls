/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 取数函数
Class DHCDoc.PW.BS.DataFunc Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 出院,入院,;病危;病重;手术;死亡;现有
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.DataFunc).GetLocItemSummary("138",65967,65967,"64385","","12278","M")
ClassMethod GetLocItemSummary(LocId, StartDate, EndDate, StartTime, EndTime, UserId, BCCode, ByRef DList, SaveFlag = "") As %String
{
	s ^QP("GetLocItemSummary")=$LB(LocId, StartDate, EndDate, StartTime, EndTime, UserId, BCCode)
	i StartDate="" s StartDate=+$h
 	e  s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
 	i EndDate="" s EndDate=+$h
 	e  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	//i StartTime="" s StartTime=0
 	s NodeDate=StartDate	;
 	s BCInfo=##class(DHCDoc.PW.CFG.BCTime).GetBCInfoByCode(LocId,BCCode)
 	i BCInfo="" {
	 	s StartTime=0
		s EndTime=86400
 	} else {
	 	s NextDay=$lg(BCInfo,6)
	 	s StartTime=$lg(BCInfo,4)
	 	s EndTime=$lg(BCInfo,5)
	 	i NextDay=1 {
		 	s StartDate=StartDate+1
		 	s EndDate=EndDate+1
		}
		i NextDay=2 {
			i StartDate=+$H {
				s EndTime=86400
			}else {
				//s StartTime=0
				s StartDate=StartDate
				s EndDate=StartDate+1
			}
		}
	}
 	//i UserId="" s UserId=%session.Data("LOGON.USERID")
	s StartDateTime=##class(DHCDoc.PW.COM.Method).GetAbsTime(StartDate_","_StartTime)
	s EndDateTime=##class(DHCDoc.PW.COM.Method).GetAbsTime(EndDate_","_EndTime)
	s (PreSum,NowSum,OutHospNum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum)=0
	i SaveFlag'=1 {
		k ^||BS.PW.NMain("RealCount")
		lock +^||BS.PW.NMain("RealCount",LocId,StartDate,BCCode)
	}
	f AdmDate=StartDate:1:EndDate d
    .s AdmRowID="" f  s AdmRowID=$o(^PAADMi("TransEndDate",AdmDate,AdmRowID)) q:AdmRowID=""  d
    ..s transIndex=0,PreLoc=""
    ..k temp
    ..s ChildSub="" 
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
    ....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"InWardNum",AdmRowID))	;6转入
    ....s InWardNum=InWardNum+1
    ....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"InWardNum",AdmRowID,InWardNum)=""
    ..;转出	转科记录倒数第二条是之前科室的，且应该判断倒数第一条得科室得时间是否在今天
    ..i $g(temp(2,AdmRowID,LocId))'="" d
    ...s firstLocid=$o(temp(1,AdmRowID,""))
    ...s transDateTime=$p($g(temp(1,AdmRowID,firstLocid)),"^",1)
    ...s transEndDate=$p($g(temp(1,AdmRowID,firstLocid)),"^",3)
    ...i (transDateTime>=StartDateTime)&&(transDateTime<EndDateTime) d
	....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"OutWardNum",AdmRowID))	;5转出
	....s OutWardNum=OutWardNum+1
    ....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"OutWardNum",AdmRowID,OutWardNum)=""
    
	s AdmDate=0 f  s AdmDate=$o(^PAADMi("TDepDateTime","I",LocId,AdmDate)) q:AdmDate=""  d
 	.s AdmTime=0 f  s AdmTime=$o(^PAADMi("TDepDateTime","I",LocId,AdmDate,AdmTime)) q:AdmTime=""  d
	..s AdmRowID=0 f  s AdmRowID=$o(^PAADMi("TDepDateTime","I",LocId,AdmDate,AdmTime,AdmRowID)) q:AdmRowID=""  d
	...s VisitStatus=$p($g(^PAADM(AdmRowID)),"^",20)
	...;出院
	...i VisitStatus="D" d
	....s DisDate=$p($g(^PAADM(AdmRowID)),"^",17)
    ....s DisTime=$p($g(^PAADM(AdmRowID)),"^",18)
	....s DisDateTime=##class(DHCDoc.PW.COM.Method).GetAbsTime(DisDate_","_DisTime)
    ....i (DisDateTime>StartDateTime)&&(DisDateTime<EndDateTime) d
	.....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"OutHospNum",AdmRowID))	;3出院
	.....s OutHospNum=OutHospNum+1
    .....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"OutHospNum",AdmRowID,OutHospNum)=""
 	...q:VisitStatus'="A"	;不计算C状态
 	...;现有
 	...i 1=1 d
 	....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"NowSum",AdmRowID))
 	....s NowSum=NowSum+1	;
 	....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"NowSum",AdmRowID,NowSum)=""
	...;入院
	...s AdmDateTime=##class(DHCDoc.PW.COM.Method).GetAbsTime(AdmDate_","_AdmTime)
    ...i (AdmDateTime>=StartDateTime)&&(AdmDateTime<EndDateTime) d
    ....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"InHospNum",AdmRowID))	;4入院
    ....s InHospNum=InHospNum+1
    ....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"InHospNum",AdmRowID,InHospNum)=""
	...f PatAdmDate=StartDate:1:EndDate d
	....;病危
    ....s SeverityNumFlag=##class(DHCDoc.PW.COM.Method).IsCriticallyIll(AdmRowID)
    ....i SeverityNumFlag=1 d
    .....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"SeverityNum",AdmRowID))	;8病危
    .....s SeverityNum=SeverityNum+1
    .....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"SeverityNum",AdmRowID,SeverityNum)=""
	....;病重
    ....s CritiNumFlag=##class(DHCDoc.PW.COM.Method).IsSeriouslyIll(AdmRowID)
    ....i CritiNumFlag=1 d
    .....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"CritiNum",AdmRowID))	;9病重
    .....s CritiNum=CritiNum+1
    .....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"CritiNum",AdmRowID,CritiNum)=""
    ....;手术
    ....s SSCode=##class(DHCDoc.PW.CFG.BCRule).GetRuleValue(LocId,"SSCode")
    ....s OperNumFlag=##class(DHCDoc.PW.COM.Method).IfExistOrder(PatAdmDate,AdmRowID,SSCode,StartTime,EndTime,StartDate,EndDate)
    ....i OperNumFlag=1 d
    .....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"OperNum",AdmRowID))	;7手术
    .....s OperNum=OperNum+1
    .....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"OperNum",AdmRowID,OperNum)=""
    ....;死亡
    ....s patientDr=$p(^PAADM(AdmRowID),"^",1)
    ....s IsDeceased=##Class(web.PAPerson).CheckDeceased(patientDr)
    ....i IsDeceased="Y" d
	.....q:$d(^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"DeathNum",AdmRowID))	;10死亡
	.....s DeathNum=DeathNum+1
	.....s NowSum=NowSum-1
	.....k ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"NowSum",AdmRowID)
    .....s ^||BS.PW.NMain("RealCount",LocId,NodeDate,BCCode,"DeathNum",AdmRowID,DeathNum)=""
	;原有=现有+死亡+转出+出院-转入-新入
	d ##class(DHCDoc.PW.COM.Method).SetPreSumGlobal(NodeDate,NodeDate,LocId,BCCode)
	s PreSum=NowSum+DeathNum+OutWardNum+OutHospNum-InWardNum-InHospNum
	i SaveFlag'=1 {
		lock -^||BS.PW.NMain("RealCount",LocId,StartDate,BCCode)
	}
	s DList("PreSum")=PreSum
	s DList("NowSum")=NowSum
	s DList("OutHospNum")=OutHospNum
	s DList("InHospNum")=InHospNum
	s DList("OutWardNum")=OutWardNum
	s DList("InWardNum")=InWardNum
	s DList("OperNum")=OperNum
	s DList("SeverityNum")=SeverityNum
	s DList("CritiNum")=CritiNum
	s DList("DeathNum")=DeathNum
	
	Q PreSum_"^"_NowSum_"^"_OutHospNum_"^"_InHospNum_"^"_OutWardNum_"^"_InWardNum_"^"_OperNum_"^"_SeverityNum_"^"_CritiNum_"^"_DeathNum
}

}
