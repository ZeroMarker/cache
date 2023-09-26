Class CIS.AN.BL.DayCalendar Extends %RegisteredObject
{

ClassMethod GetDocLocType(userLocId, userId, groupId)
{
	s ret=""
	s userLocTyp=$P(^CTLOC(userLocId),"^",13)
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"
	i ctcptInternalType="NURSE"&(userLocTyp="OP") s ret="OPNURSE"
	i ctcptInternalType="DOCTOR"&(userLocTyp="OP") s ret="ANDOCTOR"
	i ctcptInternalType="NURSE"&(userLocTyp="E") s ret="WARDNURSE"
	i ctcptInternalType="DOCTOR"&(userLocTyp="E") s ret="DOCTOR"
	e  s ret="DOCTOR"
	q ret
}

/// 日间手术日程
ClassMethod GetDayEstInfo(operDataID, dataItem) As %String
{
	s dataValue=""
	&sql(select RowId into :operSheetId from CIS_AN.RecordSheet where  OperSchedule=:operDataID)
	&sql(select DataValue into :dataValue from CIS_AN.OperData where RecordSheet=:operSheetId and DataItem=:dataItem)
	q dataValue
}

/// 20210911+南山日程
/// w ##class(CIS.AN.BL.DayCalendar).GetScheduleList("2021-12-08","95")
/// w ##class(CIS.AN.BL.DayCalendar).GetScheduleList("2021-12-08","","","0000000124","")
/// d ##class(CIS.AN.BL.DayCalendar).GetScheduleList("2020-11-06","2020-11-06","213","{""StatusCode"":""Audit^Finish""}")
/// d ##class(CIS.AN.BL.DayCalendar).GetScheduleList("2020-11-07","2020-11-07","213","{}")
/// d ##class(CIS.AN.BL.DayCalendar).GetScheduleList("2020-11-06","2020-11-06","236","{}")
/// d ##class(CIS.AN.BL.DayCalendar).GetScheduleList("2020-11-06","2020-11-06","666","{""StatusCode"":""Finish""}")
/// d ##class(CIS.AN.BL.DayCalendar).GetScheduleList("2020-11-06","2020-11-06","213","{""StatusCode"":""Finish"",""RegNo"":""0020044871""}")
ClassMethod GetScheduleList(startDate, userDeptID As %String = "", regNo As %String = "", patName As %String = "", surgeon As %String = "") As %String
{
	s retStr=""
	if (regNo'="") d
		.set opsIdStr=..GetOpsIdListByRegNo(regNo)
		.if (opsIdStr'="") d
		..s oplen=$l(opsIdStr,",")
		..f onum=1:1:oplen d
		...s curOpsId=$p(opsIdStr,",",onum)
		...q:+curOpsId=0
		...set ret=..GetOperScheduleNew(curOpsId)
		...i retStr'="" s retStr=retStr_","_ret
		...e  s retStr=ret
	quit:retStr'="" "["_retStr_"]"
	i patName'="" d
	.s papmiId=$o(^PAPERi("PAPER_PatName",patName,""))
	.i papmiId>0 d
		..s regNo2=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		..set opsIdStr=..GetOpsIdListByRegNo(regNo2)
		..if (opsIdStr'="") d
		...s oplen=$l(opsIdStr,",")
		...f onum=1:1:oplen d
		....s curOpsId=$p(opsIdStr,",",onum)
		....q:+curOpsId=0
		....set ret=..GetOperScheduleNew(curOpsId)
		....i retStr'="" s retStr=retStr_","_ret
		....e  s retStr=ret
	quit:retStr'="" "["_retStr_"]"
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=startDateH
	//set deptConfig=..GetDeptConfig(userDeptID)
	set appDeptType="^IN^OUT^EM^"
	 set linkDeptStr=##class(CIS.AN.BL.Admission).GetLinkLocId(userDeptID)
    //  set EMStatusID=##class(CIS.AN.BL.AnaArrange).GetEMStatusCodeList()   //启用审核急诊手术配置时,可查询的急诊手术状态代码 YuanLin 20200515
    if (linkDeptStr="")
    {
        set linkDeptStr=userDeptID  
    }
    else
    {
        set linkDeptStr=linkDeptStr_"^"_userDeptID
    }

	k ^TMPOPS($j)
	s date=startDateH
	set curOpsId=0
	f  s curOpsId=$o(^CIS.AN.OperScheduleI("OPDate",date,curOpsId)) q:curOpsId=""  d
		.quit:(curOpsId="")
		.set curOps=##class(CIS.AN.OperSchedule).%OpenId(curOpsId)
		.set curRegNo=##class(CIS.AN.BL.Admission).GetRegNobyEpisodeID(curOps.EpisodeID)
		.quit:(regNo'="")&(regNo'=curRegNo)
		.
		.q:curOps.DaySurgery'="Y"
		.s operAppDeptId=curOps.AppDeptID	;申请科室
		.s OperExecDeptID=curOps.OperExecDeptID	;预住院科室
		.s centerFlag="N",centerLocStr=""
		.s newUserLocId=userDeptID
        .i newUserLocId'="" d
	        ..s centerFlag=##class(web.DHCBL.CT.ORCDaySurgeryLoc).IsDaySurgeryLoc(newUserLocId)
        .s centerLocStr=##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).GetLinkLoc(newUserLocId)
		.;日间中心能看的手术
		.s centerLocSee1=(("^"_centerLocStr_"^")'[("^"_OperExecDeptID_"^"))&(centerFlag="Y")
		.s centerLocSee2=(("^"_centerLocStr_"^")'[("^"_operAppDeptId_"^"))&(centerFlag="Y")
		.q:(centerLocSee1)&&(centerLocSee2)&&(centerFlag="Y")
		.b	;2
		.s showOperFlag=(("^"_userDeptID_"^")'[("^"_operAppDeptId_"^"))
		.s showPreOperFlag=(("^"_userDeptID_"^")'[("^"_OperExecDeptID_"^"))
		.q:(centerFlag="N")&(showPreOperFlag)&(showOperFlag)&(userDeptID'="")
		.set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(curOpsId)
		.b	;1
		.quit:((","_operListObj.Surgeon_",") '[ (","_surgeon_","))&(surgeon'="")
		.set ret=..GetOperScheduleNew(curOpsId)
		.i retStr'="" s retStr=retStr_","_ret
		.e  s retStr=ret
	q "["_retStr_"]"
}

ClassMethod GetDeptConfig(deptId As %String) As CF.AN.Department
{
	set deptConfigId=0
	&sql(select RowId into :deptConfigId from CF_AN.Department where DeptID=:deptId)
	set deptConfig=##class(CF.AN.Department).%OpenId(deptConfigId)
	set ret=##class(%DynamicObject).%New()
	set ret.DeptType="",ret.DSAdmDept="",ret.DSSurgeonDept="",ret.OperDept=""
	if ($isobject(deptConfig))
	{
		set ret.DeptType=deptConfig.ProType
		set ret.DSAdmDept=deptConfig.DSAdmDept
		set ret.DSSurgeonDept=deptConfig.DSSurgeonDept
		set ret.OperDept=deptConfig.OperDept	
	} 
	quit ret
}

/// w ##class(CIS.AN.BL.OperScheduleList).GetOperScheduleNew(4)
ClassMethod GetOperScheduleNew(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ops=##class(%DynamicObject).%New()
	set ops.RowId=opsId
	set ops.OPSID=opsId
	// 获取患者信息
	set ops.EpisodeID=operSchedule.EpisodeID
	//set ops.PatName=operSchedule.PatName
	
	//if (ops.PatName="")
    //{
    Set PatientID=$P(^PAADM(ops.EpisodeID),"^",1)
    Set ops.PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
    //}
	set ops.PatGender=operSchedule.PatGender
	set ops.PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,+$h)
	set ops.RegNo=operSchedule.RegNo
	set ops.MedcareNo=operSchedule.MedicareNo
	set Loc=$P($g(^PAADM(ops.EpisodeID)),"^",4)
	set AdmBedId=$P($g(^PAADM(ops.EpisodeID)),"^",73)
	
	// 手术申请信息
	set ops.AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
	set ops.PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
    set:ops.PatDeptDesc="" ops.PatDeptDesc=##class(web.DHCDocInPatientList).RemoveAlias($P($g(^CTLOC(Loc)),"^",2))
	set ops.PatWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",operSchedule.PatWardID)
	set ops.PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
    if AdmBedId'="" set:ops.PatBedCode="" ops.PatBedCode=$P($g(^PAWARD(+AdmBedId,"BED",$P(AdmBedId,"||",2))),"^",1)
	set ops.AppDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
	set ops.OperDeptID=operSchedule.OperDeptID				// 手术室
	set ops.OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
	set ops.AnaDept=operSchedule.AnaDept					// 麻醉科室
	set ops.AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
	
	//20200628
	set ops.OperExecDeptID=operSchedule.OperExecDeptID				// 日间预住院科室
	set ops.OperExecDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperExecDeptID)
	set ops.SourceType=operSchedule.SourceType				// 手术类型
	set ops.SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
	set ops.Status=operSchedule.Status.%Id()
	set ops.StatusDesc=operSchedule.Status.Description		// 手术状态名称
	set ops.StatusColor=operSchedule.Status.BGColor			// 手术状态背景颜色
	set ops.StatusCode=operSchedule.Status.Code				// 手术状态代码
	set ops.DaySurgeryNote=operSchedule.DaySurgeryNote
	set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")			// 手术日期(计划)
	set DateFormat=$lg(^websys.ConfigurationD(1),10)
	if ((DateFormat="DMY")&&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
	set ops.AppDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)
	set ops.AuditDT=""
	set ops.OperDate=OperDate
	set ops.OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")			// 手术开始时间(计划)
	set ops.DaySurgery=operSchedule.DaySurgery  // 202002+dyl+日间手术
	set ops.OPAdmType=operSchedule.OPAdmType	//202003+dyl+门诊手术
	set ops.PlanSeq=operSchedule.PlanSeq					// 计划台次
	set ops.SeqType=operSchedule.SeqType					// 台次类型(正常台，连台)
	set ops.SeqTypeDesc=##class(CIS.AN.OperSchedule).SeqTypeLogicalToDisplay(operSchedule.SeqType)
	set ops.PrevDiagnosis=$tr(operSchedule.PrevDiagnosis,$c(4),"")		// 术前诊断
	set ops.PrevDiagnosisDesc=..GetDiagnosisDesc(ops.PrevDiagnosis)		// 术前诊断描述
	set ops.PostDiagnosis=operSchedule.PostDiagnosis		// 术后诊断
	set ops.PostDiagnosisDesc=..GetDiagnosisDesc(ops.PostDiagnosis)
	
	k operData
	set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)					// 实施手术
	set ops.BodySite=operListObj.BodySite
	set ops.BodySiteDesc=operListObj.BodySiteDesc
	set ops.OperPosition=operSchedule.OperPosition					// 手术体位
	Set ops.OperPositionDesc=..GetOperPosDesc(operSchedule.OperPosition)			// 手术体位名称
	set ops.OperClass=operListObj.OperClass		// 手术分级
	set ops.OperClassDesc=operListObj.OperClassDesc		// 手术分级名称
	set ops.BladeType=operListObj.BladeType		// 切口类型
	set ops.BladeTypeDesc=operListObj.BladeTypeDesc
	set ops.SurIntership=operSchedule.SurIntership					// 实习进修人员
	set ops.SurVisitors=operSchedule.SurVisitors					// 手术参观人员
	
	set ops.OperDesc=operListObj.OperDesc					// 实施手术名称
	set ops.OperNote=operListObj.OperNote						// 实施手术名称备注
	set:(ops.OperDesc="") ops.OperDesc=ops.OperNote
	set ops.SurgeonDesc=operListObj.SurgeonDesc					// 实施手术医生姓名
	set ops.AsstDesc=operListObj.AssistantDesc					// 实施手术助手姓名
	set ops.SurgeonExpert=operListObj.SurgeonExpert				// 实施手术专家主刀
	
	
	// 手术排班信息
	set OperRoom="",RoomDesc=""					// 手术间
	if (operSchedule.OperRoom'="")
	{
		set OperRoom=operSchedule.OperRoom.%Id()				// 手术间ID
		set RoomDesc=operSchedule.OperRoom.Description			// 手术间名称
	}
	set ops.OperRoom=OperRoom
	set ops.RoomDesc=RoomDesc
	set ops.OperSeq=operSchedule.OperSeq							// 手术台次
	set ops.PlanOperSeq=operSchedule.PlanSeq
	set ops.ScrubNurse=operSchedule.ScrubNurse						// 器械护士，多个护士以","拼接
	set ops.ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ScrubNurse)		// 器械护士姓名
	set ops.CircualNurse=operSchedule.CircualNurse					// 巡回护士，多个护士以","拼接
	set ops.CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.CircualNurse)	// 巡回护士姓名
	
	// 麻醉信息
	set ops.AnaestID=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))	// 麻醉申请ID
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(ops.AnaestID)
	if (anaesthesia'=""){
	set ops.AnaMethod=anaesthesia.AnaMethod	// 麻醉方法ID
	set ops.AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",ops.AnaMethod)	// 麻醉方法名称
	set ops.AnaExpert=anaesthesia.AnaExpert	// 麻醉指导
	set ops.AnaExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.AnaExpert)	// 麻醉指导姓名
	set ops.Anesthesiologist=anaesthesia.Anesthesiologist	// 麻醉医生
	set ops.AnesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.Anesthesiologist)	// 麻醉医生姓名
	set ops.AnaAssistant=anaesthesia.AnaAssistant	//anaestObj.GetValue("AnaAssistant")			// 麻醉助手
	set ops.AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ops.AnaAssistant)		// 麻醉助手姓名
	set ops.AnaStaff=anaesthesia.AnaStaff	// 实习进修
	}
	set ops.AppDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)	// 手术申请日期时间
	set ops.AnaestMethod=..GetAnaestMethod(opsId)
	set ops.OPAID=operSchedule.ExternalID
	set ops.Infection=$$GetInfection()		// 感染四项阳性情况
	set ops.Requirement=$$GetRequirement()	// 手术要求
	set ops.ArrPrintFlag=operSchedule.ArrPrintFlag
	set ops.OPFeeFlag=operSchedule.OPFeeFlag		// 手术费用审核标志
	set ops.OPFeeFlagDesc=$CASE(ops.OPFeeFlag,"N":"否","Y":"是",:"")
	set ops.ANFeeFlag=operSchedule.ANFeeFlag		// 麻醉费用审核标志
	set ops.ANFeeFlagDesc=$CASE(ops.ANFeeFlag,"N":"否","Y":"是",:"")
	set OperRequirement=operSchedule.OperRequirement
	set:(OperRequirement["感染手术") ops.InfectionOperDesc="是"
	set:(OperRequirement["使用抗菌药物") ops.AntibiosisDesc="是"
	set ops.ExtAnaestID=operSchedule.ExtAnaestID
	quit ops.%ToJSON()
GetInfection()
	set infectionA="",infectionB=""
	set:(operSchedule.HivAb="+") infectionA=infectionA_"艾滋阳性"
	set:(operSchedule.HivAb="-") infectionB="阴性"
	
	set:(operSchedule.HcvAb="+") infectionA=infectionA_"丙肝阳性"
	set:(operSchedule.HcvAb="-") infectionB="阴性"
	
	set:(operSchedule.HbsAg="+") infectionA=infectionA_"乙肝阳性"
	set:(operSchedule.HbsAg="-") infectionB="阴性"
	
	set:(operSchedule.Syphilis="+") infectionA=infectionA_"梅毒阳性"
	set:(operSchedule.Syphilis="-") infectionB="阴性"
	
	quit:(infectionA="") infectionB
	quit infectionA
GetRequirement()
	set requirement=""
	set:(operSchedule.SurgicalMaterials'="") requirement=operSchedule.SurgicalMaterials_";"_requirement
	set:(operSchedule.SpecialConditions'="") requirement=operSchedule.SpecialConditions_";"_requirement
	set:(operSchedule.HighConsume'="") requirement=operSchedule.HighConsume_";"_requirement
	//set requirement=$lts(requirement,";")
	quit requirement
}

ClassMethod GetDiagnosisDesc(diagnosis As %String) As %String [ SqlProc ]
{
	set ret=diagnosis,diagStr=""
	set diagnosisCount=$l(diagnosis,"&&&")
	for i=1:1:diagnosisCount
	{
		set curDiagnosis=$p(diagnosis,"&&&",i)
		set diagId=$p(curDiagnosis,"###",1)
		set diagDesc=$p(curDiagnosis,"###",2)
		set diagNote=$p(curDiagnosis,"###",3)
		set descNote=diagDesc
		set:(diagDesc'="")&(diagNote'="") descNote=descNote_"("_diagNote_")"
		set:(diagStr'="")&(descNote'="") diagStr=diagStr_"；"
		set diagStr=diagStr_descNote	
	}	
	set:(diagStr="") diagStr=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDDesc",diagnosis,",","Y")
	set:(diagStr="") diagStr=diagnosis
	quit diagStr
}

ClassMethod GetOperRequirement(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operReq=operSchedule.OperRequirement,splitChar=","
	set:(operSchedule.IsoOperation="Y") operReq="隔离手术"
	if (operSchedule.ECC="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"体外循环手术"	
	}
	if (operSchedule.TransAutoblood="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"自体血回输"	
	}
	if (operSchedule.PrepareBlood="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"术前备血"	
	}
	if (operSchedule.InfectionOper="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"感染手术"	
	}
	if (operSchedule.MIS="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"微创手术"	
	}
	if (operSchedule.Antibiosis="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"使用抗生素"	
	}
	quit operReq
}

/// Creator：      	yongyang
/// CreatDate：    	2020年2月6日
/// Description： 	根据手术申请ID获取麻醉方法名称（带有导管信息）
/// Table：        	CIS_AN.OperSchedule,CIS_AN.AnaestCatheter
/// Input:			opsId:手术申请ID
/// Return：        麻醉方法名称（带有导管信息）
/// w ##class(CIS.AN.BL.OperScheduleList).GetAnaestMethod("6")
ClassMethod GetAnaestMethod(opsId As %String) As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.DataQueries:FindAnaestCatheter")
	set sc=rs.Execute(opsId)
	//set dataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaestCatheter",opsId)
	set result="",catheterInfo=""
	while(rs.%Next())
	{
		//set dataObj=dataList.GetAt(i)
		set AnaMethodDesc=rs.Get("AnaMethodDesc")
		set CatheterDesc=rs.Get("CatheterDesc")
		set CatheterTypeDesc=rs.Get("CatheterTypeDesc")
		set CatheterDepthDesc=rs.Get("CatheterDepthDesc")
		set CatheterPathDesc=rs.Get("CatheterPathDesc")
		set CatheterToolDesc=rs.Get("CatheterToolDesc")
		set CatheterDirectionDesc=rs.Get("CatheterDirectionDesc")
		set PunctureSpaceDesc=rs.Get("PunctureSpaceDesc")
		set PositionMethodDesc=rs.Get("PositionMethodDesc")
		
		set catheterInfo=""
		set:CatheterDesc'="" catheterInfo=catheterInfo_$lb(CatheterDesc)
		set:CatheterTypeDesc'="" catheterInfo=catheterInfo_$lb(CatheterTypeDesc)
		set:CatheterDepthDesc'="" catheterInfo=catheterInfo_$lb(CatheterDepthDesc)
		set:CatheterPathDesc'="" catheterInfo=catheterInfo_$lb(CatheterPathDesc)
		set:CatheterToolDesc'="" catheterInfo=catheterInfo_$lb(CatheterToolDesc)
		set:CatheterDirectionDesc'="" catheterInfo=catheterInfo_$lb(CatheterDirectionDesc)
		set:PunctureSpaceDesc'="" catheterInfo=catheterInfo_$lb(PunctureSpaceDesc)
		set:PositionMethodDesc'="" catheterInfo=catheterInfo_$lb(PositionMethodDesc)
		
		if catheterInfo="" set result=result_$lb(AnaMethodDesc)
		else  set result=result_$lb(AnaMethodDesc_"("_$ListToString(catheterInfo,",")_")")
	}
	
	quit $ListToString(result,"+")
}

/// w ##class(CIS.AN.BL.OperScheduleList).GetOperPosDesc(2)
ClassMethod GetOperPosDesc(operPosStr As %String) As %String
{
	set operPosDesc=""
	set count=$l(operPosStr,",")
	for i=1:1:count
	{
		set operPosID=$p(operPosStr,",",i)
		continue:(##class(User.ORCOperPosition).%ExistsId(operPosID)=0)
		set operPosObj=##class(User.ORCOperPosition).%OpenId(operPosID)
		set:(operPosDesc'="")&(operPosObj.OPPOSDesc'="") operPosDesc=operPosDesc_","
		set operPosDesc=operPosDesc_operPosObj.OPPOSDesc
	}	
	quit operPosDesc
}

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据登记号获取手术申请ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			regNo - 登记号
/// Return：       	手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.DayCalendar).GetOpsIdListByRegNo("0000000124")
ClassMethod GetOpsIdListByRegNo(regNo As %String) As %String
{
	set EpisodeList=##class(CIS.AN.BL.Admission).GetEpisodeListByRegNo(regNo)
	set result=..GetOpsIdListByAdm(EpisodeList)
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据病案号获取手术申请ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			medcareNo - 病案号
/// Return：       	手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByMedcareNo("24")
ClassMethod GetOpsIdListByMedcareNo(medcareNo As %String) As %String
{
	set EpisodeList=##class(CIS.AN.BL.Admission).GetEpisodeListByMedcareNo(medcareNo)
	set result=..GetOpsIdListByAdm(EpisodeList)
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据就诊ID获取手术申请ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			EpisodeList - 就诊ID字符串，多个就诊ID以","拼接
/// 				allStatusFlag - 全部手术状态标志，默认为N
/// Return：       	手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm("24")
ClassMethod GetOpsIdListByAdm(EpisodeList As %String, allStatusFlag As %String = "N") As %String
{
	// 设定手术状态代码过滤条件
	// 正常情况查询状态有：申请、审核、接收、安排、入手术室(准备中)、入手术间(术中)、离手术间(术毕)、入恢复室(苏醒中)、离恢复室、离手术室、完成。
	// 如果allStatusFlag为Y，表示查询所有状态的手术申请ID
	set operStatusStr=",Application,Audit,Accept,Receive,Arrange,AreaIn,RoomIn,RoomOut,PACUIn,PACUOut,AreaOut,Finish,"
	&sql(DECLARE OPCursor CURSOR FOR select %ID into :RowId
	 from CIS_AN.OperSchedule 
	 where (','_:EpisodeList_',') [ (STRING(',',EpisodeID,','))
	 and (:operStatusStr [ (STRING(',',Status->Code,',')) or :allStatusFlag='Y')
	 and DaySurgery='Y')
	&sql(OPEN OPCursor)
	set result=""
	For
	{
		&sql(FETCH OPCursor)
		quit:(SQLCODE'=0)
		set:(result'="") result=result_","
		set result=result_RowId	
	}
	&sql(CLOSE OPCursor)
	quit result
}

}
