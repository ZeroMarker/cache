Class web.DHCCPSchedBatch Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod CheckApptList(ApptMsgStr As %String) As %String
{
	Set RetStr=""	
	Set CardNo=$P(ApptMsgStr,"^",1)			;病人卡号
	Set PatientName=$P(ApptMsgStr,"^",2)	;病人姓名
	Set ApptDate=$P(ApptMsgStr,"^",3)		;完成预约日期
	Set AdmDate=$P(ApptMsgStr,"^",4)		;预约就诊日期
	Set DocCode=$P(ApptMsgStr,"^",5)		;医生工号
	Set DocName=$P(ApptMsgStr,"^",6)		;医生姓名
	Set AdmTime=$P(ApptMsgStr,"^",7)		;就诊时段	
	Set QueueNo=$P(ApptMsgStr,"^",8)		;挂号流水号
	Set RoomCode=$P(ApptMsgStr,"^",9)		;诊室代码
	Set LocCode=$P(ApptMsgStr,"^",10)		;科室代码
	Set Speci=$P(ApptMsgStr,"^",11)			;亚专业
	Set DocClass=$P(ApptMsgStr,"^",12)		;出诊级别
	Set RegFee=$P(ApptMsgStr,"^",13)		;挂号/预约/诊察费
	//
	//检查病人姓名是否存在
	If PatientName="" Set RetStr(1)=PatientName_" 不存在" Quit RetStr
	Set PAPMI=$O(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(PatientName),""))
	If PAPMI="" Set RetStr(1)=PatientName_" 不存在" Quit RetStr
	//
	//检查卡是否存在
	If CardNo="" Set RetStr(2)=CardNo_" 卡号不存在" Quit RetStr
	Set len=$L(CardNo)
	Set fstr="" If len<12 Set flen=12-len+1,$P(fstr,"0",flen)=""
	Set CardNo=fstr_CardNo
	Set CardDr=$O(^DHCCARDi("CF",0,"CardNo",CardNo,""))
	If CardDr="" Set RetStr(2)=CardNo_" 卡号不存在" Quit RetStr
	//
	Set CardPMI=$P($g(^DHCCARD("CF",CardDr)),"^",4)
	If PAPMI'=CardPMI Set RetStr(3)="卡号和姓名不对应" Quit RetStr
	//
	//检查医生
	If DocCode=""  Set RetStr(4)="医生代码不存在" Quit RetStr
	Set DocDr=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(DocCode),""))
	If DocDr="" Set RetStr(4)="医生代码不存在" Quit RetStr
	If DocName="" Set RetStr(5)="医生姓名不存在" Quit RetStr
	Set DocDr1=$O(^CTPCP(0,"Desc",$$ALPHAUP^SSUTIL4(DocName),""))
	If DocDr1="" Set RetStr(5)="医生姓名不存在" Quit RetStr
	If DocDr'=DocDr2 Set RetStr(6)="医生代码姓名不对应" Quit RetStr
	//
	//就诊时段/就诊诊室/就诊科室/亚专业/出诊级别
	If AdmTime="" Set RetStr(7)="就诊时段不存在" Quit RetStr
	Set TimeRange="",Tflag=0
	Set TimeDr=0 For  Set TimeDr=$O(^DHCTimeRange(TimeDr)) Quit:TimeDr=""!(Tflag'=0)  Do
	.Set TimeCode=$P($g(^DHCTimeRange(TimeDr)),"^",1)
	.If TimeCode=AdmTime Set Tflag=1,TimeRange=TimeDr
	If TimeRange="" Set RetStr(7)="就诊时段不存在" Quit RetStr
	//
	If RoomCode="" Set RetStr(8)="诊室代码不存在" Quit RetStr
	Set RoomDr=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(RoomCode),""))
	If RoomDr="" Set RetStr(8)="诊室代码不存在" Quit RetStr
	//
	If LocCode="" Set RetStr(9)="科室代码不存在" Quit RetStr
	Set LocDr=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),""))
	If LocDr="" Set RetStr(9)="科室代码不存在" Quit RetStr
	//
	If Speci="" Set RetStr(10)="亚专业代码不存在" Quit RetStr
	Set SpeciDr=$O(^RBC("CLGRP",0,"Code",$$ALPHAUP^SSUTIL4(Speci),""))
	If SpeciDr="" Set RetStr(10)="亚专业代码不存在" Quit RetStr
	//
	Set BookDate=$ZDH(ApptDate,3)
	Set AdmDate=$ZDH(AdmDate,3)
	If BookDate=0 Set RetStr(11)="完成预约日期格式不对" Quit RetStr
	If AdmDate=0 Set RetStr(12)="预约就诊日期格式不对" Quit RetStr
	//
	//确定资源
	Set ResRowId=$O(^RB("RES",0,"CTPCP",DocDr,LocDr,""))
	If ResRowId="" Set RetStr(13)="资源未定义" Quit RetStr
	//确定排班记录
	Set ASId=""
	Set StartTime=0 For  Set StartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,StartTime)) Quit:StartTime=""!(ASId'="")  Do
	.Set SessTimeRange=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	.If SessTimeRange'=TimeRange Quit
	.Set ASId=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,StartTime,""))
	If ASId="" Set RetStr(14)="未找到排班记录" Quit RetStr
	//
	Set ApptSched=ResRowId_"||"_ASId
	//
	Set Fee=##Class(web.DHCOPAdmReg).GetScheduleFee(ApptSched,"",+$H,"")
}

ClassMethod GeneCheck() As %String
{
	Set Ret=##class(web.DHCRBAppointment).CreateBreakRecord(+$H)
	Quit Ret
}

/// desc 生成排版记录
/// input ：
/// StartDate 开始日期 
/// EndDate	 结束日期
/// Mode		更新方式 0:不更新  非0:更新
/// DepID    生成排版科室 无值生成所有科室
/// MarkID   生成排班好别 无值生成所有号别
ClassMethod GeneSched(StartDate As %Date, EndDate As %Date, Mode As %String, SchStr As %String = "", weekflag As %String = "", ASSESSRowIdStr As %String = "", ScheduleLinesRowId As %String = "", HospID = "") As %String
{
    s ^TEMP("web.DHCCPSchedBatch.GeneSched")="Do ##class(web.DHCRBApptSchedule).CreateDaysSchedule("_StartDate_","_EndDate_","_Mode_")"
	If StartDate'="" {
		i StartDate["/" Set StartDate=$ZDH(StartDate,4)
		i StartDate["-" Set StartDate=$ZDH(StartDate,3)
	}
	If EndDate'="" {
		i EndDate["/" Set EndDate=$ZDH(EndDate,4)
		i EndDate["-" Set EndDate=$ZDH(EndDate,3)
	}
	//Q:((+EndDate)-(+StartDate))>180 "-1^日期超过180天.请重新选择!"
	//If Mode="on" Set Mode="1" else  Set Mode="0"
	s userGroup=$Get(%session.Data("LOGON.GROUPID"))
	s UserID=$Get(%session.Data("LOGON.USERID"))
	s locstr=##class(web.DHCRBApptSchedule).CreateDaysSchedule(StartDate,EndDate,Mode,userGroup,UserID,SchStr,weekflag,ASSESSRowIdStr,ScheduleLinesRowId,HospID)
	;do ##class(web.DHCRBApptSchedule).CreateDaysSchedule(StartDate,EndDate,Mode,userGroup)
	Quit locstr
}

ClassMethod GetBlackListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBlackListExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetBlackListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	Set BL=0
	For  Set BL=$O(^DHCPBL(BL)) Quit:BL=""  Do
	.Set PatientID=$P($g(^DHCPBL(BL)),"^",2)
	.Quit:PatientID=""
	.Quit:'$D(^PAPER(PatientID))
	.Set Type=$P($g(^DHCPBL(BL)),"^",1)
	.Set Status=$P($g(^DHCPBL(BL)),"^",3)
	.Set AddDate=$P($g(^DHCPBL(BL)),"^",4)
	.If AddDate'="" Set AddDate=$ZD(AddDate,3)
	.Set AddTime=$P($g(^DHCPBL(BL)),"^",5)
	.If AddTime'="" Set AddTime=..%ZT(AddTime,3)
	.Set PatientName=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	.Set SEX=""
	.Set SEXDr=$P($g(^PAPER(PatientID,"ALL")),"^",7)
	.If SEXDr'="" Set SEX=$P($g(^CT("SEX",SEXDr)),"^",2)
	.Set DOB=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	.If DOB'="" Set DOB=$ZD(DOB,3)
	.Set Data=$LB(PatientID,PatientName,SEX,DOB,Type,Status,AddDate,AddTime)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	//
	//Set PatientID="460",PatientName="AAASS",Type="预约"
	//Set DOB="2007-12-04",Status="有效",AddDate="2007-11-22",AddTime="12:12:12"
	//Set SEX="男"
	;
	//Set Data=$LB(PatientID,PatientName,SEX,DOB,Type,Status,AddDate,AddTime)
	//Set ^CacheTemp(repid,ind)=Data
	//Set ind=ind+1
	//
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetBlackListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBlackListExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBreakApptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBreakApptExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetBreakApptExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set ApptId=""
	For  Set ApptId=$O(^DHCSchedBatchLog("BREAK",+$H,ApptId)) Quit:ApptId=""  Do
	.Set ResRowId=+ApptId
	.Set ASChild=$p(ApptId,"||",2)
	.Set APPChild=$p(ApptId,"||",3)
	.s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	.s DepRowId=$P(^RB("RES",ResRowId),"^",1)
	.s DocRowId=$P(^RB("RES",ResRowId),"^",2)
	.s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
	.;
	.;预约科室
	.s ApptLoc=$p($g(^CTLOC(DepRowId)),"^",2)
	.;
	.;时段
	.Set SessStartTime=$P($g(^RBAS(ResRowId,ASChild)),"^",4)
	.Set SessTimeRange=##class(web.DHCRBResSession).GetTimeRangeByTime(SessStartTime)
	.Set TimeRangeDesc=""
	.If SessTimeRange'="" Set TimeRangeDesc=$P($g(^DHCTimeRange(SessTimeRange)),"^",2)
	.;
	.Set RBAS=DocDesc
	.If TimeRangeDesc'="" Set RBAS=RBAS_"("_TimeRangeDesc_")"
	.;
	.;预约人姓名
	.s PatientID=$P(Appt,"^",2)
	.s PatientName=""
	.if PatientID'="" s PatientName=$p(^PAPER(PatientID,"ALL"),"^",1)
	.;
	.;预约流水号
	.s QueueNo=$P(Appt,"^",5)
	.;
	.;就诊日期
	.Set ApptDate=$P(Appt,"^",5)
	.;
	.;办理预约日期,预约时间,预约办理人
	.s BookDate=$P(Appt,"^",8)
	.If BookDate'="" Set BookDate=$ZD(BookDate,3)
	.s BookTime=$P(Appt,"^",9)
	.If BookTime'="" Set BookTime=..%ZT(BookTime,3)
	.s BookUserDR=$P(Appt,"^",11)
	.s BookUser=""
	.i BookUserDR'="" s BookUser=$p($g(^SSU("SSUSR",BookUserDR)),"^",2)
	.;
	.;s MethodDR=$P(Appt,"^",12)
	.;s MethodDesc=""
	.;i MethodDR'="" s MethodDesc=$P(^RBC("APTM",MethodDR),"^",2)
	.;
	.Set Data=$LB(PatientID,ApptId,PatientName,RBAS,ApptDate,QueueNo,BookDate,BookTime,BookUser,ApptLoc)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	;
	;Set PatientID="460",ApptId="461",PatientName="AAASS",RBAS="AA医生(上午)"
	;Set ApptDate="2007-12-04",QueueNo="09",BookDate="2007-11-22",BookTime="12:12:12"
	;Set BookUser="CCC",ApptLoc="检查科"
	;
	;Set Data=$LB(PatientID,ApptId,PatientName,RBAS,ApptDate,QueueNo,BookDate,BookTime,BookUser,ApptLoc)
	;Set ^CacheTemp(repid,ind)=Data
	;Set ind=ind+1
	;
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetBreakApptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBreakApptExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SendBatchDocMsg(Loc As %String) As %String
{
	Set DocStr=""
	Set Doc=0
	if Loc'=""  d
	.For  Set Doc=$O(^DHCSchedBatchLog("SCHED",+$h,Loc,Doc)) Quit:Doc=""  Do
	..Set DocName=^DHCSchedBatchLog("SCHED",+$h,Loc,Doc)
	..if DocStr="" Set DocStr=Doc_"^"_DocName
	..else  Set DocStr=DocStr_$C(1)_Doc_"^"_DocName
	Quit DocStr
}

ClassMethod SendBatchLocMsg() As %String
{
	Set LocStr=""
	Set Loc=0
	For  Set Loc=$O(^DHCSchedBatchLog("SCHED",+$h,Loc)) Quit:Loc=""  Do
	.Set LocDesc=^DHCSchedBatchLog("SCHED",+$h,Loc)
	.if LocStr="" Set LocStr=Loc_"^"_LocDesc
	.else  Set LocStr=LocStr_$C(1)_Loc_"^"_LocDesc
	Quit LocStr
}

Query GetBlackList() As %Query(ROWSPEC = "PatientID:%String,PatientName:%String,SEX:%String,DOB:%String,Type:%String,Status:%String,AddDate:%String,AddTime:%String,")
{
}

Query GetBreakAppt() As %Query(ROWSPEC = "PatientID:%String,ApptID:%String,PatientName:%String,RBAS:%String,ApptDate:%String,QueueNo:%String,BookDate:%String,BookTime:%String,BookUser:%String,ApptLoc:%String")
{
}

/// w ##class(web.DHCCPSchedBatch).GetLocList()
ClassMethod GetLocList()
{
	Set str=""
	s TypeStr="O^E"
	for i=1:1:$l(TypeStr,"^") d
	.s Type=$p(TypeStr,"^",i)
	.Set LocRowid=0
	.f  s LocRowid=$O(^PAC("ADMLOC",0,"AdmType",Type,LocRowid)) Q:LocRowid=""  d
	..Q:'$d(^RB("RES",0,"CTLOC",LocRowid))
	..s Desc=$p($g(^CTLOC(LocRowid)),"^",2)
	..if str="" Set str=LocRowid_","_Desc
	..else  Set str=str_"^"_LocRowid_","_Desc
	Quit str
}

/// w ##class(web.DHCCPSchedBatch).GetLocList()
ClassMethod GetDocList(LocRowid As %String)
{
	Set str=""
	Set ResRowid=0
	for  Set ResRowid=$o(^RB("RES",0,"CTLOC",LocRowid,ResRowid)) Quit:ResRowid=""  do
	.s CTPCPRowId=$P(^RB("RES",ResRowid),"^",2)
	.Q:CTPCPRowId=""
	.s ScheSt=$p(^RB("RES",ResRowid),"^",6)
	.Quit:ScheSt'="Y"
	.Quit:('$d(^CTPCP(CTPCPRowId,1)))
	.Set Desc=$p(^CTPCP(CTPCPRowId,1),"^",2)
	.if str=""  Set str=LocRowid_"|"_CTPCPRowId_","_Desc
	.else  Set str=str_"^"_LocRowid_"|"_CTPCPRowId_","_Desc
	Quit str
}

Query GetLocListNew() As %Query(ROWSPEC = "LocId:%String,LocDesc:%String")
{
}

ClassMethod GetLocListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListNewExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetLocListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListNewExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocListNewExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	Set str=""
	s TypeStr="O^E"
	for i=1:1:$l(TypeStr,"^") d
	.s Type=$p(TypeStr,"^",i)
	.Set LocRowid=0
	.f  s LocRowid=$O(^PAC("ADMLOC",0,"AdmType",Type,LocRowid)) Q:LocRowid=""  d
	..Q:'$d(^RB("RES",0,"CTLOC",LocRowid))
	..s Desc=$p($g(^CTLOC(LocRowid)),"^",2)
	..Set Data=$LB(LocRowid,Desc)
	..Set ^CacheTemp(repid,ind)=Data
	..Set ind=ind+1

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

Query GetDocListNew(LocRowid As %String) As %Query(ROWSPEC = "DocId:%String,DocDesc:%String")
{
}

ClassMethod GetDocListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocListNewExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDocListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocListNewExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDocListNewExecute(ByRef qHandle As %Binary, LocRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ResRowid=0
	for  Set ResRowid=$o(^RB("RES",0,"CTLOC",LocRowid,ResRowid)) Quit:ResRowid=""  do
	.s CTPCPRowId=$P(^RB("RES",ResRowid),"^",2)
	.Q:CTPCPRowId=""
	.s ScheSt=$p(^RB("RES",ResRowid),"^",6)
	.Quit:ScheSt'="Y"
	.Quit:('$d(^CTPCP(CTPCPRowId,1)))
	.Set Desc=$p(^CTPCP(CTPCPRowId,1),"^",2)
	.Set Data=$LB(LocRowid_"|"_CTPCPRowId,Desc)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
