Class CIS.AN.BL.OperScheduleStatistics Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	查询手术计划列表
/// Table：        	DHCAN.OperSchedule, DHCAN.AnaestOperation
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.userDeptID:用户科室ID，4.opsId:手术ID，5.appDeptID:申请科室ID
/// 				6.patWardID:病人科室ID，7.operStatusID:手术状态ID，8.operRoomID:手术间ID，9.regNo:登记号，10.medcareNo:病案号
/// 				11.byAppTime:按申请日期查询手术，12.allDeptOperation:查询所有科室手术，13.operArrange:只查询已排班的手术申请
/// 				14.filterPatName:患者姓名, 15.scrubNurseId:器械护士Id, 16.circualNurseId:巡回护士Id, 17.surgeonDesc:手术医生姓名
/// 					18.operFloor:手术楼层
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperSchedule","FindOperScheduleList","2019-03-29","2019-03-29","215","98","","","Accept^Application^Arrange")
Query FindOperScheduleList(startDate As %String, endDate As %String, userDeptID As %String, opsId As %String = "", appDeptID As %String = "", patWardID As %String = "", operStatusID As %String = "", operRoomID As %String = "", regNo As %String = "", medcareNo As %String = "", byAppTime As %String = "N", allDeptOperation As %String = "N", operArrange As %String = "N", filterPatNameOrMedNo As %String = "", scrubNurseId As %String = "", circualNurseId As %String = "", surgeonDesc As %String = "", operFloor As %String = "") As %Query(ROWSPEC = "RowId,PatientID,PatCardID,MRAdmID,RegNo,MedcareNo,EpisodeID,ExtAnaestID,OperRoom,RoomDesc,RoomInfo,OperSeq,OperSeqInfo,PatName,PatGender,PatDOB,PatAge,Patient,AdmReason,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,WardBed,AppDeptID,AppDeptDesc,AppDeptAlias,OperDeptID,OperDeptDesc,PrevDiagnosis,PrevDiagnosisDesc,PostDiagnosis,PostDiagnosisDesc,Operation,OperationDesc,BodySiteDesc,OperPosDesc,OperInfo,OperNote,Surgeon,SurgeonDesc,SurgeonShortDesc,Assistant,AssistantDesc,FirstAss,FirstAssDesc,SurCareProv,ScrubNurse,ScrubNurseDesc,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,CircualNurse,CircualNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,OperDate,OperDateTime,AppDateTime,OperRequirementDesc,LabInfo,Status,OperStatusCode,OperStatusDesc,StatusColor,SourceType,SourceTypeDesc,IsoOperation,ECC,TransAutoblood,PrepareBlood,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRequirement,LabTest,OperTime,OperDuration,PrevAnaMethod,PrevAnaMethodDesc,ReentryOperation,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaCareProv,AnaStaff,ArrAnaExpert,ArrAnaExpertDesc,ArrAnaDoc,ArrAnaDocDesc,ArrAnaAss,ArrAnaAssDesc,ArrAnaStaff,AnaScheduleId,PatWeight,PatHeight,SurgicalMaterials,SpecialConditions,PlanSeq,OperStartDT,OperFinishDT,TheatreInDT,TheatreOutDT,Infection,InfectionLabData,ABO,RH,Antibiotic,LongOperation,PathResult,PreFasting,PreOperNote,TheatreOutTransLoc,AreaOutTransLoc,PACUBed,PACUInDT,PACUOutDT,PlanOperationDesc,ASAClass,ASAClassDesc,PreFastingDesc,PreMedication,OperPosition,OperPositionDesc,AnaestMethod,PlanOperInfo,AreaInDT,AreaOutDT,AnaestMethodInfo,anPreVisit,anPostVisit,operPreVisit,operPostVisit,patPreShift,patPostShift,PACUBackShift,patPostFlup,Pneumothorax,Pneumoperitoneum,ECGDoctor,InfectionOper,Antibiosis,SpecialMaterial,HighConsume,SeqType,RoomCode,TotalIn,CrystalloidVol,ColloidalVol") [ SqlProc ]
{
}

ClassMethod FindOperScheduleListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, userDeptID As %String, opsId As %String = "", appDeptID As %String = "", patWardID As %String = "", operStatusID As %String = "", operRoomID As %String = "", regNo As %String = "", medcareNo As %String = "", byAppTime As %String = "N", allDeptOperation As %String = "N", operArrange As %String = "N", filterPatNameOrMedNo As %String = "", scrubNurseId As %String = "", circualNurseId As %String = "", surgeonDesc As %String = "", operFloor As %String = "") As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=1)
	{
		do OutputRow
		s qHandle=$lb(0,repid,0)
		q $$$OK		
	}
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	set:(byAppTime="Y") indexNode="AppDate"
	set linkDeptStr=##class(CIS.AN.COM.Admission).GetLinkLocId(userDeptID)
	if (linkDeptStr="")
	{
		set linkDeptStr=userDeptID	
	}
	else
	{
		set linkDeptStr=linkDeptStr_"^"_userDeptID
	}
	
	// 如果是手术安排界面获取未排手术列表信息，那么根据配置获取未排手术的状态
	set operArrangeStatus=""
	if (operArrange="Y")
	{
		set operArrangeStatus=##class(CIS.AN.BL.DataConfiguration).GetValueByKey(##class(CIS.AN.BL.Constant).#NeedArrangeOperStatus)	
	}
	
	kill operScheduleList
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:(userDeptID'=appDeptID)&(("^"_linkDeptStr_"^")'[("^"_operSchedule.OperDeptID_"^"))
			continue:(appDeptID'="")&(appDeptID'=operSchedule.AppDeptID)
			continue:(patWardID'="")&(patWardID'=operSchedule.PatWardID)
			set statusCodeStr="^"_$System.SQL.UPPER(operSchedule.Status.Code)_"^"
			set paraStatusStr="^"_$System.SQL.UPPER(operStatusID)_"^"
			continue:(operStatusID'="")&(operStatusID'=operSchedule.Status.%Id())&(paraStatusStr'[statusCodeStr)
			
			continue:(operArrange="Y")&(operArrangeStatus'=operSchedule.Status.%Id())
			
			set thisOperRoomID="",thisOperFloorID=""
			if (operSchedule.OperRoom'="")
			{
				set thisOperRoomID=operSchedule.OperRoom.%Id()	
				if (operSchedule.OperRoom.OperFloor'=""){
					set thisOperFloorID=operSchedule.OperRoom.OperFloor.%Id()	
				}
			}
			continue:(operRoomID'="")&(operRoomID'="All")&(operRoomID'=thisOperRoomID)
			continue:(operRoomID="All")&(operRoomID="")
			continue:(operFloor'="")&(operFloor'=thisOperFloorID)
			set thisRegNo=##class(CIS.AN.COM.Admission).GetRegNobyEpisodeID(operSchedule.EpisodeID)
			continue:(regNo'="")&(thisRegNo'=regNo)
			set thisMedCareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",operSchedule.EpisodeID)
			continue:(medcareNo'="")&(medcareNo'=thisMedCareNo)
			continue:(filterPatNameOrMedNo'="")&(operSchedule.PatName'[filterPatNameOrMedNo)&(thisMedCareNo'=filterPatNameOrMedNo)
			set curScrubNurseId=","_operSchedule.ScrubNurse_","
			continue:(scrubNurseId'="")&(curScrubNurseId'[(","_scrubNurseId_","))
			set curCircualNurseId=","_operSchedule.CircualNurse_","
			continue:(circualNurseId'="")&(curCircualNurseId '[ (","_circualNurseId_","))
			set curSurgeonDesc=##class(CIS.AN.BL.OperationList).GetSurgeonDesc(opsId)
			set curSurgeonDesc=","_curSurgeonDesc_","
			continue:(surgeonDesc'="")&(curSurgeonDesc '[ (","_surgeonDesc_","))
			//continue:(operSchedule.OriginalSchedule'="")
			//do OutputRow
			set operRoomRowId=""
			set operRoom = operSchedule.OperRoom
			set:operRoom'="" operRoomRowId=operSchedule.OperRoom.%Id()
			set operSeq = operSchedule.OperSeq
			
			set:operRoomRowId="" operRoomRowId=10000
			set:+operSeq=0 operSeq=10000
			
			set operScheduleList(+operRoomRowId,+operSeq,opsId)=""
			;b //ccq
		}	
	}
	
	set firstSeq=0
	for
	{
		set firstSeq=$o(operScheduleList(firstSeq))
		quit:firstSeq=""
		;b //ccq3
		set secondSeq=0
		for
		{
			set secondSeq=$o(operScheduleList(firstSeq,secondSeq))
			quit:secondSeq=""
			
			set opsId=""
			for
			{
				set opsId=$o(operScheduleList(firstSeq,secondSeq,opsId))
				quit:opsId=""
				;b //ccq2
				do OutputRow
			}
		}
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=..GetOperSchedule(opsId)
	;s ^TXTXTXTX(repid,ind)=^CacheTemp(repid,ind)
	s ind=ind+1
	q
}

ClassMethod FindOperScheduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOperScheduleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	获取手术详细信息
/// Table：        	DHCAN.OperSchedule
/// Input:			opsId:手术明细ID
/// Return：       	手术详细信息
/// w ##class(CIS.AN.BL.OperSchedule).GetOperSchedule("5565")
ClassMethod GetOperSchedule(opsId As %String, singleOperation As %String = "N") As %List
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set rowId=operSchedule.%Id()
	set EpisodeID=operSchedule.EpisodeID
	set ExtAnaestID=""
	if (operSchedule.ExternalID'="")
	{
		
		set ExtAnaestID=$P($g(^DHCANOPArrange(operSchedule.ExternalID)),"^",2)	
	}

	// 手术间
	set roomID="",roomDesc="",roomCode=""
	if (operSchedule.OperRoom'="")
	{
		set roomDesc=operSchedule.OperRoom.Description
		set roomCode=operSchedule.OperRoom.Code
		set roomID=operSchedule.OperRoom.%Id()	
	}
	set roomInfo=roomDesc
	set:(roomInfo="") roomInfo="第99间"		// 连台手术（排班时未指定手术间）显示在最后。
	if (operSchedule.Status.Code="Arrange")&&(roomDesc=""){
		set roomDesc="连台"
		set roomInfo="第98间"
	}
	
	// 台次
	set operSeq=operSchedule.OperSeq
	set operSeqInfo=operSeq
	set:($length(operSeqInfo)=1) operSeqInfo="0"_operSeqInfo
	set:(operSeqInfo="") operSeqInfo="99"
	// 病人姓名、性别、年龄、登记号、病案号
	set patName="",patGender="",patAge="",regNo="",medcareNo="",patientID="",mradmID="",patient="",patCardID=""
	set admReason="",patDOB=""
	set EpisodeID=operSchedule.EpisodeID
	set targetQuery="CIS.AN.BL.Admission:FindPatient"
    if ##class(CIS.AN.BL.Admission).ExistsInstance(EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
	set patQuery=##class(%ResultSet).%New(targetQuery)
	set sc=patQuery.Execute(operSchedule.EpisodeID)
	while(patQuery.%Next())
	{
		set patName=patQuery.Get("PatName")
		set patGender=patQuery.Get("PatGender")
		set patAge=patQuery.Get("PatAge")	
		set patDOB=patQuery.Get("PatDOB")
		set patient=patName_"("_patGender_" "_patAge_")"
		set regNo=patQuery.Get("RegNo")
		set medcareNo=patQuery.Get("MedcareNo")
		// PatientID
		set patientID=patQuery.Get("PatientID")
		// MRAdmID
		set mradmID=patQuery.Get("MRAdmID")
		set admReason=patQuery.Get("AdmReason")
		set patCardID=patQuery.Get("CardID")
	}
	// 病人科室(申请手术时，下同)
	set patDeptID=operSchedule.PatDeptID
	set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",patDeptID)
	// 病区
	set patWardID=operSchedule.PatWardID
	set patWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",patWardID)
	// 床位
	set patBedID=operSchedule.PatBedID
	set patBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",patBedID)
	set:(patBedCode="") patBedCode=patBedID
	// 病区床位
	set wardBed=patWardDesc_" "_patBedCode
	
	// 申请科室
	set appDeptID=operSchedule.AppDeptID
	set appDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",appDeptID)
	set appDeptAlias=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCContactName",appDeptID)
	// 手术室
	set operDeptID=operSchedule.OperDeptID
	set operDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operDeptID)
	// 术前诊断
	set diagInfo=..GetDiagnosisDesc(operSchedule.PrevDiagnosis)
	set prevDiagnosis=$piece(diagInfo,"^",1)
	set prevDiagnosisDesc=$piece(diagInfo,"^",2)
	set:(prevDiagnosisDesc="") prevDiagnosisDesc=prevDiagnosis
	set prevDiagnosis=$tr(prevDiagnosis,"\",",")
	set prevDiagnosisDesc=$tr(prevDiagnosisDesc,"\",",")
	
	// 术后诊断
	set diagInfo=..GetDiagnosisDesc(operSchedule.PostDiagnosis)
	set postDiagnosis=$piece(diagInfo,"^",1)
	set postDiagnosisDesc=$piece(diagInfo,"^",2)
	set:(postDiagnosisDesc="") postDiagnosisDesc=postDiagnosis
	// 如果术后诊断没有数据，那么赋值成术前诊断
	set:(postDiagnosis="") postDiagnosis=prevDiagnosis
	set:(postDiagnosisDesc="") postDiagnosisDesc=prevDiagnosisDesc
	set postDiagnosis=$tr(postDiagnosis,"\",",")
	set postDiagnosisDesc=$tr(postDiagnosisDesc,"\",",")

	// 手术名称、手术医生、手术助手
	set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=anaOperQuery.Execute(rowId)
	set operation="",operationDesc="",surgeon="",surgeonDesc="",assistant="",assistantDesc="",operPosDesc=""
	set operInfo="",bodySiteDesc="",surgeonShortDesc="",operNote="",firstAss="",firstAssDesc=""
	while(anaOperQuery.%Next())
	{
		// 手术ID和名称
		set:(operation'="") operation=operation_","
		set:(operationDesc'="") operationDesc=operationDesc_","
		// 手术医生ID、姓名和别名
		set:(surgeon'="") surgeon=surgeon_","
		set:(surgeonDesc'="") surgeonDesc=surgeonDesc_","
		set:(surgeonShortDesc'="") surgeonShortDesc=surgeonShortDesc_","
		// 手术助手
		set:(assistant'="") assistant=assistant_","
		set:(assistantDesc'="") assistantDesc=assistantDesc_","
		// 手术信息(如果手术名称备注有内容，那么使用手术名称备注作为手术名称)
		set:(operInfo'="") operInfo=operInfo_","
		set:(operPosDesc'="") operPosDesc=operPosDesc_","
		set operation=operation_anaOperQuery.Get("Operation")
		set operationDesc=operationDesc_anaOperQuery.Get("OperationDesc")
		set surgeon=surgeon_anaOperQuery.Get("Surgeon")
		set surgeonDesc=surgeonDesc_anaOperQuery.Get("SurgeonDesc")
		set:(surgeonDesc="") surgeonDesc=surgeon
		set surgeonShortDesc=surgeonShortDesc_anaOperQuery.Get("SurgeonShortDesc")
		set assistant=assistant_anaOperQuery.Get("Assistant")
		set assistantDesc=assistantDesc_anaOperQuery.Get("AssistantDesc")
		set firstAss=$p(assistant,",",1),firstAssDesc=$p(assistantDesc,",",1)
		set operPosDesc=operPosDesc_anaOperQuery.Get("OperPosDesc")
		set operNote=anaOperQuery.Get("OperNote")
		set:(operationDesc="") operationDesc=operNote
		set operInfoNote=operNote
		if (operInfoNote="")
		{
			set operInfoNote=operationDesc	
		}
		set operInfo=operInfo_operInfoNote
		set operClassDesc=anaOperQuery.Get("OperClassDesc")
		
		set curbodySiteDesc=anaOperQuery.Get("BodySiteDesc")
		if (curbodySiteDesc'="")
		{
			set:(bodySiteDesc'="") bodySiteDesc=bodySiteDesc_"，"
			set bodySiteDesc=bodySiteDesc_curbodySiteDesc	
		}
		//if (operClassDesc'="")&(bodySiteDesc'="")
		//{
		//	set operInfo=operInfo_"("_anaOperQuery.Get("OperClassDesc")_","_anaOperQuery.Get("BodySiteDesc")_")"	
		//}
		
	}
	set operationDesc=$tr(operationDesc,"""","")
	set operNote=$tr(operNote,"""","")
	set operInfo=$tr(operInfo,"""","")
	
	// 拟施手术名称、手术医生、手术助手
	set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindPlanOperationList")
	set sc=anaOperQuery.Execute(rowId)
	set planOperation="",planOperationDesc="",planOperInfo=""
	set planSurgeon="",planSurgeonDesc="",planSurgeonShortDesc=""
	set planAssistant="",planAssistantDesc=""
	set planOperPosDesc="",planBodySiteDesc=""
	while(anaOperQuery.%Next())
	{
		// 手术ID和名称
		set:(planOperation'="") planOperation=planOperation_","
		set:(planOperationDesc'="") planOperationDesc=planOperationDesc_","
		// 手术医生ID、姓名和别名
		set:(planSurgeon'="") planSurgeon=planSurgeon_","
		set:(planSurgeonDesc'="") planSurgeonDesc=planSurgeonDesc_","
		set:(planSurgeonShortDesc'="") planSurgeonShortDesc=planSurgeonShortDesc_","
		// 手术助手
		set:(planAssistant'="") planAssistant=planAssistant_","
		set:(planAssistantDesc'="") planAssistantDesc=planAssistantDesc_","
		// 手术信息(如果手术名称备注有内容，那么使用手术名称备注作为手术名称)
		set:(planOperInfo'="") planOperInfo=planOperInfo_","
		set:(planOperPosDesc'="") planOperPosDesc=planOperPosDesc_","
		set planOperation=planOperation_anaOperQuery.Get("Operation")
		set planOperationDesc=planOperationDesc_anaOperQuery.Get("OperationDesc")
		set planSurgeon=planSurgeon_anaOperQuery.Get("Surgeon")
		set planSurgeonDesc=planSurgeonDesc_anaOperQuery.Get("SurgeonDesc")
		set planSurgeonShortDesc=planSurgeonShortDesc_anaOperQuery.Get("SurgeonShortDesc")
		set planAssistant=planAssistant_anaOperQuery.Get("Assistant")
		set planAssistantDesc=planAssistantDesc_anaOperQuery.Get("AssistantDesc")
		set planOperPosDesc=planOperPosDesc_anaOperQuery.Get("OperPosDesc")
		set planOperNote=anaOperQuery.Get("OperNote")
		set:(planOperationDesc="") planOperationDesc=planOperNote
		set operInfoNote=planOperNote
		if (operInfoNote="")
		{
			set operInfoNote=planOperationDesc	
		}
		set planOperInfo=planOperInfo_operInfoNote
		set operClassDesc=anaOperQuery.Get("OperClassDesc")
		
		set curbodySiteDesc=anaOperQuery.Get("BodySiteDesc")
		if (curbodySiteDesc'="")
		{
			set:(planBodySiteDesc'="") planBodySiteDesc=planBodySiteDesc_"，"
			set planBodySiteDesc=planBodySiteDesc_curbodySiteDesc	
		}
		if (operClassDesc'="")&&(curbodySiteDesc'="")
		{
			set planOperInfo=planOperInfo_"("_anaOperQuery.Get("OperClassDesc")_","_curbodySiteDesc_")"	
		}
		
	}
	set planOperationDesc=$tr(planOperationDesc,"""","")
	
	set surCareProv=surgeonDesc
	if (assistantDesc'="")
	{
		if (surCareProv'="")
		{
			set surCareProv=surCareProv_","	
		}	
		set surCareProv=surCareProv_assistantDesc
	}
	// 器械护士、巡回护士
	set scrubNurse=operSchedule.ScrubNurse
	set scrubNurseDesc=##class(CIS.AN.BL.OperationList).GetAssistantDesc(scrubNurse)
	set firstScrubNurse=$p(scrubNurse,",",1)
	set firstScrubNurseDesc=$p(scrubNurseDesc,",",1)
	set secScrubNurse=$p(scrubNurse,",",2)
	set secScrubNurseDesc=$p(scrubNurseDesc,",",2)
	set circualNurse=operSchedule.CircualNurse
	set circualNurseDesc=##class(CIS.AN.BL.OperationList).GetAssistantDesc(circualNurse)
	set firstCirNurse=$p(circualNurse,",",1)
	set firstCirNurseDesc=$p(circualNurseDesc,",",1)
	set secCirNurse=$p(circualNurse,",",2)
	set secCirNurseDesc=$p(circualNurseDesc,",",2)
	//set secCirNurse=$p(circualNurse,",",2)
	//set secCirNurseDesc=##class(CIS.AN.BL.OperationList).GetAssistantDesc(secCirNurse)
	
	
	// 手术日期
	set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
	// 手术日期时间
	set operDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.OperDate,operSchedule.OperTime,"")
	// 手术申请日期时间
	set appDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime,"")
	// 手术要求
	set operRequirementDesc=..GetOperRequirement(opsId)
	set isoOperation=operSchedule.IsoOperation
	set ECC=operSchedule.ECC
	set transAutoblood=operSchedule.TransAutoblood
	set prepareBlood=operSchedule.PrepareBlood
	set operRequirement=operSchedule.OperRequirement
	// 检验信息
	set labInfo=..GetLabInfo(opsId)
	set bloodType=operSchedule.BloodType
	//set bloodType="" //$p(##class(web.DHCClinicCom).GetLatestTestResult(EpisodeID,"ABO","&&&"),"\",1)
	set RHBloodType=operSchedule.RHBloodType
	//set RHBloodType=$p(##class(web.DHCClinicCom).GetLatestTestResult(EpisodeID,"RH","&&&"),"\",1)
	set HbsAg=operSchedule.HbsAg,HcvAb=operSchedule.HcvAb,HivAb=operSchedule.HivAb,Syphilis=operSchedule.Syphilis
	set labtest=operSchedule.LabTest
	// 手术状态
	set operStatus=operSchedule.Status.%Id()
	set operStatusCode=operSchedule.Status.Code
	set operStatusDesc=operSchedule.Status.Description
	set statusColor=operSchedule.Status.BGColor
	// 手术类型
	set sourceType=operSchedule.SourceType
	set sourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
	// 手术时间
	set operTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")
	set operTime=$p(operTime,":",1)_":"_$p(operTime,":",2)
	// 手术时长
	set operDuration=operSchedule.OperDuration
	// 拟施麻醉
	set prevAnaMethod=operSchedule.PrevAnaMethod,prevAnaMethodDesc=""
	if (prevAnaMethod'="")
	{
		set prevAnaMethodDesc=..GetAnaestMethodDesc(prevAnaMethod)	
		set:(prevAnaMethodDesc="") prevAnaMethodDesc=prevAnaMethod
	}
	// 重返手术
	set reentryOperation=operSchedule.ReentryOperation
	
	// 麻醉指导
	/* 麻醉相关信息是在麻醉表中 // 邓体进 2020-04-20修改
	set anaExpert=operSchedule.AnaExpert
	set anaExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaExpert)
	set:(anaExpertDesc="") anaExpertDesc=anaExpert
	// 麻醉医生
	set anesthesiologist=operSchedule.Anesthesiologist
	set anesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anesthesiologist)
	set:(anesthesiologistDesc="") anesthesiologistDesc=anesthesiologist
	// 麻醉助手
	set anaAssistant=operSchedule.AnaAssistant
	set anaAssistantDesc=##class(CIS.AN.BL.OperationList).GetAssistantDesc(anaAssistant)
	set:(anaAssistantDesc="") anaAssistantDesc=anaAssistant
	set anaStaff=operSchedule.AnaAddtionalStaff
	// 麻醉医护人员
	set anaCareProv=anesthesiologistDesc  //anaExpertDesc
	
	if (anaAssistantDesc'="")
	{
		if (anaCareProv'="")
		{
			set anaCareProv=anaCareProv_","	
		}	
		set anaCareProv=anaCareProv_anaAssistantDesc
	}
	
	if (anaExpertDesc'="")
	{
		if (anaCareProv'="")
		{
			set anaCareProv=anaCareProv_","	
		}	
		set anaCareProv=anaCareProv_anaExpertDesc
	}
	*/
	// 排班麻醉医生
	set anaScheduleId=$order(^CIS.AN.AnaestScheduleI("OPS",opsId,0))
	set arrAnaExpert="",arrAnaExpertDesc="",arrAnaDoc="",arrAnaDocDesc="",arrAnaAss="",arrAnaAssDesc="",arrAnaStaff=""
	if (##class(CIS.AN.AnaestSchedule).%ExistsId(anaScheduleId))
	{
		// 麻醉指导
		set anaSchedule=##class(CIS.AN.AnaestSchedule).%OpenId(anaScheduleId)
		set arrAnaExpert=anaSchedule.AnaExpert
		set arrAnaExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",arrAnaExpert)
		set:(arrAnaExpertDesc="") arrAnaExpertDesc=arrAnaExpert
		// 麻醉医生
		set arrAnaDoc=anaSchedule.Anesthesiologist
		set arrAnaDocDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",arrAnaDoc)
		set:(arrAnaDocDesc="") arrAnaDocDesc=arrAnaDoc
		// 麻醉助手
		set arrAnaAss=anaSchedule.AnaAssistant
		set arrAnaAssDesc=##class(CIS.AN.BL.OperationList).GetAssistantDesc(arrAnaAss)
		set:(arrAnaAssDesc="") arrAnaAssDesc=arrAnaAss
		
		set arrAnaStaff=anaSchedule.AnaAddtionalStaff	
	}
	// 身高、体重
	set patWeight=operSchedule.PatWeight
	set patHeight=operSchedule.PatHeight
	// 手术物品、特殊情况
	set surgicalMaterials=operSchedule.SurgicalMaterials
	set specialConditions=operSchedule.SpecialConditions
	// 计划台次
	set planSeq=operSchedule.PlanSeq
	// 手术开始日期和时间 手术结束日期和时间 入手术间日期和时间 离手术间日期和时间
	set operStartDT=operSchedule.OperStartDT
	set operFinishDT=operSchedule.OperFinishDT
	set theatreInDT=operSchedule.TheatreInDT
	set theatreOutDT=operSchedule.TheatreOutDT
	set areaInDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"PatientHandOver","TheatreInTime")
	set areaOutDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"PatientHandOver","TheatreOutTime")
	// 检验数据
	set infectionData="" //##class(CIS.AN.BL.LabData).GetInfectiousData(opsId)
	set infection=$piece(infectionData,"^",1)
	set infectionLabData=$piece(infectionData,"^",2)
	set bloodTypeData="" //##class(CIS.AN.BL.LabData).GetBloodType(opsId)
	set ABO=$piece(bloodTypeData,"^",1)
	set RH=$piece(bloodTypeData,"^",2)
	if bloodType'="" set ABO=bloodType
	if RHBloodType'="" set RH=RHBloodType
	// 是否有抗生素
	set antibiotic="" //##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"PatientHandOver","PreAntibioticQty")
	
	// 手术时长是否超3小时
	set longOperation="N"
	if (theatreInDT'="")
	{
		set today=+$h
		set now=$p($h,",",2)
		set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(theatreInDT," ",1))
		set theatreInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(theatreInDT," ",2))	
		set duration=+##class(CIS.AN.COM.DateTime).CalculateDuration(today,now,theatreInDate,theatreInTime)
		set:(duration>10800) longOperation="Y"
	}
	
	// 病例诊断结果
	set pathResult="" //##class(CIS.AN.BL.Pathology).GetPathDiangosis(opsId)
	set pathResult=$tr(pathResult,$c(10),"")
	
	
	// 术前禁食
	set preFasting = operSchedule.PreFasting
	set preFastingDesc = $s(preFasting="Y":"是",preFasting="N":"否",1:"")
	
	// 术前特殊情况
	set preOperNote = $tr(operSchedule.PreOperNote,$c(0),"")
	set preOperNote = $tr(preOperNote,$c(10),"")
	
	// 转出、PACU
	set theatreOutTransLoc = operSchedule.TheatreOutTransLoc
	set areaOutTransLoc = operSchedule.AreaOutTransLoc
	if (operSchedule.PACUBed'="") set pacuBed = operSchedule.PACUBed.%Id()
	set pacuInDT = operSchedule.PACUInDT
	set pacuOutDT = operSchedule.PACUOutDT
	
	// ASA
	if (operSchedule.ASAClass'="") {
		set asaClass = operSchedule.ASAClass.%Id()
		set asaClassDesc = operSchedule.ASAClass.Description
	}
	
	// 术前用药
	set preMedication = operSchedule.PreMedication
	
	// 手术体位
	set OperPosition="",OperPositionDesc=""
	if (operSchedule.OperPosition'=""){
		set OperPosition = operSchedule.OperPosition
		set OperPositionDesc=..GetOperPosition(OperPosition)
		//set OperPosition = operSchedule.OperPosition.%Id()
		//set OperPositionDesc = operSchedule.OperPosition.Description
	}
	
	// 麻醉方式
	set AnaestMethod = ..GetAnaestCatheter(opsId)
	set AnaestMethodInfo=..GetAnaestMethod(opsId)
	//判断表单是否已经有记录
	//麻醉前访视
	set anPreVisit="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"PreAnaVisit","anPreVisitHasDone")
	//麻醉术后访视
	set anPostVisit="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"PostAnaVisit","anPostVisitHasDone")
	//术前访视
	set operPreVisit="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"OperationVisit","operPreVisitHasDone")
	//术后访视
	set operPostVisit="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"OperationVisit","operPostVisitHasDone")
	//术前交接
	set patPreShift="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"PatientHandOver","patPreShiftHasDone")
	//术后交接
	set patPostShift="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"PatientHandOver","patPostShiftHasDone")
	//PACU回房交接
	set PACUBackShift="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"PACUWardPatShift","PACUBackShiftHasDone")
	//麻醉术后随访
	set patPostFlup="" //##class(CIS.AN.BL.ANMobileScanInfo).RecordSheetHasDone(opsId,"PostPatientsFlup","postPatientFlupHasDone")
	
	// 气胸
	set Pneumothorax = operSchedule.Pneumothorax
	// 气腹
	set Pneumoperitoneum = operSchedule.Pneumoperitoneum
	
	// 心电监护医生
	set ECGDoctor = operSchedule.ECGDoctor
	
	// 感染手术
	set infectionOper=operSchedule.InfectionOper
	
	// 使用抗生素
	set antibiosis=operSchedule.Antibiosis
	
	// 特殊物品
	set specialMaterial=operSchedule.SurgicalMaterials
	
	// 高值耗材
	set highConsume=operSchedule.HighConsume
	
	// 台次类型
	set seqType=operSchedule.SeqType
	
	// 总入量
	set totalIn=operSchedule.TotalIn
	
	// 晶体液总量
	set crystalloidVol=operSchedule.CrystalloidVol
	
	// 胶体液总量
	set colloidalVol=operSchedule.ColloidalVol
	
	set result=$lb(rowId,patientID,patCardID,mradmID,regNo,medcareNo,EpisodeID,ExtAnaestID,roomID,roomDesc,roomInfo,operSeq,operSeqInfo,patName,patGender,patDOB,
				   patAge,patient,admReason,patDeptID,patDeptDesc,patWardID,patWardDesc,patBedID,patBedCode,wardBed,appDeptID,appDeptDesc,appDeptAlias,
				   operDeptID,operDeptDesc,prevDiagnosis,prevDiagnosisDesc,postDiagnosis,postDiagnosisDesc,operation,operationDesc,bodySiteDesc,operPosDesc,operInfo,operNote,
				   surgeon,surgeonDesc,surgeonShortDesc,assistant,assistantDesc,firstAss,firstAssDesc,surCareProv,scrubNurse,scrubNurseDesc,firstScrubNurse,firstScrubNurseDesc,secScrubNurse,secScrubNurseDesc,
				   circualNurse,circualNurseDesc,firstCirNurse,firstCirNurseDesc,secCirNurse,secCirNurseDesc,operDate,operDateTime,appDateTime,operRequirementDesc,labInfo,
				   operStatus,operStatusCode,operStatusDesc,statusColor,sourceType,sourceTypeDesc,isoOperation,
				   ECC,transAutoblood,prepareBlood,bloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,operRequirement,labtest,
				   operTime,operDuration,prevAnaMethod,prevAnaMethodDesc,reentryOperation,anaExpert,anaExpertDesc,
				   anesthesiologist,anesthesiologistDesc,anaAssistant,anaAssistantDesc,anaCareProv,anaStaff,arrAnaExpert,
				   arrAnaExpertDesc,arrAnaDoc,arrAnaDocDesc,arrAnaAss,arrAnaAssDesc,arrAnaStaff,anaScheduleId,patWeight,patHeight,
				   surgicalMaterials,specialConditions,planSeq,operStartDT,operFinishDT,theatreInDT,theatreOutDT,
				   infection,infectionLabData,ABO,RH,antibiotic,longOperation,pathResult,preFasting,preOperNote,theatreOutTransLoc,
				   areaOutTransLoc,pacuBed,pacuInDT,pacuOutDT,planOperationDesc,asaClass,asaClassDesc,preFastingDesc,preMedication,OperPosition,
				   OperPositionDesc,AnaestMethod,planOperInfo,areaInDT,areaOutDT,AnaestMethodInfo,anPreVisit,anPostVisit,operPreVisit,operPostVisit,
				   patPreShift,patPostShift,PACUBackShift,patPostFlup,Pneumothorax,Pneumoperitoneum,ECGDoctor,infectionOper,antibiosis,
				   specialMaterial,highConsume,seqType,roomCode,totalIn,crystalloidVol,colloidalVol)
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-16
/// Description： 	根据麻醉方法获取麻醉方法名称（导管信息）
/// Table：        	CIS.AN.Anaesthesia，CIS.AN.AnaestCatheter
/// Input:			opsId：手术安排ID
/// Return：       	麻醉方法名称字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetAnaestCatheter("7")
ClassMethod GetAnaestCatheter(opsId As %String) As %String
{
	set anaCatheters=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaestCatheter",opsId)
	
	set result=""
	
	for i=1:1:(anaCatheters.Size)
	{
		set anaCatheter = anaCatheters.GetAt(i)
		quit:anaCatheter=""
		
		set anmethod = ""
		set anmethod = anaCatheter.GetValue("AnaMethodDesc")
		
		set extraInfo = ""
		set CatheterDesc = anaCatheter.GetValue("CatheterDesc")
		set CatheterTypeDesc = anaCatheter.GetValue("CatheterTypeDesc")
		set CatheterDepthDesc = anaCatheter.GetValue("CatheterDepthDesc")
		set CatheterPathDesc = anaCatheter.GetValue("CatheterPathDesc")
		set CatheterToolDesc = anaCatheter.GetValue("CatheterToolDesc")
		set CatheterDirectionDesc = anaCatheter.GetValue("CatheterDirectionDesc")
		set PunctureSpaceDesc = anaCatheter.GetValue("PunctureSpaceDesc")
		set PositionMethodDesc = anaCatheter.GetValue("PositionMethodDesc")
		
		set extraInfo = CatheterDesc
		if CatheterTypeDesc'="" set extraInfo=extraInfo_" "_CatheterTypeDesc
		if CatheterDepthDesc'="" set extraInfo=extraInfo_" "_CatheterDepthDesc
		if CatheterPathDesc'="" set extraInfo=extraInfo_" "_CatheterPathDesc
		if CatheterToolDesc'="" set extraInfo=extraInfo_" "_CatheterToolDesc
		if CatheterDirectionDesc'="" set extraInfo=extraInfo_" "_CatheterDirectionDesc
		if PunctureSpaceDesc'="" set extraInfo=extraInfo_" "_PunctureSpaceDesc
		if PositionMethodDesc'="" set extraInfo=extraInfo_" "_PositionMethodDesc
		
		if extraInfo'="" set anmethod=anmethod_"("_extraInfo_")"
		set:result'="" result=result_"+"
		set result=result_anmethod
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-13
/// Description： 	根据麻醉方法获取麻醉方法名称
/// Table：        	CIS.AN.Anaesthesia，CIS.AN.AnaestCatheter
/// Input:			opsId：手术安排ID
/// Return：       	麻醉方法名称字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetAnaestMethod("7")
ClassMethod GetAnaestMethod(opsId As %String) As %String
{
	set anaesthesias=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaesthesia",opsId)
	
	set result=""
	
	for i=1:1:(anaesthesias.Size)
	{
		set anaesthesia = anaesthesias.GetAt(i)
		quit:anaesthesia=""
		
		set anmethod = ""
		set anmethod = anaesthesia.GetValue("AnaMethodDesc")
		
		set:result'="" result=result_"+"
		set result=result_anmethod
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-13
/// Description： 	根据麻醉方法获取麻醉方法名称
/// Table：        	CIS.AN.Anaesthesia，CIS.AN.AnaestCatheter
/// Input:			opsId：手术安排ID
/// Return：       	麻醉方法名称字符串
/// w ##class(CIS.AN.BL.OperSchedule).GetOperPosition("7")
ClassMethod GetOperPosition(operPosIdStr As %String) As %String
{
	set splitChar=",",result=""
	set operPosCount=$length(operPosIdStr,splitChar)
	for i=1:1:operPosCount
	{
		set operPosId=$piece(operPosIdStr,splitChar,i)
		continue:(##class(CT.AN.OperPosition).%ExistsId(operPosId)=0)
		set operPos=##class(CT.AN.OperPosition).%OpenId(operPosId)
		set:(result'="") result=result_splitChar
		set result=result_operPos.Description	
	}	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	获取检验信息
/// Table：        	DHCAN.OperSchedule
/// Input:			opsId:手术明细ID
/// Return：       	检验信息
/// w ##class(CIS.AN.BL.OperationList).GetLabInfo("1")
ClassMethod GetLabInfo(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set labCode=$lb(operSchedule.BloodType,operSchedule.RHBloodType,operSchedule.HbsAg,operSchedule.HcvAb,operSchedule.HivAb,operSchedule.Syphilis)
	set labCompareCode=$lb(operSchedule.BloodType,operSchedule.RHBloodType,"阳性","阳性","阳性","阳性")
	set labInfo=$lb("血型","RH血型","HbsAg","HcvAb","HivAb","梅毒")
	set labCount=$listlength(labCode),result=""
	for i=1:1:labCount
	{
		set thisLabCode=$list(labCode,i)
		set thisLabCompareCode=$list(labCompareCode,i)
		set thisLabInfo=$list(labInfo,i)
		
		if (thisLabCode=thisLabCompareCode)
		{
			set:(result'="") result=result_","
			set result=result_thisLabInfo_":"_thisLabCode	
		}
	}	
	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	获取手术要求
/// Table：        	DHCAN.OperSchedule
/// Input:			operSchedule:类DHCAN.OperSchedule的实体对象
/// Return：       	手术要求
/// w ##class(CIS.AN.BL.OperationList).GetOperRequirement("1")
ClassMethod GetOperRequirement(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set requireCode=$listbuild(operSchedule.IsoOperation,operSchedule.ECC,operSchedule.TransAutoblood,operSchedule.PrepareBlood,operSchedule.OperRequirement)
	set requireCompareCode=$lb("Y","Y","Y","Y",operSchedule.OperRequirement)
	set require=$listbuild("隔离手术","体外循环","自体血回输","备血",operSchedule.OperRequirement)
	set result="",requireCount=$listlength(requireCode)
	for i=1:1:requireCount
	{
		
		set thisRequireCode=$list(requireCode,i)
		set thisRequireCompareCode=$list(requireCompareCode,i)
		set thisRequire=$list(require,i)
		if (thisRequireCode=thisRequireCompareCode)
		{
			set:(result'="") result=result_","	
			set result=result_thisRequire	
		}
	}
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	获取诊断名称
/// Table：        	SQLUser.MRC_ICDDx
/// Input:			diagIdStr:诊断ID字符串，多个以","拼接
/// Return：       	诊断名称描述，多个助手以","拼接
/// w ##class(CIS.AN.BL.OperationList).GetDiagnosisDesc("1")
ClassMethod GetDiagnosisDesc(diagIdStr As %String) As %String [ SqlProc ]
{
	set splitChar=$c(5),dataSplitChar=$c(4),resultSplitChar=","
	set diagCount=$length(diagIdStr,splitChar),diagIdResult="",diagDescResult=""
	for i=1:1:diagCount
	{
		if (i>1)
		{
			set diagIdResult=diagIdResult_resultSplitChar
			set diagDescResult=diagDescResult_resultSplitChar
		}
		set diagInfo=$piece(diagIdStr,splitChar,i)
		set diagId=$piece(diagInfo,dataSplitChar,1)
		set diagIdResult=diagIdResult_diagId
		set diagDesc=$piece(diagInfo,dataSplitChar,2)
		set diagDescResult=diagDescResult_diagDesc
	}
	
	quit diagIdResult_"^"_diagDescResult
}

/// Creator：      	陈长青
/// CreatDate：    	2017-8-15
/// Description： 	根据麻醉方法ID字符串(多个ID以","拼接)，获取麻醉方法名称(多个名称以","拼接)
/// Table：        	DHCAN.AnaestMethod
/// Input:			anaMethodIdStr:麻醉方法ID字符串(多个ID以","拼接)
/// Return：       	麻醉方法名称字符串(多个名称以","拼接)
/// w ##class(CIS.AN.BL.OperSchedule).GetAnaestMethodDesc("")
ClassMethod GetAnaestMethodDesc(anaMethodIdStr As %String) As %String [ SqlProc ]
{
	set splitChar=",",result=""
	set anaMethodCount=$length(anaMethodIdStr,splitChar)
	for i=1:1:anaMethodCount
	{
		set anaMethodId=$piece(anaMethodIdStr,splitChar,i)
		continue:(##class(CT.AN.AnaMethod).%ExistsId(anaMethodId)=0)
		set anaMethod=##class(CT.AN.AnaMethod).%OpenId(anaMethodId)
		set:(result'="") result=result_splitChar
		set result=result_anaMethod.Description	
	}	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2017-8-15
/// Description： 	取消手术申请
/// Table：        	DHCAN.OperSchedule
/// Input:			data:手术申请数据
/// Return：       	取消成功返回"S^"，取消失败返回"E^原因"
/// w ##class(CIS.AN.BL.OperSchedule).CancelApplications("")
ClassMethod CancelApplications(data As %String) As %String
{
	tstart
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0
	set saveResult="E^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		m scheduleArray=array(objIndex)
		if ($get(scheduleArray("Status"))="")&($get(scheduleArray("StatusCode"))'="")
		{
			set scheduleArray("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(scheduleArray("StatusCode"))
		}
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(scheduleArray("RowId"))
		set statusCode="^"_operSchedule.Status.Code_"^"
		continue:(scheduleArray("OriginalStatusCode")'[statusCode)
		set scheduleArray("CancelDate")=+$h
		set scheduleArray("CancelTime")=$p($h,",",2)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.scheduleArray)
		quit:($piece(saveResult,"^",1)'="S")
	}	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	tcommit
	quit "S^"
}

ClassMethod CheckApplication(data As %String) As %String
{
	tstart
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		m scheduleArray=array(objIndex)
		if ($get(scheduleArray("Status"))="")&($get(scheduleArray("StatusCode"))'="")
		{
			set scheduleArray("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(scheduleArray("StatusCode"))
		}
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.scheduleArray)
		quit:($piece(saveResult,"^",1)'="S")
	}	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	tcommit
	quit "S^"
}

ClassMethod GetOPSIDByMedcareNo(medicareNo As %String) As %String
{
	set $zt="Error"
	quit:(medicareNo="") "E^住院号参数的值不能为空！"
	set patMasterID=$order(^PAPERi("Medicare1",medicareNo,0))
	quit:(##class(User.PAPatMas).%ExistsId(patMasterID)=0) "E^住院号对应的病人基本信息不存在！"	
	set maxIndex=+(^PAADM(0))+1
	set EpisodeID=$order(^PAPERdr(patMasterID,"ADM","I",maxIndex),-1)
	set maxIndex=+(^CIS.AN.OperScheduleD)+1
	set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,maxIndex),-1)
	quit opsId
Error
	quit "E^"_$ze
}

ClassMethod GetOPSIDByEpisodeID(EpisodeID As %String) As %String
{
	set $zt="Error"
	quit:(EpisodeID="") "E^住院号参数的值不能为空！"
	set maxIndex=+(^CIS.AN.OperScheduleD)+1
	set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,maxIndex),-1)
	quit opsId
Error
	quit "E^"_$ze
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-3
/// Description： 	查询当前入恢复室的病人列表
/// Table：        	CIS.AN.OperSchedule
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperSchedule","FindPACUList")
Query FindPACUList() As %Query(ROWSPEC = "InPACUSteward,InPACUStewardScore,InPACUStewardConscious,InPACUStewardRespiration,InPACUStewardMotion,OutPACUSteward,OutPACUStewardScore,OutPACUStewardConscious,OutPACUStewardRespiration,OutPACUStewardMotion,RowId,PatientID,MRAdmID,RegNo,MedcareNo,EpisodeID,ExtAnaestID,OperRoom,RoomDesc,RoomInfo,OperSeq,OperSeqInfo,PatName,PatGender,PatAge,Patient,AdmReason,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,WardBed,AppDeptID,AppDeptDesc,AppDeptAlias,OperDeptID,OperDeptDesc,PrevDiagnosis,PrevDiagnosisDesc,Operation,OperationDesc,BodySiteDesc,OperPosDesc,OperInfo,OperNote,Surgeon,SurgeonDesc,SurgeonShortDesc,Assistant,AssistantDesc,SurCareProv,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,OperDate,OperDateTime,AppDateTime,OperRequirementDesc,LabInfo,Status,OperStatusCode,OperStatusDesc,StatusColor,SourceType,SourceTypeDesc,IsoOperation,ECC,TransAutoblood,PrepareBlood,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRequirement,LabTest,OperTime,OperDuration,PrevAnaMethod,PrevAnaMethodDesc,ReentryOperation,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaCareProv,AnaStaff,ArrAnaExpert,ArrAnaExpertDesc,ArrAnaDoc,ArrAnaDocDesc,ArrAnaAss,ArrAnaAssDesc,ArrAnaStaff,AnaScheduleId,PatWeight,PatHeight,SurgicalMaterials,SpecialConditions,PlanSeq,OperStartDT,OperFinishDT,TheatreInDT,TheatreOutDT,Infection,InfectionLabData,ABO,RH,Antibiotic,LongOperation,PathResult,PreFasting,PreOperNote,TheatreOutTransLoc,AreaOutTransLoc,PACUBed,PACUInDT,PACUOutDT,PlanOperationDesc,ASAClass,ASAClassDesc,PreFastingDesc,PreMedication,OperPosition,OperPositionDesc,AnaestMethod,PlanOperInfo,AnaestMethodInfo,anPreVisit,anPostVisit,operPreVisit,operPostVisit,patPreShift,patPostShift,PACUBackShift,patPostFlup,Pneumothorax,Pneumoperitoneum,ECGDoctor") [ SqlProc ]
{
}

ClassMethod FindPACUListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+$h-1
	set endDateH=+$h
	
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:(operSchedule.TheatreOutTransLoc'="PACU") //仅此处判断，手术结束后转到位置为恢复室的手术
			
			
			set inPACUSteward="",score="",conscious="",respiration="",motion=""
			if (operSchedule.InPACUSteward'="")
			{
				set inPACUSteward = operSchedule.InPACUSteward.%Id()
				set score = operSchedule.InPACUSteward.Score
				set conscious = operSchedule.InPACUSteward.Conscious
				set respiration = operSchedule.InPACUSteward.Respiration
				set motion = operSchedule.InPACUSteward.Motion
			}
			set steward = $lb(inPACUSteward,score,conscious,respiration,motion)
			
			set outPACUSteward="",score="",conscious="",respiration="",motion=""
			if (operSchedule.OutPACUSteward'="")
			{
				set outPACUSteward = operSchedule.OutPACUSteward.%Id()
				set score = operSchedule.OutPACUSteward.Score
				set conscious = operSchedule.OutPACUSteward.Conscious
				set respiration = operSchedule.OutPACUSteward.Respiration
				set motion = operSchedule.OutPACUSteward.Motion
			}
			
			set steward = steward_$lb(outPACUSteward,score,conscious,respiration,motion)
			
			do OutputRow
		}	
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=steward_..GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod FindPACUListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPACUListExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindPACUListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPACUListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(CIS.AN.BL.OperSchedule).GetOperScheduleByMedNo("1820222")
ClassMethod GetOperScheduleByMedNo(medNo As %String) As %String
{
	set patMasID=$order(^PAPERi("Medicare1",medNo,0))
	quit:(##class(User.PAPatMas).%ExistsId(patMasID)=0) ""
	set validStatus="Arrange^RoomIn^RoomOut^PACU^Finish"
	set admType="",latelyOperSchedule=0
	for
	{
		set admType=$order(^PAPERdr(patMasID,"ADM",admType))
		quit:(admType="")
		set EpisodeID=0
		for
		{
			set EpisodeID=$order(^PAPERdr(patMasID,"ADM",admType,EpisodeID))	
			quit:(EpisodeID="")
			;b //ccq
			set opsId=0
			for
			{
				set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,opsId))
				quit:(opsId="")
				set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
				if (latelyOperSchedule<(+opsId) && (validStatus[operSchedule.Status.Code))
				{
					set latelyOperSchedule=opsId	
				}	
			}
		}	
	}
	quit latelyOperSchedule
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-19
/// Description： 	复制手术申请
/// Table：        	CIS.AN.OperSchedule
/// Input:			sourceOpsId:源手术申请ID
/// Return：       	复制成功返回"S^新手术申请ID",失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperSchedule).CopyOperSchedule("12432")
ClassMethod CopyOperSchedule(sourceOpsId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(sourceOpsId)=0) "E^原手术申请不存在。"
	set $zt="Error"
	tstart
	set sourceSchedule=##class(CIS.AN.OperSchedule).%OpenId(sourceOpsId)
	if (sourceSchedule.OriginalSchedule'="")
	{
		set sourceSchedule=sourceSchedule.OriginalSchedule	
	}
	set newSchedule=sourceSchedule.%ConstructClone()
	set newSchedule.OriginalSchedule=sourceSchedule
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set newSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId)
	if (sourceSchedule.OperRoom'=""){
		set lastOperSeq=+##class(CIS.AN.BL.OperArrange).GetLastSequence(sourceSchedule.OperDate,sourceSchedule.OperRoom.%Id(),.seqList)
		set newSchedule.OperSeq=lastOperSeq+1	
	}
	
	set sc=newSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set newScheduleId=newSchedule.%Id()
	
	set operListId=0,planOperListId=0,saveResult="S^"
	for
	{
		set operListId=$order(^CIS.AN.OperListI("OPS",sourceOpsId,operListId))
		quit:(operListId="")
		set operList=##class(CIS.AN.OperList).%OpenId(operListId)
		set newOperList=operList.%ConstructClone()
		set newOperList.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(newScheduleId)
		set sc=newOperList.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	for
	{
		set planOperListId=$order(^CIS.AN.PlanOperListI("OPS",sourceOpsId,planOperListId))
		quit:(planOperListId="")
		set planOperList=##class(CIS.AN.PlanOperList).%OpenId(planOperListId)
		set newPlanOperList=planOperList.%ConstructClone()
		set newPlanOperList.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(newScheduleId)
		set sc=newPlanOperList.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult
	}
	
	tcommit
	quit "S^"_newScheduleId
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetMedNoByOpsId(opsId As %String) As %String
{
	set opsInfo=..GetOperSchedule(opsId)
	quit $list(opsInfo,5)
}

/// w ##class(CIS.AN.BL.OperSchedule).GetOperNurseJSON("2019-04-16","","118")
ClassMethod GetOperNurseJSON(operDate As %String, filterDesc As %String, deptId As %String) As %String
{
	set careProvSet=##class(%ResultSet).%New("CIS.AN.COM.Admission:FindCareProvByLoc")
	set sc=careProvSet.Execute(filterDesc,deptId)
	set ret=##class(CIS.AN.COM.String).QueryToArray(.scheduleArr,"CIS.AN.BL.OperSchedule","FindOperScheduleList",operDate,operDate,deptId,"","","","Accept^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaIn^AreaOut")
	set arrangeInfo="",arrIndex=1
	kill careProvArr
	while (careProvSet.%Next())
	{
		set rowId=careProvSet.Get("RowId")
		set rowIdStr=","_rowId_","
		set description=careProvSet.Get("Description")
		set arrangeInfo="",count=0,scheduleInd=0,operRoomDesc=""
		set attendanceInfo=##class(CIS.AN.BL.Attendance).GetAttendanceForCareProv(operDate,deptId,rowId)
		set:(attendanceInfo'="") arrangeInfo=$p(attendanceInfo,"^",2)
		for
		{
			set scheduleInd=$o(scheduleArr(scheduleInd))
			quit:(scheduleInd="")
			set scrubNurse=","_scheduleArr(scheduleInd,"ScrubNurse")_","
			set circualNurse=","_scheduleArr(scheduleInd,"CircualNurse")_","
			set operRoomDesc=scheduleArr(scheduleInd,"RoomDesc")
			if (scrubNurse [ rowIdStr)!(circualNurse [ rowIdStr)
			{
				set:(arrangeInfo'="")&(arrangeInfo '[ operRoomDesc) arrangeInfo=arrangeInfo_","
				set:(arrangeInfo '[ operRoomDesc) arrangeInfo=arrangeInfo_operRoomDesc
				set count=count+1	
			}	
		}
		set arrangeFlag=arrangeInfo
		if (attendanceInfo'="")
		{
			
			set arrangeFlag=$p(attendanceInfo,"^",1)_$p(attendanceInfo,"^",2)	
			b //ccq2
		}
		set:(arrangeFlag="") arrangeFlag="00未排人员"
		
		set careProvArr(arrangeFlag,arrIndex,"RowId")=rowId
		set careProvArr(arrangeFlag,arrIndex,"Description")=description
		set careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")=arrangeInfo
		set:(arrangeInfo="") careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")="未排人员"
		set:(count>0) arrangeInfo=arrangeInfo_" 共"_count_"台。"
		set careProvArr(arrangeFlag,arrIndex,"ArrangeInfo")=arrangeInfo
		set careProvArr(arrangeFlag,arrIndex,"AttendanceInfo")=$p(attendanceInfo,"^",2)
		set arrIndex=arrIndex+1
	}
	b //ccq
	set arrangeFlag="",arrIndex=0,retIndex=1
	k retArr
	for
	{
		set arrangeFlag=$o(careProvArr(arrangeFlag))
		quit:(arrangeFlag="")
		for
		{
			set arrIndex=$o(careProvArr(arrangeFlag,arrIndex))
			quit:(arrIndex="")	
			set retArr(retIndex,"RowId")=careProvArr(arrangeFlag,arrIndex,"RowId")
			set retArr(retIndex,"Description")=careProvArr(arrangeFlag,arrIndex,"Description")
			set retArr(retIndex,"ArrangeFlag")=careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")
			set retArr(retIndex,"ArrangeInfo")=careProvArr(arrangeFlag,arrIndex,"ArrangeInfo")
			set retArr(retIndex,"AttendanceInfo")=careProvArr(arrangeFlag,arrIndex,"AttendanceInfo")
			set retIndex=retIndex+1
		}
		
			
	}

	set result=##class(CIS.AN.COM.String).ToJson(.retArr)
	quit result
}

/// 获取患者体检信息，身高^体重^BMI指数^血型^RH血型
/// w ##class(CIS.AN.BL.OperSchedule).GetMedExamination("1893")
ClassMethod GetMedExamination(EpisodeID As %String) As %String
{
	set patWeight=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"weight")
	set patHeight=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"height")
	set BMI=""
	set ABO=##class(web.DHCClinicCom).GetLatestTestResult(EpisodeID,"ABO")
	set ABO=$p($p(ABO,"^",1),"\",1)
	set RH=##class(web.DHCClinicCom).GetLatestTestResult(EpisodeID,"RH")
	set RH=$p($p(RH,"^",1),"\",1)
	quit patWeight_"^"_patHeight_"^"_BMI_"^"_ABO_"^"_RH
}

Query FindLastOPSByAdm(EpisodeID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT Top 1 RowId from CIS_AN.OperSchedule
where EpisodeID=:EpisodeID
and ('^RoomIn^RoomOut^PACUIn^Finish^' [ ('^'_(Status->Code)_'^'))
order by OperDate desc,OperTime desc
}

}
