Import SQLUser

Class web.DHCBPVISService Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 20200423 病人登记(大屏) (签到调用)
/// w ##class(web.DHCBPVISService).RisSendRegQueue("144058","196","计算机名称")
ClassMethod RisSendRegQueue(bpaIdStr As %String, userId As %String, hostName As %String, State As %String = "Reg") As %String
{
	s ret=""
	q:bpaIdStr="" "bpaIdStr不能为空！"	
	//q:userId="" "用户不能为空！"
	//q:hostName="" "计算机名称不能为空！"
	f i=1:1:$l(bpaIdStr,"^") d
		.s bpaId=$p(bpaIdStr,"^",i)
		.s ret=..SetPatInfoByID(bpaId,userId,hostName,State)
		.i ret="成功" s ret=0
	q ret
}

/// d ##class(web.DHCBPVISService).SetPatInfoByID("144058","196","计算机名称","Reg")
ClassMethod SetPatInfoByID(bpaId As %String, userId As %String, hostName As %String, State As %String) As %String
{
	s bpprId=$lg($g(^DHCBPArrange(bpaId)),1)
	s locId=$lg($g(^DHCBPPatRegister(bpprId)),34)	
	s locDesc=$p($g(^CTLOC(locId)),"^",2) //病区
	s bedDr=$lg($g(^DHCBPArrange(bpaId)),7)
	s queueNo=bedDr,bedDesc=""
	s bedDesc=$lg($g(^DHCBPC("Bed",+bedDr)),2) //床位
	s bedGroupDr=$lg($g(^DHCBPC("Bed",+bedDr)),3)
	s bedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bedGroupDr)),2)  //分区(床位组)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -1
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s arrDate=bpaDate
	s bpaDate=##class(web.DHCANOPCom).ConvertToDate(bpaDate)
	s dayPart=""
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	i bpaDaySeqNo="A" s dayPart="上午"	
	i bpaDaySeqNo="P" s dayPart="下午"
	i bpaDaySeqNo="E" s dayPart="晚上"
	s dialysisMethodDr=$lg(^DHCBPArrange(bpaId),26)
	s dialysisMethodCode=$lg($g(^DHCBPC("BloodPurificationMode",+dialysisMethodDr)),1)
	s antModeDr=$lg(^DHCBPArrange(bpaId),77)
    s antMode=$lg($g(^DHCBPC("AnticoagulantMode",+antModeDr)),2)
    s status=$lg($g(^DHCBPArrange(bpaId)),9)
    //状态判断
    q:(status="M") "已上机无法登记！"
    q:(status="F") "透析完成无法登记！"
    q:(status'="A")&&(status'="R") "患者不属于申请或者安排，无法登记！"
    i status="A" s status="申请"	
	i status="R" s status="安排"
	i status="M" s status="监护"
	i status="F" s status="完成"
	s userDesc=""
	i userId'="" s userDesc=##class(web.DHCClinicCom).GetNameById(userId)
	s startOperTime="",planEndOperTime=""	
    s userOperTime=$lg($g(^DHCBPArrange(bpaId)),105)
    i (userOperTime'=""&&userOperTime'=0) s startOperTime=userOperTime
    s planTherapyTime=$lg($g(^DHCBPArrange(bpaId)),80)
    i (startOperTime'="")&&(planTherapyTime'="")&&(planTherapyTime'=0) s planEndOperTime=startOperTime+(planTherapyTime*60)    
	i (startOperTime'="") s startOperTime=##class(web.DHCClinicCom).ConvertToTime(startOperTime)
	i (planEndOperTime'="") s planEndOperTime=##class(web.DHCClinicCom).ConvertToTime(planEndOperTime)
	s Id="",bpsiReceiveTime="",bpsiSignInNo=""	
	&sql(select %ID,BPSI_ReceiveTime,BPSI_SeqNo into :Id,:bpsiReceiveTime,:bpsiSignInNo from DHC_BP_SignIn where BPSI_RegNo=:regNo and BPSI_Date=:arrDate and BPSI_Status='N' and BPSI_DaySeqNo=:bpaDaySeqNo)
	s xmlStr = "<PatientInfo>"_"<State>"_State_"</State>"_"<IP>"_hostName_"</IP>"_"<WindowName>"_locDesc_"</WindowName>"_"<Priority>"_"普通"_"</Priority>"
		_"<QueueNo>"_queueNo_"</QueueNo>"_"<PatientName>"_patName_"</PatientName>"_"<PatientSex>"_patSex_"</PatientSex>"_"<RegisterNo>"_bpaId_"</RegisterNo>"
		_"<Department>"_locDesc_"</Department>"_"<CheckCat>"_""_"</CheckCat>"_"<ScheduleDate>"_bpaDate_"</ScheduleDate>"_"<StudyGroup>"_locDesc_"</StudyGroup>"
		_"<Doctor>"_userDesc_"</Doctor>"_"<BedGroup>"_bedGroupDesc_"</BedGroup>"
		_"<Bed>"_bedDesc_"</Bed>"_"<DayPart>"_dayPart_"</DayPart>"_"<DialysisMethod>"_dialysisMethodCode_"</DialysisMethod>"
		_"<StartOperTime>"_startOperTime_"</StartOperTime>"_"<PlanEndOperTime>"_planEndOperTime_"</PlanEndOperTime>"
		_"<ReceiveTime>"_bpsiReceiveTime_"</ReceiveTime>"_"<SignInNo>"_bpsiSignInNo_"</SignInNo>"_"</PatientInfo>"
	//s ^dhcbpVisService(bpaId,+$h,dayPart)=xmlStr
	s Rtn=""
	try
	{
		s obj=##class(web.DHCBPVISServiceInferface).%New()
		s Rtn=obj.RisSendRegQueue(xmlStr)
	}
	catch
	{
		s Rtn="调用大屏接口出错！"
	}
	q Rtn
}

/// 20200423 上机(更新病人登记信息(大屏))、透析后(保存触发，修改病人登记状态为完成，(大屏清空))
/// w ##class(web.DHCBPVISService).RisUpdatePatStatus("144058")
ClassMethod RisUpdatePatStatus(bpaIdStr As %String = "") As %String
{
	s ret=""
	q:bpaIdStr="" "bpaIdStr不能为空！"	
	f i=1:1:$l(bpaIdStr,"^") d
		.s bpaId=$p(bpaIdStr,"^",i)
		.s ret=..SetPatStatusByID(bpaId)
		.i ret="成功" s ret=0	
	q ret
}

ClassMethod SetPatStatusByID(bpaId As %String) As %String
{
	s bedDr=$lg($g(^DHCBPArrange(bpaId)),7)
	s bedDesc=$lg($g(^DHCBPC("Bed",+bedDr)),2) //床位
	s bedGroupDr=$lg($g(^DHCBPC("Bed",+bedDr)),3)
	s bedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bedGroupDr)),2)  //分区(床位组)
	s status=$lg($g(^DHCBPArrange(bpaId)),9)
	q:(status'="M")&&(status'="F") "患者未上机，无法更新状态!"
	i status="A" s status="申请"	
	i status="R" s status="安排"
	i status="M" s status="监护"
	i status="F" s status="完成"
	s dialysisMethodDr=$lg(^DHCBPArrange(bpaId),26)
	s dialysisMethodCode=$lg($g(^DHCBPC("BloodPurificationMode",+dialysisMethodDr)),1)
	s startOperTime="",planEndOperTime=""	
    s userOperTime=$lg($g(^DHCBPArrange(bpaId)),105)
    i (userOperTime'=""&&userOperTime'=0) s startOperTime=userOperTime
    s planTherapyTime=$lg($g(^DHCBPArrange(bpaId)),80)
    i (planTherapyTime'=""&&planTherapyTime'=0) s planEndOperTime=startOperTime+(planTherapyTime*60)    
	i (startOperTime'="") s startOperTime=##class(web.DHCClinicCom).ConvertToTime(startOperTime)
	i (planEndOperTime'="") s planEndOperTime=##class(web.DHCClinicCom).ConvertToTime(planEndOperTime)
	s xmlStr = "<PatientInfo>"_"<RegisterNo>"_bpaId_"</RegisterNo>"_"<Status>"_status_"</Status>"
	_"<Bed>"_bedDesc_"</Bed>"_"<BedGroup>"_bedGroupDesc_"</BedGroup>"_"<DialysisMethod>"_dialysisMethodCode_"</DialysisMethod>"
	_"<StartOperTime>"_startOperTime_"</StartOperTime>"_"<PlanEndOperTime>"_planEndOperTime_"</PlanEndOperTime>"
	_"</PatientInfo>"
	//s ^dhcbpVisService(bpaId,+$h,dayPart,patStatus)=xmlStr
	s Rtn=""
	try
	{
		s obj=##class(web.DHCBPVISServiceInferface).%New()
		s Rtn=obj.RisUpdatePatStatus(xmlStr)
	}
	catch
	{
		s Rtn="调用大屏接口出错！"
	}
	q Rtn
}

/// 20200423 病人呼叫(签到界面呼叫)
/// w ##class(web.DHCBPVISService).RisSendVoice("144058","196","计算机名称")
ClassMethod RisSendVoice(bpaIdStr As %String = "", userId As %String, hostName As %String) As %String
{
	s ret=""
	q:bpaIdStr="" "bpaIdStr不能为空！"	
	q:userId="" "用户不能为空！"
	q:hostName="" "计算机名称不能为空！"
	f i=1:1:$l(bpaIdStr,"^") d
		.s bpaId=$p(bpaIdStr,"^",i)
		.s ret=..SetRisSendVoiceByID(bpaId,userId,hostName)
		.i ret="成功" s ret=0
	q ret
}

// w ##class(web.DHCBPVISService).SetRisSendVoiceByID("114192","196","M910T-904")

ClassMethod SetRisSendVoiceByID(bpaId As %String, userId As %String, hostName As %String) As %String
{
	
	s bpprId=$lg($g(^DHCBPArrange(bpaId)),1)
	s locId=$lg($g(^DHCBPPatRegister(bpprId)),34)
	s locDesc=$p($g(^CTLOC(locId)),"^",2) //病区
	s bedDr=$lg($g(^DHCBPArrange(bpaId)),7)
	s queueNo="",bedDesc=""	
	s bedDesc=$lg($g(^DHCBPC("Bed",+bedDr)),2) //床位
	s papmiId=$lg($g(^DHCBPPatRegister(bpprId)),1)
	q:papmiId="" -1	
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s dayPart=""
	s bpaDaySeqNo=$lg($g(^DHCBPArrange(bpaId)),6)
	i bpaDaySeqNo="A" s dayPart="上午"	
	i bpaDaySeqNo="P" s dayPart="下午"
	i bpaDaySeqNo="E" s dayPart="晚上"
    s status=$lg($g(^DHCBPArrange(bpaId)),9)
    q:(status="D") "透析已取消，无法呼叫！"
    i status="A" s status="申请"	
	i status="R" s status="安排"
	i status="M" s status="监护"
	i status="F" s status="完成"
	s userDesc=##class(web.DHCClinicCom).GetNameById(userId)	
	s xmlStr = "<PatientInfo>"_"<WindowName>"_locDesc_"</WindowName>"_"<WindowIP>"_hostName_"</WindowIP>"_"<WindowDoctor>"_userDesc_"</WindowDoctor>"
		_"<WindowDocPro></WindowDocPro>"_"<WindowDept></WindowDept>"_"<WindowNote>"_"说明"_"</WindowNote>"
		_"<VisitingPatient>"_"<Name>"_patName_"</Name>"_"<Sex>"_patSex_"</Sex>"_"<Priority>"_"普通"_"</Priority>"		
		_"<QueueNo>"_queueNo_"</QueueNo>"_"<RegisterNo>"_bpaId_"</RegisterNo>"_"<Department>"_locDesc_"</Department>"
		_"</VisitingPatient></PatientInfo>"	
	//s ^dhcbpVisService(bpaId,+$h,dayPart,"Voice")=xmlStr
	s Rtn=""
	try
	{
		s obj=##class(web.DHCBPVISServiceInferface).%New()
		s Rtn=obj.RisSendVoice(xmlStr)
	}
	catch
	{
		s Rtn="调用叫号接口出错！"
	} 
	q Rtn
}

}
