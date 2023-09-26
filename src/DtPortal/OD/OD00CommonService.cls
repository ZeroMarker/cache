Class DtPortal.OD.OD00CommonService Extends %RegisteredObject [ ProcedureBlock ]
{

// 根据科室ID得到已就诊人数及等候人数

ClassMethod GetRegAndWaitNum(LocID As %String, TimeRangeRowID As %String) As %String
{
	q:LocID="" "0^0"
	s RegNum=0,WaitNum=0
	s QueRowId=0  f  s QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",+$h,LocID,QueRowId)) q:QueRowId=""  d
	.s QuePaadmDr=$list(^User.DHCQueueD(QueRowId),11)
	.s RegistrationFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_QuePaadmDr,""))
	.q:RegistrationFeeId="" 
	.s RBASDr=$list(^User.DHCRegistrationFeeD(RegistrationFeeId),18)
	.s ASDate1=$p($g(^RBAS(+RBASDr,$p(RBASDr,"||",2))),"^",1)
	.q:ASDate1'=+$h
	.s ASTimeRangeDR1=$p(^RBAS(+RBASDr,$p(RBASDr,"||",2),"DHC"),"^",17)
    .q:ASTimeRangeDR1'=TimeRangeRowID
	.s QueStateDr=$list(^User.DHCQueueD(QueRowId),14)
	.s QueStateCode=$list(^User.DHCPerStateD(QueStateDr),4)
	.i QueStateCode="到达" s RegNum=RegNum+1
	.i (QueStateCode="等候")||(QueStateCode="复诊") s WaitNum=WaitNum+1
	q (+RegNum)_"^"_(+WaitNum)
}

// 根据科室ID 出诊时段取该科室出诊的号别数量

// w ##class(DtPortal.OD.OD00CommonService).GetLocDocSum(49,"",+$h,+$h)

ClassMethod GetLocDocSum(LocID As %String, TimeRangeId As %String, SttDate As %String, EndDate As %String) As %String
{
	i SttDate["-" s SttDate=$zdh(SttDate,3)
	i SttDate["/" s SttDate=$zdh(SttDate,4)
	i SttDate="" s SttDate=+$h
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	i EndDate="" s EndDate=+$h
	s DocSum=0
	s RESRowId=0  f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
	.For ASDate=SttDate:1:EndDate d
    ..s ASSessStartTime=0 f  s ASSessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime)) q:ASSessStartTime=""  d
    ...s ASChildSub=0 f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub)) q:ASChildSub=""  d
    ....s ASTimeRangeDR=$p($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",17)
    ....q:(TimeRangeId'="")&&(ASTimeRangeDR'=TimeRangeId)
    ....s status=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
    ....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
    ....Q:(status="S")||(status="TR")||(status="PS")
    ....s DocSum=DocSum+1
    q DocSum
}

// 根据科室ID 出诊时段取该科室出诊号别在医生号别对照里面医生登录系统的最早时间早于出诊开始时间的数量

// w ##class(DtPortal.OD.OD00CommonService).GetLocOnScheduleDocSum(49,"",+$h,+$h)

ClassMethod GetLocOnScheduleDocSum(LocID As %String, TimeRangeId As %String, SttDate As %String, EndDate As %String) As %String
{
	i SttDate["-" s SttDate=$zdh(SttDate,3)
	i SttDate["/" s SttDate=$zdh(SttDate,4)
	i SttDate="" s SttDate=+$h
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	i EndDate="" s EndDate=+$h
	s OnScheduleDocSum=0
	s RESRowId=0  f  s RESRowId=$o(^RB("RES",0,"CTLOC",LocID,RESRowId)) q:RESRowId=""  d
	.For ASDate=SttDate:1:EndDate d
    ..s ASSessStartTime=0 f  s ASSessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime)) q:ASSessStartTime=""  d
    ...s ASChildSub=0 f  s ASChildSub=$o(^RBAS(RESRowId,0,"DateSTime",ASDate,ASSessStartTime,ASChildSub)) q:ASChildSub=""  d
    ....s ASTimeRangeDR=$p($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",17)
    ....q:(TimeRangeId'="")&&(ASTimeRangeDR'=TimeRangeId)
    ....s status=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
    ....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
    ....Q:(status="S")||(status="TR")||(status="PS")
    ....s RESCTPCPDR=$p(^RB("RES",RESRowId),"^",2)
    ....q:RESCTPCPDR="" 
    ....s DocFisrtLogTime=..GetDocFisrtLogTime(LocID,RESCTPCPDR,ASDate)
    ....s TRStartTime=$p(^DHCTimeRange(ASTimeRangeDR),"^",3)
    ....i (TRStartTime>=DocFisrtLogTime)&&(DocFisrtLogTime'=0) s OnScheduleDocSum=OnScheduleDocSum+1
    q OnScheduleDocSum
}

// 根据号别 出诊日期取号别对应医生最早登录时间

// w ##class(DtPortal.OD.OD00CommonService).GetDocFisrtLogTime(49,1568,+$h)

ClassMethod GetDocFisrtLogTime(LocID As %String, MarkDr As %String, Date As %String) As %String
{
	s MarkDrLogOnTime=0
	s DHCMarkDocId=0 f  s DHCMarkDocId=$o(^User.DHCMarkDocI("MarkddepDrIndex",LocID,DHCMarkDocId)) q:DHCMarkDocId=""  d
	.s MarkdMarkDr=$list(^User.DHCMarkDocD(DHCMarkDocId),3)
	.q:MarkdMarkDr'=MarkDr
    .s MarkdDocDr=$list(^User.DHCMarkDocD(DHCMarkDocId),2)
	.s CTPCPCode=$p($g(^CTPCP(MarkdDocDr,1)),"^",1)
	.//w MarkdDocDr,!
	.s Guser1=$$ALPHAUP^SSUTIL4(CTPCPCode)
	.s UserRowid=""
	.i Guser1'=""  d
	..s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",Guser1,"")) 
	.q:UserRowid=""
	.s Logid="",LogonTime=0
    .f  s Logid=$o(^SST("LOG",0,"Date",Date,UserRowid,Logid))  q:(Logid="")||(LogonTime'=0)  d
    ..s LogonLoc = $p($g(^SST("LOG",Logid)),"^",7)
    ..q:LogonLoc'=LocID
    ..s LogonTime=$p($g(^SST("LOG",Logid)),"^",4)
    .//w LogonTime,!
    .if ((MarkDrLogOnTime>LogonTime)||(MarkDrLogOnTime=0))&&(LogonTime'=0) s MarkDrLogOnTime=LogonTime
    q MarkDrLogOnTime
}

}
