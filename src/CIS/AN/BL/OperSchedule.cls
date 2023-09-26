Class CIS.AN.BL.OperSchedule Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2020-11-09
/// Description： 	根据手术号获取手术信息
/// Table：        	CIS_AN.OperSchedule
/// Input:			opsId:手术号
/// Return：       	手术信息动态对象
/// w ##class(CIS.AN.BL.OperSchedule).GetOperSchedule("6561")
ClassMethod GetOperSchedule(opsId As %String) As %DynamicObject
{
	//b ;000
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ops=##class(%DynamicObject).%New()
	set ops.RowId=opsId
	set ops.OPSID=opsId
	// 获取患者信息
	set ops.EpisodeID=operSchedule.EpisodeID
	set ops.PatName=operSchedule.PatName
	set ops.PatGender=operSchedule.PatGender
	set ops.PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,+$h)
	set ops.PatPhoneNumber=operSchedule.PatPhoneNumber
	set ops.RegNo=operSchedule.RegNo
	set ops.MedcareNo=operSchedule.MedicareNo
	set ops.PatCardID=operSchedule.CardID
	//set ops.PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
	
	
	set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",operSchedule.EpisodeID)
	set:(ops.PatPhoneNumber="") ops.PatPhoneNumber=	patInfoObj.GetValue("MobPhone")
	if (ops.PatName="")
	{
		
		set ops.PatName=patInfoObj.GetValue("PatName")
		set ops.PatGender=patInfoObj.GetValue("PatGender")
		set ops.PatAge=patInfoObj.GetValue("PatAge")
		set ops.RegNo=patInfoObj.GetValue("RegNo")
		set ops.MedcareNo=patInfoObj.GetValue("MedcareNo")
		set ops.PatCardID=patInfoObj.GetValue("CardID")
		
		
	}
	set ops.PatBedCode=patInfoObj.GetValue("PatBedCode")
    //set ops.PatBedCode=##class(Nur.NIS.Service.Base.Patient).GetBedCode(operSchedule.EpisodeID)
    set ops.AdmDate=patInfoObj.GetValue("AdmDate")
	set ops.AdmDocDesc=patInfoObj.GetValue("CreateUserDesc")
	if (ops.AdmDocDesc="")
	{
		set ops.AdmDoc=operSchedule.AppCareProvID
		set ops.AdmDocDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",ops.AdmDoc)	
	}
	
    set ops.PatientID=patInfoObj.GetValue("PatientID")
	// 手术申请信息
	set ops.AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
	set ops.PatDeptID=operSchedule.PatDeptID
	set ops.PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
	set ops.PatWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",operSchedule.PatWardID)
	
	set ops.AppDeptID=operSchedule.AppDeptID
	set ops.AppDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
	set ops.OperDeptID=operSchedule.OperDeptID				// 手术室
	set ops.OperDeptCode=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCCode",operSchedule.OperDeptID)
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
	set ops.PACUBed=operSchedule.PACUBed.Description    //恢复室
	
	set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")			// 手术日期(计划)
	//set DateFormat=$lg(^websys.ConfigurationD(1),10)
	//if ((DateFormat="DMY")&&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
	set ops.OperDate=OperDate
	set ops.OperYear=+$p(OperDate,"-",1),ops.OperMonth=+$p(OperDate,"-",2),ops.OperDay=+$p(OperDate,"-",3)
	set ops.OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")			// 手术开始时间(计划)
	set ops.OperHour=+$p(ops.OperTime,":",1),ops.OperMin=+$p(ops.OperTime,":",2)
	set ops.DaySurgery=operSchedule.DaySurgery  // 202002+dyl+日间手术
	set ops.OPAdmType=operSchedule.OPAdmType	//202003+dyl+门诊手术 OOP-门诊手术，IOP-住院手术，DOP-科内手术
	set ops.PlanSeq=operSchedule.PlanSeq					// 计划台次
	set ops.SeqType=operSchedule.SeqType					// 台次类型(正常台，连台)
	set ops.SeqTypeDesc=##class(CIS.AN.OperSchedule).SeqTypeLogicalToDisplay(operSchedule.SeqType)
	set ops.PrevDiagnosis=$tr(operSchedule.PrevDiagnosis,$c(4),"")		// 术前诊断
	set ops.PrevDiagnosisDesc=..GetDiagnosisDesc(ops.PrevDiagnosis)		// 术前诊断描述
	set ops.PostDiagnosis=operSchedule.PostDiagnosis		// 术后诊断
	set ops.PostDiagnosisDesc=..GetDiagnosisDesc(ops.PostDiagnosis)
	
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
	set ops.OperDescNote=operListObj.OperDescNote
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
	set ops.OperSeqLetter=""
	set:(+ops.OperSeq>0) ops.OperSeqLetter=$c(64+(+ops.OperSeq))
	set ops.PlanSeq=operSchedule.PlanSeq
	set ops.AppDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime,"")
	set ops.AuditDT=""
	set procedureId=##class(CIS.AN.BL.SurgicalProcedure).GetProcedureIdByCode(opsId,"ADT")
	if (##class(CIS.AN.SurgicalProcedure).%ExistsId(procedureId))
	{
		set procedure=##class(CIS.AN.SurgicalProcedure).%OpenId(procedureId)
		set ops.AuditDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(procedure.ActionDate,procedure.ActionTime,"")	
	}
	
	set ops.ScrubNurse=operSchedule.ScrubNurse						// 器械护士，多个护士以","拼接
	set ops.ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ScrubNurse)		// 器械护士姓名
	set ops.CircualNurse=operSchedule.CircualNurse					// 巡回护士，多个护士以","拼接
	set ops.CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.CircualNurse)	// 巡回护士姓名
	
	// 麻醉信息
	set ops.AnaestID=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))	// 麻醉申请ID
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(ops.AnaestID)
	set ops.AnaMethod="",ops.AnaMethodDesc="",ops.AnaExpert="",ops.AnaExpertDesc=""
	set ops.Anesthesiologist="",ops.AnesthesiologistDesc="",ops.AnaAssistant="",ops.AnaAssistantDesc="",ops.AnaStaff=""
	set ops.OperStartDT="",ops.OperFinishDT=""
	set ops.OperFinishDate="",ops.OperFinishTime=""
	set ops.OperStartDate="",ops.OperStartTime="",ops.ASAClass="",ops.ASAClassDesc=""
	set ops.TheatreInDate="",ops.TheatreInTime="",ops.TheatreInDT=""
	set ops.TheatreOutDate="",ops.TheatreOutTime="",ops.TheatreOutDT=""
	if (anaesthesia'="")
	{
		
		set ops.AnaMethod=anaesthesia.AnaMethod	// 麻醉方法ID
		set ops.AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",ops.AnaMethod)	// 麻醉方法名称
		set ops.AnaExpert=anaesthesia.AnaExpert	// 麻醉指导
		set ops.AnaExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.AnaExpert)	// 麻醉指导姓名
		set ops.Anesthesiologist=anaesthesia.Anesthesiologist	// 麻醉医生
		set ops.AnesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.Anesthesiologist)	// 麻醉医生姓名
		set ops.AnaAssistant=anaesthesia.AnaAssistant	//anaestObj.GetValue("AnaAssistant")			// 麻醉助手
		set ops.AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ops.AnaAssistant)		// 麻醉助手姓名
		set ops.AnaStaff=anaesthesia.AnaStaff	// 实习进修
		set ops.AnaestMethod=..GetAnaestMethod(opsId)
		set ops.OperStartDT=anaesthesia.OperStartDT
		b //ccq
		if (ops.OperStartDT'="")
		{
			set ops.OperStartDate=$p(ops.OperStartDT," ",1)
			set ops.OperStartTime=$zt($zth($p(ops.OperStartDT," ",2)),2)	
		}
		set ops.OperFinishDT=anaesthesia.OperFinishDT
		//b:(opsId=6418) //ccq2
		if (ops.OperFinishDT'="")
		{
			set ops.OperFinishDate=$p(ops.OperFinishDT," ",1)
			set ops.OperFinishTime=$zt($zth($p(ops.OperFinishDT," ",2)),2)	
		}
		
		set ops.TheatreInDT=anaesthesia.TheatreInDT
		//b:(opsId=6418) //ccq2
		if (ops.TheatreInDT'="")
		{
			set ops.TheatreInDate=$p(ops.TheatreInDT," ",1)
			set ops.TheatreInTime=$zt($zth($p(ops.TheatreInDT," ",2)),2)	
		}
		
		set ops.TheatreOutDT=anaesthesia.TheatreOutDT
		//b:(opsId=6418) //ccq2
		if (ops.TheatreOutDT'="")
		{
			set ops.TheatreOutDate=$p(ops.TheatreOutDT," ",1)
			set ops.TheatreOutTime=$zt($zth($p(ops.TheatreOutDT," ",2)),2)	
		}
		//b:(opsId=6418) //ccq3
		set ops.ASAClass=anaesthesia.ASAClass
		set ops.ASAClassDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCASAClassPhActiv","ORASADesc",anaesthesia.ASAClass)
	}
	set ops.AnaesthesiaID=operSchedule.ExtAnaestID
	
	set ops.AppDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)	// 手术申请日期时间
	
	set ops.OPAID=operSchedule.ExternalID
	set ops.Infection=$$GetInfection()		// 感染四项阳性情况
	//b ;001
	set ops.Requirement=$$GetRequirement()	// 手术要求
	set ops.ArrPrintFlag=operSchedule.ArrPrintFlag
	
	
	set ops.SurgicalKit=operSchedule.SurgicalKit
	set ops.SurgicalKitDesc=##class(CIS.AN.COM.String).GetDescByIDStr("CT.AN.SurgicalKit","Description",operSchedule.SurgicalKit)
	set ops.UnPlanSecOper=operSchedule.UnPlanSecOper
	set ops.ReentryOperation=operSchedule.ReentryOperation
	set:(ops.UnPlanSecOper="") ops.UnPlanSecOper=operSchedule.ReentryOperation
	set:(ops.UnPlanSecOper="Y") ops.UnPlanSecOper="是"
	set:(ops.UnPlanSecOper="N") ops.UnPlanSecOper="否"
	set opsIdStr=..GetOpsIdListByAdm(operSchedule.EpisodeID)
	set ops.OperTimes=$l(opsIdStr,",")
	set ops.OperIndex=1
	for i=1:1:ops.OperTimes
	{
		set curOpsId=$p(opsIdStr,",",i)
		set:(curOpsId=opsId) ops.OperIndex=i	
	}
	
	set ops.SurPhoneNumber="" //##class(CIS.AN.BL.Admission).GetUserPhoneNumber(operListObj.Surgeon)
	set ops.PatABO=##class(CIS.AN.OperSchedule).BloodTypeLogicalToDisplay(operSchedule.BloodType)
	set ops.PatRHD=##class(CIS.AN.OperSchedule).RHBloodTypeLogicalToDisplay(operSchedule.RHBloodType)
	set ops.HbsAgDesc=##class(CIS.AN.OperSchedule).HbsAgLogicalToDisplay(operSchedule.HbsAg)
	set ops.HcvAbDesc=##class(CIS.AN.OperSchedule).HcvAbLogicalToDisplay(operSchedule.HcvAb)
	set ops.HivAbDesc=##class(CIS.AN.OperSchedule).HivAbLogicalToDisplay(operSchedule.HivAb)
	set ops.SyphilisDesc=##class(CIS.AN.OperSchedule).SyphilisLogicalToDisplay(operSchedule.Syphilis)
	set ops.DaySurgeryNote=operSchedule.DaySurgeryNote
	
	//set ops.Deposit=##class(web.DHCDocOrderCommon).GetCurrentDeposit(operSchedule.EpisodeID)
	set operSchedule="",anaesthesia="",operListObj="",patInfoObj=""
	//b:(opsId=6418) //ccq4
	quit ops
GetInfection()
	set infectionA="",infectionB=""
	set:(operSchedule.HivAb="+") infectionA=infectionA_$lb("艾滋阳性")
	set:(operSchedule.HivAb="-") infectionB="阴性"
	
	set:(operSchedule.HcvAb="+") infectionA=infectionA_$lb("丙肝阳性")
	set:(operSchedule.HcvAb="-") infectionB="阴性"
	
	set:(operSchedule.HbsAg="+") infectionA=infectionA_$lb("乙肝阳性")
	set:(operSchedule.HbsAg="-") infectionB="阴性"
	
	set:(operSchedule.Syphilis="+") infectionA=infectionA_$lb("梅毒阳性")
	set:(operSchedule.Syphilis="-") infectionB="阴性"
	//b  ;00022
	quit:(infectionA="") infectionB
	//b ;0021
	set res=$lts(infectionA,";")
	quit res
	//b ;002
GetRequirement()
	set requirement=""
	quit ""
	set:(ops.BodySiteDesc'="") requirement=requirement_$lb(ops.BodySiteDesc)
	set curSurgicalMaterials=$ZSTRIP(operSchedule.SurgicalMaterials,"<>W")
	set:(curSurgicalMaterials'="") requirement=requirement_$lb(curSurgicalMaterials)
	
	set curSpecialConditions=$ZSTRIP(operSchedule.SpecialConditions,"<>W")
	set:(curSpecialConditions'="") requirement=requirement_$lb(curSpecialConditions)
	
	set curHighConsume=$ZSTRIP(operSchedule.HighConsume,"<>W")
	set consumables=##class(CIS.AN.BL.OperConsumables).GetHighConsumable(opsId)
	set consumables=$ZSTRIP(consumables,"<>W")
	set:(curHighConsume'="") requirement=requirement_$lb(curHighConsume)
	set:(consumables'="") requirement=requirement_$lb(consumables)
	set requirement=$lts(requirement,";")
	quit requirement
}

/// Creator：      	陈长青
/// CreatDate：    	2020-11-09
/// Description： 	根据手术号获取手术信息
/// Table：        	CIS_AN.OperSchedule
/// Input:			opsId:手术号
/// Return：       	手术信息JSON字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleJSON("4620")
ClassMethod GetOperScheduleJSON(opsId As %String) As %String
{
	set opsObj=..GetOperSchedule(opsId)
	set ret=opsObj.%ToJSON()
	quit ret
}

/// Creator：      	陈长青
/// CreatDate：    	2020-11-09
/// Description： 	获取手术列表
/// Table：        	CIS_AN.OperSchedule
/// Input:			param:查询参数动态对象 
/// Return：       	手术信息JSON字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-09","endDate":"2020-11-09","userDeptID":"236","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","surgeon":"1259","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-10-29","endDate":"2020-10-29","userDeptID":"74","surgeon":"2403","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"patName":"姚锡勇"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-21","endDate":"2020-11-21","userDeptID":"213","statusCode":"Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^"})
ClassMethod GetOperScheduleList(param As %DynamicObject) As %String
{
	set $zt="Error"
	// 判断是否分页
	set pagination=0,startIndex=0,endIndex=0
	set:(param.page>0)&(param.rows>0) pagination=1,startIndex=(param.page-1)*param.rows+1,endIndex=param.page*param.rows
	// 登记号查询
	if (param.regNo'="")
	{
		set opsIdStr=..GetOpsIdListByRegNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	// 病案号查询
	if (param.medcareNo'="")
	{
		set opsIdStr=..GetOpsIdListByMedcareNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""		
	}
	// 患者姓名
	if (param.patName'="")
	{
		set regNoStr=##class(CIS.AN.BL.Admission).GetRegNoByName(param.patName)
		set regNoCount=$l(regNoStr,",")
		set opsIdListStr=""
		for i=1:1:regNoCount
		{
			set regNo=$p(regNoStr,",",i)
			continue:(regNo="")
			set opsIdStr=..GetOpsIdListByRegNo(regNo)
			set:(opsIdStr'="") opsIdListStr=opsIdListStr_$lb(opsIdStr)
		}
		set opsIdStr=$lts(opsIdListStr,",")
		b //ccq
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.startDate,"")
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.endDate,"")
	set deptConfig=..GetDeptConfig(param.userDeptID)
	set INStatusCode="^"_$System.SQL.UPPER(param.statusCode)_"^"
	set EMStatusCode=INStatusCode_"APPLICATION^"
	set appDeptType="^IN^OUT^EM^"
	
	k ^TMPOPS($j)
	for date=startDateH:1:endDateH
	{
		set curOpsId=0
		for
		{
			set curOpsId=$o(^CIS.AN.OperScheduleI("OPDate",date,curOpsId))
			quit:(curOpsId="")
			set curOps=##class(CIS.AN.OperSchedule).%OpenId(curOpsId)
			set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(curOpsId)
			set curAppDeptID=","_curOps.AppDeptID_","
			set:(operListObj.SurgeonDept'="") curAppDeptID=curAppDeptID_operListObj.SurgeonDept_","
			//b:(curOps.DaySurgery="Y") //1
			if (param.surgeon="")
			{
				continue:(deptConfig.DeptType="OP")&(curOps.OperDeptID'=param.userDeptID)									// 登录科室类型为手术室，只查该手术室手术
				//continue:(deptConfig.DeptType="AN")&(curOps.AnaDept'=param.userDeptID)									// 登录科室类型为麻醉科，只查该麻醉科手术
				continue:(param.appDeptID="")&(appDeptType [ ("^"_deptConfig.DeptType_"^"))&(curAppDeptID '[ (","_param.userDeptID_","))				// 登录科室类型住院、门诊和急诊手术申请科室，只查本科室手术
				continue:(param.appDeptID'="")&(curAppDeptID '[ (","_param.appDeptID_","))
				continue:(deptConfig.DeptType="DD")&(curOps.DaySurgery'="Y")
				// 门诊手术筛选
				continue:(deptConfig.DeptType="OUT")&(curOps.OPAdmType'="OOP")		
			}
			continue:(param.daySurgery="Y")&(curOps.DaySurgery'="Y")
											// 科室类型为日间手术中心，只查日间手术
			//b:(curOps.DaySurgery="Y") //2
			//b //ccq
													// 科室类型为门诊申请科室，只查门诊手术
			// 手术状态筛选
			set curStatusCode="^"_$System.SQL.ALPHAUP(curOps.Status.Code)_"^"
			set filterStatusCode=INStatusCode
			set:(curOps.SourceType="E") filterStatusCode=EMStatusCode						// 急诊手术可以查询申请状态
			b:(curOpsId=6111) //ccq3
			continue:(param.statusCode'="")&(filterStatusCode '[ curStatusCode)
			continue:(param.statusID>0)&(curOps.Status.%Id()'=param.statusID)
			//b //ccq2
			// 手术间筛选
			set curOperRoomID=""
			set:($isobject(curOps.OperRoom)) curOperRoomID=curOps.OperRoom.%Id()
			continue:(param.roomId'="")&(param.roomId'=curOperRoomID)
			// 登记号和病案号筛选
			set curRegNo=##class(CIS.AN.BL.Admission).GetRegNobyEpisodeID(curOps.EpisodeID)
			continue:(param.regNo'="")&(param.regNo'=curRegNo)
			set curMedCareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",curOps.EpisodeID)
			continue:(param.medcareNo'="")&(param.medcareNo'=curMedCareNo)
			// 手术医生筛选
			if (param.surgeon>0)
			{
				
				b:(curOps.DaySurgery="Y")
				continue:((","_operListObj.Surgeon_",") '[ (","_param.surgeon_","))	
			}
			set ret=$$storeTempData()
		}
	}

	set ret=$$writeTempData()
	quit ""

storeTempData()
	set roomNode="A99"
	
	set:($isobject(curOps.OperRoom)) roomNode="A"_roomNode_curOps.OperRoom.Code
	set:('$isobject(curOps.OperRoom)) roomNode="Z"_curOps.AppDeptID
	set seqNo=0
	set:($isobject(curOps.OperRoom)) seqNo=+curOps.OperSeq
	set:('$isobject(curOps.OperRoom)) seqNo=+curOps.PlanSeq
	set ^TMPOPS($j,curOps.OperDate,roomNode,seqNo,curOpsId)=""
	b:(curOps.Status.Code="DaySurgery")
	quit ""

writeTempData()
	set operDate=0,rowCount=0,pageCount=0
	w "{""rows"":["
	for
	{
		set operDate=$o(^TMPOPS($j,operDate))
		quit:(operDate="")
		set roomNode=""
		for
		{
			set roomNode=$o(^TMPOPS($j,operDate,roomNode))
			quit:(roomNode="")
			set seqNode=""
			for
			{
				set seqNode=$o(^TMPOPS($j,operDate,roomNode,seqNode))
				quit:(seqNode="")
				set opsId=0
				for
				{
					set opsId=$o(^TMPOPS($j,operDate,roomNode,seqNode,opsId))
					quit:(opsId="")
					set rowCount=rowCount+1
					continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
					set pageCount=pageCount+1
					w:(pageCount>1) ","
					set jsonStr=..GetOperScheduleJSON(opsId)
					w jsonStr	
				}	
			}	
		}	
	}
	w "],""total"":"_rowCount_"}"
	quit ""
	
writeOpsListData(opsIdList)
	set opsIdCount=$l(opsIdList,","),rowCount=0,pageCount=0
	w "{""rows"":["
	for i=1:1:opsIdCount
	{
		set opsId=$p(opsIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		//set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		//continue:(param.daySurgery="Y")&(operSchedule.DaySurgery'="Y")
		set rowCount=rowCount+1
		continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
		set pageCount=pageCount+1
		w:(pageCount>1) ","
		set jsonStr=..GetOperScheduleJSON(opsId)
		w jsonStr	
	}
	w "],""total"":"_rowCount_"}"
	
	
Error
	quit "E^"_$ze_$g(opsId)
}

/// Creator：      	陈长青
/// CreatDate：    	2020-11-09
/// Description： 	获取手术列表
/// Table：        	CIS_AN.OperSchedule
/// Input:			param:查询参数动态对象 
/// Return：       	手术信息JSON字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-09","endDate":"2020-11-09","userDeptID":"236","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","surgeon":"1259","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-10-29","endDate":"2020-10-29","userDeptID":"74","surgeon":"2403","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"patName":"姚锡勇"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleListNew({"startDate":"2020-11-23","endDate":"2020-11-23","userDeptID":"213","statusCode":"Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleListNew({"startDate":"2020-11-11","endDate":"2020-11-11","userDeptID":"55","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^","surgeon":"809"})
ClassMethod GetOperScheduleListNew(param As %DynamicObject) As %String
{
	set $zt="Error"
	// 判断是否分页
	set pagination=0,startIndex=0,endIndex=0
	set:(param.page>0)&(param.rows>0) pagination=1,startIndex=(param.page-1)*param.rows+1,endIndex=param.page*param.rows
	// 登记号查询
	if (param.regNo'="")
	{
		set opsIdStr=..GetOpsIdListByRegNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	// 病案号查询
	if (param.medcareNo'="")
	{
		set opsIdStr=..GetOpsIdListByMedcareNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""		
	}
	// 患者姓名
	if (param.patName'="")
	{
		set regNoStr=##class(CIS.AN.BL.Admission).GetRegNoByName(param.patName)
		set regNoCount=$l(regNoStr,",")
		set opsIdListStr=""
		for i=1:1:regNoCount
		{
			set regNo=$p(regNoStr,",",i)
			continue:(regNo="")
			set opsIdStr=..GetOpsIdListByRegNo(regNo)
			set:(opsIdStr'="") opsIdListStr=opsIdListStr_$lb(opsIdStr)
		}
		set opsIdStr=$lts(opsIdListStr,",")
		b //ccq
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.startDate,"")
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.endDate,"")
	set deptConfig=..GetDeptConfig(param.userDeptID)
	set INStatusCode="^"_$System.SQL.UPPER(param.statusCode)_"^"
	set EMStatusCode=INStatusCode_"APPLICATION^"
	set appDeptType="^IN^OUT^EM^"
	
	k ^TMPOPS($j)
	&sql(declare OPSListCursor cursor for select %ID
		into :RowId from CIS_AN.OperSchedule 
		where OperDate>=:startDateH 
		and OperDate<=:endDateH)
	&sql(open OPSListCursor)
	for
	{
		&sql(fetch OPSListCursor)
		quit:(SQLCODE'=0)
		set opsInfo=^CIS.AN.OperScheduleD(RowId)
		set appDeptID=$li(opsInfo,3),operDeptID=$li(opsInfo,4),anaDeptID=$li(opsInfo,65)
		set daySurgery=$li(opsInfo,61),sourceType=$li(opsInfo,18),OPAdmType=$li(opsInfo,74)
		set EpisodeID=$li(opsInfo,1),operDate=$li(opsInfo,14),operSeq=$li(opsInfo,56)
		set planSeq=$li(opsInfo,41),roomId=$li(opsInfo,55),roomCode=$lg($g(^CF.AN.LocationD(+roomId)),1)
		set statusID=$li(opsInfo,9),statusCode=$lg($g(^CT.AN.OperStatusD(+statusID)),1)
		//set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(RowId)
		set surgeonDept=$$GetSurgeonDept()
		set patInfo=..GetPatInfo(EpisodeID)
		set curAppDeptID=","_appDeptID_","_patInfo.PatDeptID_","
		set:(surgeonDept'="") curAppDeptID=curAppDeptID_surgeonDept_","
		// 手术状态筛选
		set curStatusCode="^"_$System.SQL.ALPHAUP(statusCode)_"^"
		set filterStatusCode=INStatusCode
		set:(sourceType="E") filterStatusCode=EMStatusCode						// 急诊手术可以查询申请状态
		continue:(param.statusCode'="")&(filterStatusCode '[ curStatusCode)
		continue:(param.statusID>0)&(statusID'=param.statusID)
		//b //ccq2
		if (param.surgeon="")
		{
			continue:(deptConfig.DeptType="OP")&(operDeptID'=param.userDeptID)									// 登录科室类型为手术室，只查该手术室手术
			//continue:(deptConfig.DeptType="AN")&(curOps.AnaDept'=param.userDeptID)									// 登录科室类型为麻醉科，只查该麻醉科手术
			continue:(param.appDeptID="")&(appDeptType [ ("^"_deptConfig.DeptType_"^"))&(curAppDeptID '[ (","_param.userDeptID_","))				// 登录科室类型住院、门诊和急诊手术申请科室，只查本科室手术
			continue:(param.appDeptID'="")&(curAppDeptID '[ (","_param.appDeptID_","))
			continue:(deptConfig.DeptType="DD")&(daySurgery'="Y")
			// 门诊手术筛选
			continue:(deptConfig.DeptType="OUT")&(OPAdmType'="OOP")
		}
		
		continue:(param.daySurgery="Y")&(daySurgery'="Y")
		
		// 手术间筛选
		set curOperRoomID=""
		set:(roomId>0) curOperRoomID=roomId
		continue:(param.roomId'="")&(param.roomId'=curOperRoomID)
		// 手术医生筛选
		if (param.surgeon>0)
		{
			set surgeon=$$GetSurgeon()
			continue:((","_surgeon_",") '[ (","_param.surgeon_","))	
		}
		set ret=$$storeTempData()
	}
	&sql(close OPSListCursor)

	set ret=$$writeTempData()
	quit ""

storeTempData()
	set roomNode="A99"
	
	set:(roomId>0) roomNode="A"_roomCode
	set:('(roomId>0)) roomNode="Z"_appDeptID
	set seqNo=0
	set:(roomId>0) seqNo=+operSeq
	set:('(roomId>0)) seqNo=+planSeq
	set ^TMPOPS($j,operDate,roomNode,seqNo,RowId)=""
	quit ""

writeTempData()
	set operDate=0,rowCount=0,pageCount=0
	w "{""rows"":["
	for
	{
		set operDate=$o(^TMPOPS($j,operDate))
		quit:(operDate="")
		set roomNode=""
		for
		{
			set roomNode=$o(^TMPOPS($j,operDate,roomNode))
			quit:(roomNode="")
			set seqNode=""
			for
			{
				set seqNode=$o(^TMPOPS($j,operDate,roomNode,seqNode))
				quit:(seqNode="")
				set opsId=0
				for
				{
					set opsId=$o(^TMPOPS($j,operDate,roomNode,seqNode,opsId))
					quit:(opsId="")
					set rowCount=rowCount+1
					continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
					set pageCount=pageCount+1
					w:(pageCount>1) ","
					set jsonStr=..GetOperScheduleJSON(opsId)
					w jsonStr	
				}	
			}	
		}	
	}
	w "],""total"":"_rowCount_"}"
	quit ""
	
writeOpsListData(opsIdList)
	set opsIdCount=$l(opsIdList,","),rowCount=0,pageCount=0
	w "{""rows"":["
	for i=1:1:opsIdCount
	{
		set opsId=$p(opsIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		//set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		//continue:(param.daySurgery="Y")&(operSchedule.DaySurgery'="Y")
		set rowCount=rowCount+1
		continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
		set pageCount=pageCount+1
		w:(pageCount>1) ","
		set jsonStr=..GetOperScheduleJSON(opsId)
		w jsonStr	
	}
	w "],""total"":"_rowCount_"}"
	
	
Error
	quit "E^"_$ze_$g(opsId)

GetSurgeonDept()
	set operDescId=0,curSurgeonDeptID=""
	for
	{
		set operDescId=$o(^CIS.AN.OperListI("IOPS",RowId,operDescId))
		quit:(operDescId="")
		set curSurgeonDeptID=curSurgeonDeptID_$lb($li(^CIS.AN.OperListD(operDescId),9))	
	}
	quit $lts(curSurgeonDeptID,",")
GetSurgeon()
	set operDescId=0,curSurgeonID=""
	for
	{
		set operDescId=$o(^CIS.AN.OperListI("IOPS",RowId,operDescId))
		quit:(operDescId="")
		set curSurgeonID=curSurgeonID_$lb($li(^CIS.AN.OperListD(operDescId),7))	
	}
	quit $lts(curSurgeonID,",")
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
	//set:(diagStr="") diagStr=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDDesc",diagnosis,",","Y")
	set:(diagStr="") diagStr=diagnosis
	quit diagStr
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

/// Creator：      	yongyang
/// CreatDate：    	2020年2月6日
/// Description： 	根据手术申请ID获取麻醉方法名称（带有导管信息）
/// Table：        	CIS_AN.OperSchedule,CIS_AN.AnaestCatheter
/// Input:			opsId:手术申请ID
/// Return：        麻醉方法名称（带有导管信息）
/// w ##class(CIS.AN.BL.OperScheduleList).GetAnaestMethod("6")
ClassMethod GetAnaestMethod(opsId As %String) As %String
{
	set dataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperSchedule:FindAnaestCatheter",opsId)
	set result="",catheterInfo=""
	b ;23
	for i=1:1:dataList.Size
	{
		set dataObj=dataList.GetAt(i)
		set AnaMethodDesc=dataObj.GetValue("AnaMethodDesc")
		set CatheterDesc=dataObj.GetValue("CatheterDesc")
		set CatheterTypeDesc=dataObj.GetValue("CatheterTypeDesc")
		set CatheterDepthDesc=dataObj.GetValue("CatheterDepthDesc")
		set CatheterPathDesc=dataObj.GetValue("CatheterPathDesc")
		set CatheterToolDesc=dataObj.GetValue("CatheterToolDesc")
		set CatheterDirectionDesc=dataObj.GetValue("CatheterDirectionDesc")
		set PunctureSpaceDesc=dataObj.GetValue("PunctureSpaceDesc")
		set PositionMethodDesc=dataObj.GetValue("PositionMethodDesc")
		
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

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据登记号获取手术申请ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			regNo - 登记号
/// Return：       	手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo("0003878714")
ClassMethod GetOpsIdListByRegNo(regNo As %String) As %String
{
	set PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",regNo,0)),EpisodeIDStr="",EpisodeID=0,admType=""
	for
	{
		set admType=$o(^PAPERdr(PAPMIRowId,"ADM",admType))
		quit:(admType="")
		for
		{
			set EpisodeID=$o(^PAPERdr(PAPMIRowId,"ADM",admType,EpisodeID))
			quit:(EpisodeID="")
			set EpisodeIDStr=EpisodeIDStr_$lb(EpisodeID)	
		}	
	}
	set EpisodeList=$lts(EpisodeIDStr,",")
	
	//set EpisodeList=##class(CIS.AN.BL.Admission).GetEpisodeListByRegNo(regNo)
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
	set operStatusStr=",DaySurgery,Application,Audit,Receive,Receive,Arrange,AreaIn,RoomIn,RoomOut,PACUIn,PACUOut,AreaOut,Finish,"
	&sql(DECLARE OPCursor CURSOR FOR select %ID into :RowId
	 from CIS_AN.OperSchedule where (','_:EpisodeList_',') [ (STRING(',',EpisodeID,','))
	 and (:operStatusStr [ (STRING(',',Status->Code,',')) or :allStatusFlag="Y"))
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

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据就诊ID获取手术申请ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			EpisodeList - 就诊ID字符串，多个就诊ID以","拼接
/// 				allStatusFlag - 全部手术状态标志，默认为N
/// Return：       	手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm("24")
ClassMethod GetOpaIdListByAdm(EpisodeList As %String, allStatusFlag As %String = "N") As %String
{
	// 设定手术状态代码过滤条件
	// 正常情况查询状态有：申请、审核、接收、安排、入手术室(准备中)、入手术间(术中)、离手术间(术毕)、入恢复室(苏醒中)、离恢复室、离手术室、完成。
	// 如果allStatusFlag为Y，表示查询所有状态的手术申请ID
	set operStatusStr=",DaySurgery,Application,Audit,Receive,Arrange,AreaIn,RoomIn,RoomOut,PACUIn,PACUOut,AreaOut,Finish,"
	&sql(DECLARE OPACursor CURSOR FOR select ExternalID into :RowId
	 from CIS_AN.OperSchedule where (','_:EpisodeList_',') [ (STRING(',',EpisodeID,','))
	 and (:operStatusStr [ (STRING(',',Status->Code,',')) or :allStatusFlag="Y"))
	&sql(OPEN OPACursor)
	set result=""
	For
	{
		&sql(FETCH OPACursor)
		quit:(SQLCODE'=0)
		set:(result'="") result=result_","
		set result=result_RowId	
	}
	&sql(CLOSE OPACursor)
	quit result
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

/// 获取患者信息对象
ClassMethod GetPatInfo(EpisodeID As %String) As %DynamicObject
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindPatient")
	set sc=rs.Execute(EpisodeID)
	set colCount=rs.GetColumnCount()
	set rowData=##class(%DynamicObject).%New()
	while (rs.Next())
	{
		for i=1:1:colCount
		{
			set colName=rs.GetColumnName(i)
			set dataValue=rs.Get(colName)
			do rowData.%Set(colName,dataValue)	
		}	
	}
	quit rowData
}

/// 获取患者信息JSON字符串
ClassMethod GetPatInfoJSON(EpisodeID As %String) As %String
{
	set patInfo=..GetPatInfo(EpisodeID)
	quit patInfo.%ToJSON()
}

/// Creator：      	陈长青
/// CreatDate：    	2020-11-09
/// Description： 	获取手术列表
/// Table：        	CIS_AN.OperSchedule
/// Input:			param:查询参数动态对象 
/// Return：       	手术信息JSON字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-09","endDate":"2020-11-09","userDeptID":"236","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","surgeon":"1259","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-10-29","endDate":"2020-10-29","userDeptID":"74","surgeon":"2403","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"patName":"姚锡勇"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-17","endDate":"2020-11-17","userDeptID":"213","statusCode":"Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperDetails({"startDate":"2020-11-01","endDate":"2020-11-18","userDeptID":"213","statusCode":"RoomOut^PACUOut^PACUIn^Finish","page":1,"rows":50})
ClassMethod GetOperDetails(param As %DynamicObject) As %String
{
	set $zt="Error"
	// 判断是否分页
	set pagination=0,startIndex=0,endIndex=0
	set:(param.page>0)&(param.rows>0) pagination=1,startIndex=(param.page-1)*param.rows+1,endIndex=param.page*param.rows
	// 登记号查询
	if (param.regNo'="")
	{
		set opsIdStr=..GetOpsIdListByRegNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	// 病案号查询
	if (param.medcareNo'="")
	{
		set opsIdStr=..GetOpsIdListByMedcareNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""		
	}
	// 患者姓名
	if (param.patName'="")
	{
		set regNoStr=##class(CIS.AN.BL.Admission).GetRegNoByName(param.patName)
		set regNoCount=$l(regNoStr,",")
		set opsIdListStr=""
		for i=1:1:regNoCount
		{
			set regNo=$p(regNoStr,",",i)
			continue:(regNo="")
			set opsIdStr=..GetOpsIdListByRegNo(regNo)
			set:(opsIdStr'="") opsIdListStr=opsIdListStr_$lb(opsIdStr)
		}
		set opsIdStr=$lts(opsIdListStr,",")
		b //ccq
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.startDate,"")
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.endDate,"")
	set rowCount=0,findCount=0
	k ^TMPOPS($j)
	&sql(declare OPSCursor cursor for select %ID
		into :RowId from CIS_AN.OperSchedule where OperDate>=:startDateH and OperDate<=:endDateH and Status->Code in ('RoomOut','PACUOut','Finish'))
	&sql(open OPSCursor)
	for
	{
		&sql(fetch OPSCursor)
		quit:(SQLCODE'=0)
		set opsInfo=^CIS.AN.OperScheduleD(RowId)
		set appDeptID=$li(opsInfo,3),operDeptID=$li(opsInfo,4),anaDeptID=$li(opsInfo,65)
		set daySurgery=$li(opsInfo,61),sourceType=$li(opsInfo,18),OPAdmType=$li(opsInfo,74)
		set EpisodeID=$li(opsInfo,1),operDate=$li(opsInfo,14),operSeq=$li(opsInfo,56)
		set planSeq=$li(opsInfo,41),roomId=$li(opsInfo,55),roomCode=$lg($g(^CF.AN.LocationD(+roomId)),1)
		continue:(param.appDeptID'="")&(param.appDeptID'=appDeptID)
		continue:(param.operDeptID'="")&(param.operDeptID'=operDeptID)
		continue:(param.anaDeptID'="")&(param.anaDeptID'=anaDeptID)
		continue:(param.daySurgery="Y")&(daySurgery'="Y")
		continue:(param.emOper="Y")&(sourceType'="E")
		continue:(param.outOper="Y")&(OPAdmType'="OOP")
		if (param.mulOper="Y")
		{
			//set opsIdStr=..GetOpsIdListByAdm(EpisodeID)
			set operCount=$$GetFinishOperCount()
			continue:(operCount<2)
		}
		if (param.operDesc'="")!(param.operClass'="")!(param.bladeType'="")!(param.bodySite'="")!(param.surgeon'="")
		{
			set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(RowId)
			continue:(param.operDesc'="")&(operListObj.OperDescNote '[ param.operDesc)
			continue:(param.operClass'="")&((","_operListObj.OperClass_",") '[ (","_param.operClass_","))
			continue:(param.bladeType'="")&((","_operListObj.BladeType_",") '[ (","_param.bladeType_","))
			continue:(param.bodySite'="")&((","_operListObj.BodySite_",") '[ (","_param.bodySite_","))
			//continue:(param.ageRange'="")
			// 手术医生筛选
			if (param.surgeon>0)
			{
				
				continue:((","_operListObj.Surgeon_",") '[ (","_param.surgeon_","))	
			}
		}
		//set rowCount=rowCount+1
		//continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
		//set findCount=findCount+1
		set ret=$$storeTempData()
	}
	&sql(close OPSCursor)
	set ret=$$writeTempData()
	//w "first:"_firstDT_" second:"_secDT_" third:"_thirdDT
	quit ""

storeTempData()
	set roomNode="A99"
	set dateNode=operDate
	set:(param.mulOper="Y") dateNode=EpisodeID
	set:(roomId>0) roomNode="A"_roomNode_roomCode
	set:('(roomId>0)) roomNode="Z"_appDeptID
	set seqNo=0
	set:(roomId>0) seqNo=+operSeq
	set:('(roomId>0)) seqNo=+planSeq
	set ^TMPOPS($j,dateNode,roomNode,seqNo,RowId)=""
	quit ""

writeTempData()
	set operDate=0,pageCount=0,rowCount=0
	w "{""rows"":["
	for
	{
		set operDate=$o(^TMPOPS($j,operDate))
		quit:(operDate="")
		set roomNode=""
		for
		{
			set roomNode=$o(^TMPOPS($j,operDate,roomNode))
			quit:(roomNode="")
			set seqNode=""
			for
			{
				set seqNode=$o(^TMPOPS($j,operDate,roomNode,seqNode))
				quit:(seqNode="")
				set opsId=0
				for
				{
					set opsId=$o(^TMPOPS($j,operDate,roomNode,seqNode,opsId))
					quit:(opsId="")
					set rowCount=rowCount+1
					continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
					set pageCount=pageCount+1
					w:(pageCount>1) ","
					set jsonStr=..GetOperScheduleJSON(opsId)
					w jsonStr	
				}	
			}	
		}	
	}
	w "],""total"":"_rowCount_"}"
	quit ""
	
writeOpsListData(opsIdList)
	set opsIdCount=$l(opsIdList,","),pageCount=0,rowCount=0
	w "{""rows"":["
	for i=1:1:opsIdCount
	{
		set opsId=$p(opsIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set rowCount=rowCount+1
		continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
		set pageCount=pageCount+1
		w:(pageCount>1) ","
		set jsonStr=..GetOperScheduleJSON(opsId)
		w jsonStr	
	}
	w "],""total"":"_rowCount_"}"
	
	
Error
	quit "E^"_$ze
	
inAgeRange(ageRange)
	set ageMin=$p(ageRange,"-",1)
	set ageMax=$p(ageRange,"-",2)
GetFinishOperCount()
	set finishedCount=0
	&sql(select count(%ID) into :finishedCount from CIS_AN.OperSchedule where EpisodeID=:EpisodeID and Status->Code in ('RoomOut','PACUOut','Finish'))
	quit finishedCount
}

/// Creator：      	陈长青
/// CreatDate：    	2020-11-09
/// Description： 	获取手术列表
/// Table：        	CIS_AN.OperSchedule
/// Input:			param:查询参数动态对象 
/// Return：       	手术信息JSON字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-09","endDate":"2020-11-09","userDeptID":"236","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","surgeon":"1259","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-11-16","endDate":"2020-11-16","userDeptID":"134","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"startDate":"2020-10-29","endDate":"2020-10-29","userDeptID":"74","surgeon":"2403","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleList({"patName":"姚锡勇"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleListNew({"startDate":"2020-11-23","endDate":"2020-11-23","userDeptID":"213","statusCode":"Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^"})
/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleListNew({"startDate":"2020-11-11","endDate":"2020-11-11","userDeptID":"55","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^","surgeon":"809"})
ClassMethod GetDSScheduleList(param As %DynamicObject) As %String
{
	set $zt="Error"
	// 判断是否分页
	set pagination=0,startIndex=0,endIndex=0
	set:(param.page>0)&(param.rows>0) pagination=1,startIndex=(param.page-1)*param.rows+1,endIndex=param.page*param.rows
	// 登记号查询
	if (param.regNo'="")
	{
		set opsIdStr=..GetOpsIdListByRegNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	// 病案号查询
	if (param.medcareNo'="")
	{
		set opsIdStr=..GetOpsIdListByMedcareNo(param.regNo)
		set ret=$$writeOpsListData(opsIdStr)
		quit ""		
	}
	// 患者姓名
	if (param.patName'="")
	{
		set regNoStr=##class(CIS.AN.BL.Admission).GetRegNoByName(param.patName)
		set regNoCount=$l(regNoStr,",")
		set opsIdListStr=""
		for i=1:1:regNoCount
		{
			set regNo=$p(regNoStr,",",i)
			continue:(regNo="")
			set opsIdStr=..GetOpsIdListByRegNo(regNo)
			set:(opsIdStr'="") opsIdListStr=opsIdListStr_$lb(opsIdStr)
		}
		set opsIdStr=$lts(opsIdListStr,",")
		b //ccq
		set ret=$$writeOpsListData(opsIdStr)
		quit ""	
	}
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.startDate,"")
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(param.endDate,"")
	set deptConfig=..GetDeptConfig(param.userDeptID)
	set INStatusCode="^"_$System.SQL.UPPER(param.statusCode)_"^"
	set EMStatusCode=INStatusCode_"APPLICATION^"
	set appDeptType="^IN^OUT^EM^"
	
	k ^TMPOPS($j)
	&sql(declare DSListCursor cursor for select %ID
		into :RowId from CIS_AN.OperSchedule 
		where OperDate>=:startDateH 
		and OperDate<=:endDateH)
	&sql(open DSListCursor)
	for
	{
		&sql(fetch DSListCursor)
		quit:(SQLCODE'=0)
		set opsInfo=^CIS.AN.OperScheduleD(RowId)
		set appDeptID=$li(opsInfo,3),operDeptID=$li(opsInfo,4),anaDeptID=$li(opsInfo,65)
		set daySurgery=$li(opsInfo,61),sourceType=$li(opsInfo,18),OPAdmType=$li(opsInfo,74)
		set EpisodeID=$li(opsInfo,1),operDate=$li(opsInfo,14),operSeq=$li(opsInfo,56)
		set planSeq=$li(opsInfo,41),roomId=$li(opsInfo,55),roomCode=$lg($g(^CF.AN.LocationD(+roomId)),1)
		set statusID=$li(opsInfo,9),statusCode=$lg($g(^CT.AN.OperStatusD(+statusID)),1)
		//set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(RowId)
		set surgeonDept=$$GetSurgeonDept()
		set patInfo=..GetPatInfo(EpisodeID)
		set curAppDeptID=","_appDeptID_","_patInfo.PatDeptID_","
		set:(surgeonDept'="") curAppDeptID=curAppDeptID_surgeonDept_","
		// 手术状态筛选
		set curStatusCode="^"_$System.SQL.ALPHAUP(statusCode)_"^"
		set filterStatusCode=INStatusCode
		set:(sourceType="E") filterStatusCode=EMStatusCode						// 急诊手术可以查询申请状态
		continue:(param.statusCode'="")&(filterStatusCode '[ curStatusCode)
		continue:(param.statusID>0)&(statusID'=param.statusID)
		//b //ccq2
		if (param.surgeon="")
		{
			continue:(deptConfig.DeptType="OP")&(operDeptID'=param.userDeptID)									// 登录科室类型为手术室，只查该手术室手术
			//continue:(deptConfig.DeptType="AN")&(curOps.AnaDept'=param.userDeptID)									// 登录科室类型为麻醉科，只查该麻醉科手术
			continue:(param.appDeptID="")&(appDeptType [ ("^"_deptConfig.DeptType_"^"))&(curAppDeptID '[ (","_param.userDeptID_","))				// 登录科室类型住院、门诊和急诊手术申请科室，只查本科室手术
			continue:(param.appDeptID'="")&(curAppDeptID '[ (","_param.appDeptID_","))
			continue:(deptConfig.DeptType="DD")&(daySurgery'="Y")
			// 门诊手术筛选
			continue:(deptConfig.DeptType="OUT")&(OPAdmType'="OOP")
		}
		
		continue:(param.daySurgery="Y")&(daySurgery'="Y")
		
		// 手术间筛选
		set curOperRoomID=""
		set:(roomId>0) curOperRoomID=roomId
		continue:(param.roomId'="")&(param.roomId'=curOperRoomID)
		// 手术医生筛选
		if (param.surgeon>0)
		{
			set surgeon=$$GetSurgeon()
			continue:((","_surgeon_",") '[ (","_param.surgeon_","))	
		}
		set ret=$$storeTempData()
	}
	&sql(close DSListCursor)

	set ret=$$writeTempData()
	quit ""

storeTempData()
	set roomNode="A99"
	
	set:(roomId>0) roomNode="A"_roomCode
	set:('(roomId>0)) roomNode="Z"_appDeptID
	set seqNo=0
	set:(roomId>0) seqNo=+operSeq
	set:('(roomId>0)) seqNo=+planSeq
	set ^TMPOPS($j,operDate,roomNode,seqNo,RowId)=""
	quit ""

writeTempData()
	set operDate=0,rowCount=0,pageCount=0
	w "{""rows"":["
	for
	{
		set operDate=$o(^TMPOPS($j,operDate))
		quit:(operDate="")
		set roomNode=""
		for
		{
			set roomNode=$o(^TMPOPS($j,operDate,roomNode))
			quit:(roomNode="")
			set seqNode=""
			for
			{
				set seqNode=$o(^TMPOPS($j,operDate,roomNode,seqNode))
				quit:(seqNode="")
				set opsId=0
				for
				{
					set opsId=$o(^TMPOPS($j,operDate,roomNode,seqNode,opsId))
					quit:(opsId="")
					set rowCount=rowCount+1
					continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
					set pageCount=pageCount+1
					w:(pageCount>1) ","
					set jsonStr=..GetOperScheduleJSON(opsId)
					w jsonStr	
				}	
			}	
		}	
	}
	w "],""total"":"_rowCount_"}"
	quit ""
	
writeOpsListData(opsIdList)
	set opsIdCount=$l(opsIdList,","),rowCount=0,pageCount=0
	w "{""rows"":["
	for i=1:1:opsIdCount
	{
		set opsId=$p(opsIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		//set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		//continue:(param.daySurgery="Y")&(operSchedule.DaySurgery'="Y")
		set rowCount=rowCount+1
		continue:(pagination)&((rowCount<startIndex)!(rowCount>endIndex))
		set pageCount=pageCount+1
		w:(pageCount>1) ","
		set jsonStr=..GetOperScheduleJSON(opsId)
		w jsonStr	
	}
	w "],""total"":"_rowCount_"}"
	
	
Error
	quit "E^"_$ze_$g(opsId)

GetSurgeonDept()
	set operDescId=0,curSurgeonDeptID=""
	for
	{
		set operDescId=$o(^CIS.AN.OperListI("IOPS",RowId,operDescId))
		quit:(operDescId="")
		set curSurgeonDeptID=curSurgeonDeptID_$lb($li(^CIS.AN.OperListD(operDescId),9))	
	}
	quit $lts(curSurgeonDeptID,",")
GetSurgeon()
	set operDescId=0,curSurgeonID=""
	for
	{
		set operDescId=$o(^CIS.AN.OperListI("IOPS",RowId,operDescId))
		quit:(operDescId="")
		set curSurgeonID=curSurgeonID_$lb($li(^CIS.AN.OperListD(operDescId),7))	
	}
	quit $lts(curSurgeonID,",")
}

/// Creator：      	陈长青
/// CreatDate：    	2021-4-30
/// Description： 	保存手术麻醉扩展信息(该方法批量保存扩展信息，请在事务中调用该方法，防止数据不一致)
/// Table：        	CIS_AN.OperExtension
/// Input:			extensionStr：扩展信息json字符串，格式为[{"OperSchedule":1,"ItemCode":"xxx","ItemDesc":"yyy","ItemValue":"zzz","ItemNote":""},{"OperSchedule":1,"ItemCode":"xxx","ItemDesc":"yyy","ItemValue":"zzz","ItemNote":""}]
/// Return：       	保存成功返回"S^"，失败返回"E^错误原因"
ClassMethod SaveOperExtensions(extensionStr As %String, userId As %String) As %String
{
	set extensionArray=##class(%DynamicArray).%FromJSON(extensionStr)
	set iter = extensionArray.%GetIterator()
	set saveRet="S^"
    while iter.%GetNext(.key , .value ) {
       set opsId=value.OperSchedule,itemCode=value.ItemCode
       set extensionId=..ExistsExtensionCode(opsId,itemCode)
       set extension=""
       if (extensionId>0)
       {
	   	   set extension=##class(CIS.AN.OperExtension).%OpenId(extensionId)
	   }
	   else
	   {
			set extension=##class(CIS.AN.OperExtension).%New()   
	   }
	   set extension.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	   set extension.ItemCode=itemCode
	   set extension.ItemValue=value.ItemValue
	   set extension.ItemNote=value.ItemNote
	   set extension.ItemDesc=value.ItemDesc
	   set extension.UpdateUser=userId
	   set extension.UpdateDate=+$h
	   set extension.UpdateTime=$p($h,",",2)
	   set sc=extension.%Save()
	   set:($$$ISERR(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
	   quit:($p(saveRet,"^",1)'="S")
    }
    
    quit saveRet
}

ClassMethod ExistsExtensionCode(opsId As %String, itemCode As %String) As %String
{
	set findId=""
	&sql(select RowId into :findId from CIS_AN.OperExtension where OperSchedule=:opsId and ItemCode=:itemCode)
	quit findId
}

/// Creator：      	陈长青
/// CreatDate：    	2021-4-30
/// Description： 	获取手术麻醉扩展信息
/// Table：        	CIS_AN.OperExtension
/// Input:			opsId:手术申请ID，filterCode:项目代码
/// Return：       	扩展信息json字符串，格式为[{"OperSchedule":1,"ItemCode":"xxx","ItemDesc":"yyy","ItemValue":"zzz","ItemNote":""},{"OperSchedule":1,"ItemCode":"xxx","ItemDesc":"yyy","ItemValue":"zzz","ItemNote":""}]
ClassMethod GetOperExtensions(opsId As %String, filterCode As %String = "") As %String
{
	&sql(declare OperExtCursor cursor for select RowId,ItemCode,ItemDesc,ItemValue,ItemNote,OperSchedule into 
		 :rowId,:itemCode,:itemDesc,:itemValue,:itemNote,:operSchedule
		 from CIS_AN.OperExtension
		 where OperSchedule=:opsId
		 and (:filterCode is null or :filterCode=ItemCode))
	&sql(open OperExtCursor)
	set resultArray=##class(%DynamicArray).%New()
	for
	{
		&sql(fetch OperExtCursor)
		quit:(SQLCODE'=0)
		set extension=##class(%DynamicObject).%New()
		set extension.OperSchedule=operSchedule
		set extension.RowId=rowId
		set extension.ItemCode=itemCode
		set extension.ItemDesc=itemDesc
		set extension.ItemValue=itemValue
		set extension.ItemNote=itemNote
		do resultArray.%Push(extension)
	}	
	&sql(close OperExtCursor)
	quit resultArray.%ToJSON()
}

ClassMethod GetOperStatusByopsId(opsId As %String)
{
	set operStatusCode=""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set:operSchedule.Status'="" operStatusCode=operSchedule.Status.Code
	quit operStatusCode
}

Query FindAnaestCatheter(opsId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *,
	CIS_AN_COM.String_GetDescByID('User.ORCAnaestMethod','ANMETDesc',AnaMethod) As AnaMethodDesc,
	Catheter -> Description As CatheterDesc,
	CatheterType -> Description As CatheterTypeDesc,
	(CatheterDepth -> Description)_(CatheterDepth -> Unit) As CatheterDepthDesc,
	CatheterPath -> Description As CatheterPathDesc,
	CatheterTool -> Description As CatheterToolDesc,
	CatheterDirection -> Description As CatheterDirectionDesc,
	PunctureSpace -> Description As PunctureSpaceDesc,
	PositionMethod -> Description As PositionMethodDesc,
	NerveBlockSite -> Description As NerveBlockSiteDesc
	from CIS_AN.AnaestCatheter
	where (Anaesthesia -> OperSchedule)=:opsId
}

}
