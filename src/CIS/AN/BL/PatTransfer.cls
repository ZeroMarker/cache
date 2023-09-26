Class CIS.AN.BL.PatTransfer Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PatTransfer","FindOperScheduleList","2021-10-20","2021-10-20","298","2007","","","Arrange^RoomIn^RoomOut^PACU^Finish","","")
Query FindOperScheduleList(startDate As %String = "", endDate As %String = "", userDeptID As %String, opsId As %String = "", appDeptID As %String = "", patWardID As %String = "", operStatusID As %String = "", operRoomID As %String = "", regNo As %String = "", medcareNo As %String = "", byAppDate = "N", isDaySurgery As %String = "", isOutOper As %String = "", EMStatusID As %String = "") As %Query(ROWSPEC = "RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,PlanSecAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,SecAsstDesc,BodySite,OperClassDesc,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion,LaborStartDT,LaborEndDT,LaborEndTransLoc,LaborEndTransLocDesc,StatCategory,StatCategoryDesc,StatSeq,SiteDepth,Endoscopy,ArrAnaNurse,ArrAnaNurseDesc,AnaNurse,AnaNurseDesc,AdmType,AdmTypeDesc,DrugAllergy,DrugAllergyNote,AppDocPhoneNo,Operation,EstimatedOperTime,ArrPrintFlag,Surgeon,PlanSurgeon,Hydrothorax") [ SqlProc ]
{
}

ClassMethod FindOperScheduleListExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", userDeptID As %String, opsId As %String = "", appDeptID As %String = "", patWardID As %String = "", operStatusID As %String = "", operRoomID As %String = "", regNo As %String = "", medcareNo As %String = "", byAppDate = "N", isDaySurgery As %String = "", isOutOper As %String = "", EMStatusID As %String = "") As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=1)
	{
		do OutputRow
		s qHandle=$lb(0,repid,0)
		q $$$OK		
	}
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	Set:startDateH="" startDateH=+$H
	Set:endDateH="" endDateH=+$H
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	set:(byAppDate="Y") indexNode="AppDate"
	set linkDeptStr=##class(CIS.AN.BL.Admission).GetLinkLocId(userDeptID)
	//	set EMStatusID=##class(CIS.AN.BL.AnaArrange).GetEMStatusCodeList()   //启用审核急诊手术配置时,可查询的急诊手术状态代码 YuanLin 20200515
	if (linkDeptStr="")
	{
		set linkDeptStr=userDeptID	
	}
	else
	{
		set linkDeptStr=linkDeptStr_"^"_userDeptID
	}
	
	
	kill operScheduleList
	set job=$j
	kill ^TMPOPS(job)
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set sourceType=operSchedule.SourceType
			//set operAppDeptId=operSchedule.AppDeptID.ExternalID
			set operAppDeptId=operSchedule.AppDeptID	//operSchedule.AppDeptID.%Id()
			//set operDeptId=operSchedule.OperDeptID.ExternalID
			set operDeptId=operSchedule.OperDeptID //operSchedule.OperDeptID.%Id()
			continue:operDeptId=""
			set anaDeptId=operSchedule.AnaDept
			//set:($isobject(operSchedule.AnaDept)) anaDeptId=operSchedule.AnaDept.%Id()
			set OperExecDeptID=operSchedule.OperExecDeptID	//日间预住院科室
			set hospId1=$p($g(^CTLOC(operAppDeptId)),"^",22)
			set hospId2=$p($g(^CTLOC(operDeptId)),"^",22)
			continue:(hospId1'=hospId2)	//申请科室所在院区要与手术室院区保持一致
			
			set tmpDaySurgery=operSchedule.DaySurgery	;202003+dyl
			s dayLocStr="",linkDayStr=""
			;20200314+dyl日间手术不止登录科室起作用，与之相关联的科室也起作用
			i tmpDaySurgery="Y" s linkDayStr=operSchedule.OperExecDeptID
			//s linkDayStr=##class(CIS.AN.BL.DaySurgery).GetOutInLinkID(userDeptID)
			s linkDayStr=linkDeptStr_"^"_linkDayStr
			set flagAppLocSee=(("^"_linkDayStr_"^")'[("^"_operAppDeptId_"^"))
			set flagOpLocSee=(("^"_linkDayStr_"^")'[("^"_operDeptId_"^"))
			set flagAnLocSee=(("^"_linkDayStr_"^")'[("^"_anaDeptId_"^"))
			set flagPreLocSee=(("^"_linkDeptStr_"^")'[("^"_OperExecDeptID_"^"))
			set hospId3=$p($g(^CTLOC(userDeptID)),"^",22)
			continue:(hospId2'=hospId3)
			continue:flagAppLocSee&flagPreLocSee&flagOpLocSee&flagAnLocSee&(userDeptID'="")
			
			s linkAppStr=""
			i tmpDaySurgery="Y" s linkAppStr=OperExecDeptID
			s linkAppStr=appDeptID_"^"_linkAppStr
			;20200314+dyl日间手术不止申请科室起作用，与之相关联的科室也起作用
			s showOperFlag=(("^"_appDeptID_"^")'[("^"_operAppDeptId_"^"))
			s showPreOperFlag=(("^"_appDeptID_"^")'[("^"_OperExecDeptID_"^"))
			continue:(appDeptID'="")&showOperFlag&showPreOperFlag
			;(("^"_linkAppStr_"^")'[("^"_operSchedule.AppDeptID_"^"))
			
			;continue:(appDeptID'="")&(appDeptID'=operSchedule.AppDeptID.%Id())
			continue:(patWardID'="")&(patWardID'=operSchedule.PatWardID)
			
			continue:(isDaySurgery="Y")&(tmpDaySurgery'=isDaySurgery)
			;continue:(isDaySurgery="")&(tmpDaySurgery="Y")
			;continue:(isDaySurgery="N")&(tmpDaySurgery="Y")
			set tmpOutOper=operSchedule.OPAdmType	;202003+dyl
			continue:(isOutOper="Y")&(tmpOutOper'="OOP")
			continue:(isOutOper="")&(tmpOutOper="OOP")
			continue:(isOutOper="N")&(tmpOutOper="OOP")
			
			if (operSchedule.Status'="")
			{
				set StatusID=operSchedule.Status.%Id()
				set StatusCode=operSchedule.Status.Code
			}
			continue:(##class(CT.AN.OperStatus).%ExistsId(operStatusID))&(operStatusID'=StatusID)
			;continue:("Decline^Cancel^Revoke^Stop"[StatusCode)&(operStatusID="")
			continue:(StatusCode="Cancel")&((userDeptID=operDeptId)!(userDeptID=anaDeptId))
			;b //ccq
			continue:(operSchedule.SourceType'="E")&(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'[StatusCode)
			continue:(operSchedule.SourceType="E")&(EMStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(EMStatusID)=0)&(EMStatusID'[StatusCode)&(tmpOutOper'="OOP")
			
			//continue:(operSchedule.SourceType="E")&(EMStatusID="")&(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'[StatusCode)
			//continue:(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'[StatusCode)
			set curOperRoomID="",curOperRoomDesc=""
			if (operSchedule.OperRoom'="")
			{
				set curOperRoomID=operSchedule.OperRoom.%Id()	
				set curOperRoomDesc=operSchedule.OperRoom.Description
			}
			continue:(operRoomID'="")&(operRoomID'=curOperRoomID)
			set thisRegNo=##class(CIS.AN.BL.Admission).GetRegNobyEpisodeID(operSchedule.EpisodeID)
			continue:(+regNo'=0)&(+thisRegNo'=+regNo)
			
			set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",operSchedule.EpisodeID)
	        set PatName=patInfoObj.GetValue("PatName")
			
	        continue:(regNo'="")&(+regNo=0)&(PatName'[regNo)
			set thisMedCareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",operSchedule.EpisodeID)
			continue:(medcareNo'="")&(medcareNo'=thisMedCareNo)
			set roomNode=curOperRoomDesc
			set:(roomNode="") roomNode="第99间"
			set operSeqNode=+operSchedule.OperSeq
			set:(operSeqNode=0) operSeqNode=99
			set ^TMPOPS(job,operSchedule.OperDate,roomNode,operSeqNode,+opsId)=""
			do OutputRow
			
		}	
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=..GetOperSchedule(opsId)
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

/// w ##class(CIS.AN.BL.OperScheduleList).GetOperSchedule(4)
ClassMethod GetOperSchedule(opsId As %String) As %List
{
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    
    // 获取患者信息
    set EpisodeID=operSchedule.EpisodeID
    set ExtAnaestID=operSchedule.ExtAnaestID
    set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
    set PatName=patInfoObj.GetValue("PatName")
    set PatGender=patInfoObj.GetValue("PatGender")
    set PatAge=patInfoObj.GetValue("PatAge")
    set PatDOB=patInfoObj.GetValue("PatDOB")
    set RegNo=patInfoObj.GetValue("RegNo")
    set MedcareNo=patInfoObj.GetValue("MedcareNo")  
    set PatientID=patInfoObj.GetValue("PatientID")
    set MRAdmID=patInfoObj.GetValue("MRAdmID")
    set AdmReason=patInfoObj.GetValue("AdmReason")
    set PatCardID=patInfoObj.GetValue("CardID")
    set AdmDateH=patInfoObj.GetValue("AdmDateH")
    set AdmType=patInfoObj.GetValue("AdmType")
    if (AdmType="I")
    {
		set AdmTypeDesc="住院"    
	}
	if (AdmType="O")
	{
		set AdmTypeDesc="门诊"	
	}
    set Patient=PatName_(PatGender_" "_PatAge)          // 患者基本信息，格式为：张三(男 30岁)
    set PreopAdmDays=operSchedule.OperDate-AdmDateH     // 术前住院日
    
    // 手术申请信息
    set AppCareProvID=operSchedule.AppCareProvID        // 手术申请医护人员ID
    set AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
    set PatDeptID=operSchedule.PatDeptID
    set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
    set PatWardID=operSchedule.PatWardID
    set PatWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",operSchedule.PatWardID)
    
    set PatBedID=operSchedule.PatBedID  
    set PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
    set:(PatBedCode="") PatBedCode=operSchedule.PatBedID                // 一般HIS为第三方系统时，将床位代码直接存入PatBedID字段
    
    set WardBed=PatWardDesc_" "_PatBedCode
    
    set AppDeptID=operSchedule.AppDeptID                // 手术申请科室
    set AppDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
    
    set OperDeptID=operSchedule.OperDeptID              // 手术室
    set OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
    
    set AnaDept=operSchedule.AnaDept                    // 麻醉科室
    set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
    
        //20200628
        set OperExecDeptID=operSchedule.OperExecDeptID              // 日间预住院科室
    set OperExecDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperExecDeptID)

    set AppUserID=operSchedule.AppUserID
    
    // 麻醉科
    set AnaDept=operSchedule.AnaDept
    set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
    
    set SourceType=operSchedule.SourceType              // 手术类型
    set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
    
    set Status=operSchedule.Status.%Id()                // 手术状态ID
    set StatusDesc=operSchedule.Status.Description      // 手术状态名称
    set StatusColor=operSchedule.Status.BGColor         // 手术状态背景颜色
    set StatusCode=operSchedule.Status.Code             // 手术状态代码
    
    set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")           // 手术日期(计划)
    //set DateFormat=$lg(^websys.ConfigurationD(1),10)
    //if ((DateFormat="DMY")&&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
    set OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")           // 手术开始时间(计划)
    
    set OperDuration=operSchedule.OperDuration          // 手术持续时长(计划)
    set ReentryOperation=operSchedule.ReentryOperation  // 非计划重返手术
    set ReentryOperationDesc=##class(CIS.AN.OperSchedule).ReentryOperationLogicalToDisplay(operSchedule.ReentryOperation)
    set DaySurgery=operSchedule.DaySurgery  // 202002+dyl+日间手术
    set OPAdmType=operSchedule.OPAdmType    //202003+dyl+门诊手术
    set ComeHosTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.ComeHosTime,"")
    set PatPhoneNumber=operSchedule.PatPhoneNumber  //202003+dyl+门诊手术
    set PatNeedNotice=operSchedule.PatNeedNotice    //202003+dyl+门诊手术
    
    set Anaesthesia=operSchedule.Anaesthesia            // 是否麻醉科参与麻醉
    set AnaesthesiaDesc=##class(CIS.AN.OperSchedule).AnaesthesiaLogicalToDisplay(operSchedule.Anaesthesia)
    set PrevAnaMethod=operSchedule.PrevAnaMethod        // 拟施麻醉方法
    set PrevAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",operSchedule.PrevAnaMethod,"+","Y")
    set Hydrothorax=operSchedule.Hydrothorax
    ;b ;PrevAnaMethod
    set PlanSeq=operSchedule.PlanSeq                    // 计划台次
    set SeqType=operSchedule.SeqType                    // 台次类型(正常台，连台)
    set SeqTypeDesc=##class(CIS.AN.OperSchedule).SeqTypeLogicalToDisplay(operSchedule.SeqType)
    
    set PrevDiagnosis=$tr(operSchedule.PrevDiagnosis,$c(4),"")      // 术前诊断
    //set PrevDiagnosisDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDDesc",PrevDiagnosis,",","Y")        // 术前诊断描述
    set PrevDiagnosisDesc=..GetDiagnosisDesc(PrevDiagnosis)     // 术前诊断描述
    set:(PrevDiagnosisDesc="") PrevDiagnosisDesc=PrevDiagnosis
    if (PrevDiagnosis="")
    {
        set DiagnosisObj=##class(web.DHCANOPArrange).GetMainDiagnos(EpisodeID)
        set PrevDiagnosis=$p(DiagnosisObj,"!",2)
    }
    set PostDiagnosis=operSchedule.PostDiagnosis        // 术后诊断
    //set PostDiagnosisDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDDesc",PostDiagnosis,",","Y")
    set PostDiagnosisDesc=..GetDiagnosisDesc(PostDiagnosis)
    set planOperDataStr=..GetPlanOperList(opsId,.planOperData)     // 拟施手术
    set PlanOperDesc=planOperData(1,"OperationDesc")            // 拟施手术名称
    set:(PlanOperDesc="") PlanOperDesc=planOperData(1,"Operation")
    set PlanOperNote=planOperData(1,"OperNote")                 // 拟施手术名称备注
    set:(PlanOperDesc="") PlanOperDesc=PlanOperNote
    set PlanSurgeonDesc=planOperData(1,"SurgeonDesc")           // 拟施手术医生姓名
    set PlanSurgeon=planOperData(1,"Surgeon")					// 拟施手术医生Id
    set PlanAsstDesc=planOperData(1,"AssistantDesc")            // 拟施手术助手姓名
    Set PlanFirstAsstDesc=$p(PlanAsstDesc,",",1)                // 拟施手术一助姓名
    Set PlanSecAsstDesc=$p(PlanAsstDesc,",",2)                	// 拟施手术二助姓名
    set PlanSurgeonExpert=planOperData(1,"SurgeonExpert")       // 拟施手术专家主刀
    
    set operInfo=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
    set BodySite="",BodySiteDesc="",OperClassDesc=""
    for i=1:1:operInfo.Size
    {
        set operObj=operInfo.GetAt(i)
        set bodysite=operObj.GetValue("BodySite")
        set:(BodySite'="") BodySite=BodySite_","
        set BodySite=BodySite_bodysite                          // 手术部位
        set bodysitedesc=operObj.GetValue("BodySiteDesc")
        set:(BodySiteDesc'="") BodySiteDesc=BodySiteDesc_","
        set BodySiteDesc=BodySiteDesc_bodysitedesc              // 手术部位名称
        set OperClassDesc=operObj.GetValue("OperClassDesc")
    }
    set OperPosition=operSchedule.OperPosition                  // 手术体位
    Set OperPositionDesc=..GetOperPosDesc(OperPosition)         // 手术体位名称
    set BladeType=operSchedule.BladeType
    set BladeTypeDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCBladeType","BLDTPDesc",BladeType)
    set SurIntership=operSchedule.SurIntership                  // 实习进修人员
    set SurVisitors=operSchedule.SurVisitors                    // 手术参观人员
    set operData=..GetOperList(opsId,.operData)                 // 实施手术
    set OperDesc=operData(1,"OperationDesc")                    // 实施手术名称
    set:(OperDesc="") OperDesc=operData(1,"Operation")
    set Operation=operData(1,"Operation")
    set OperNote=operData(1,"OperNote")                         // 实施手术名称备注
    set:(OperDesc="") OperDesc=OperNote
    ///YGB 只取第一条手术
    if ($L(OperDesc,"+")>1)
    {
	    set OperDesc=$P(OperDesc,"+")
	}
    set SurgeonDesc=operData(1,"SurgeonDesc")                   // 实施手术医生姓名
    set Surgeon=operData(1,"Surgeon")							// 实施手术医生Id
     if ($L(Surgeon,",")>1)
    {
	    set Surgeon=$P(Surgeon,",")
	}
    set AsstDesc=operData(1,"AssistantDesc")                    // 实施手术助手姓名
    Set FirstAsstDesc=$p(AsstDesc,",",1)                        // 实施手术一助姓名
    set SecAsstDesc=$p(AsstDesc,",",2)							// 实施手术二助姓名
    set SurgeonExpert=operData(1,"SurgeonExpert")               // 实施手术专家主刀
    set SurCareProv=SurgeonDesc
    set:AsstDesc'="" SurCareProv=SurgeonDesc_","_AsstDesc
    
    set SurgicalMaterials=operSchedule.SurgicalMaterials        // 手术要求  仪器器械
    set SpecialCondition=operSchedule.SpecialConditions         // 特殊情况
    set HighConsume=operSchedule.HighConsume                    // 高值耗材
    set IsoOperation=operSchedule.IsoOperation                  // 隔离手术
    set IsoOperationDesc=##class(CIS.AN.OperSchedule).IsoOperationLogicalToDisplay(operSchedule.IsoOperation)
    set ECC=operSchedule.ECC                                    // 体外循环
    set ECCDesc=##class(CIS.AN.OperSchedule).ECCLogicalToDisplay(operSchedule.ECC)
    set TransAutoBlood=operSchedule.TransAutoblood              // 自体血回输
    //set TransAutoBloodDesc=""
    set TransAutoBloodDesc=##class(CIS.AN.OperSchedule).TransAutobloodLogicalToDisplay(operSchedule.TransAutoblood)
    set PrepareBlood=operSchedule.PrepareBlood                  // 是否备血
    set PrepareBloodDesc=##class(CIS.AN.OperSchedule).PrepareBloodLogicalToDisplay(operSchedule.PrepareBlood)
    set OperRequirement=operSchedule.OperRequirement
    set InfectionOper=operSchedule.InfectionOper                // 感染手术
    //set InfectionOperDesc=##class(CIS.AN.OperSchedule).InfectionOperLogicalToDisplay(operSchedule.InfectionOper)
	set InfectionOperDesc=$CASE(InfectionOper,"Y":"是","N":"否",:"")
	set Antibiosis=operSchedule.Antibiosis
	set AntibiosisDesc=$CASE(Antibiosis,"Y":"是","N":"否",:"")
	set:((OperRequirement["感染手术")&&(InfectionOperDesc="")) InfectionOperDesc="是"
	set:((OperRequirement["使用抗菌药物")&&(AntibiosisDesc="")) AntibiosisDesc="是"
    set MIS=operSchedule.MIS                                    // 微创手术
    //set MISDesc=##class(CIS.AN.OperSchedule).MISLogicalToDisplay(operSchedule.MIS)
    set MISDesc=$CASE(MIS,"Y":"是","N":"否",:"")
    set Antibiosis=operSchedule.Antibiosis                      // 使用抗生素
    set AntibiosisDesc=##class(CIS.AN.OperSchedule).AntibiosisLogicalToDisplay(operSchedule.Antibiosis)
    set OperRequirement=..GetOperRequirement(opsId)             // 手术要求信息
    
    set BloodType=operSchedule.BloodType                        // 检验信息 ABO血型
    set BloodTypeDesc=##class(CIS.AN.OperSchedule).BloodTypeLogicalToDisplay(operSchedule.BloodType)
    set RHType=operSchedule.RHBloodType                         // RH血型
    set RHBloodTypeDesc=##class(CIS.AN.OperSchedule).RHBloodTypeLogicalToDisplay(operSchedule.RHBloodType)
    set HbsAg=operSchedule.HbsAg                                // 乙肝表面抗原
    set HbsAgDesc=##class(CIS.AN.OperSchedule).HbsAgLogicalToDisplay(operSchedule.HbsAg)
    set HcvAb=operSchedule.HcvAb                                // 丙肝抗体
    set HcvAbDesc=##class(CIS.AN.OperSchedule).HcvAbLogicalToDisplay(operSchedule.HcvAb)
    set HivAb=operSchedule.HivAb                                // 艾滋病抗体
    set HivAbDesc=##class(CIS.AN.OperSchedule).HivAbLogicalToDisplay(operSchedule.HivAb)
    set Syphilis=operSchedule.Syphilis                          // 梅毒
    set SyphilisDesc=##class(CIS.AN.OperSchedule).SyphilisLogicalToDisplay(operSchedule.Syphilis)
    
    // 手术排班信息
    set OperRoom="",RoomDesc="",RoomCode=""                     // 手术间
    if (operSchedule.OperRoom'="")
    {
        set OperRoom=operSchedule.OperRoom.%Id()                // 手术间ID
        set RoomDesc=operSchedule.OperRoom.Description          // 手术间名称
        set RoomCode=operSchedule.OperRoom.Code                 // 手术间代码
    }
    set OperSeq=operSchedule.OperSeq                            // 手术台次
    set ScrubNurse=operSchedule.ScrubNurse                      // 器械护士，多个护士以","拼接
    set ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurse)     // 器械护士姓名
    set FirstScrubNurse=$p(ScrubNurse,",",1),FirstScrubNurseDesc=$p(ScrubNurseDesc,",",1)
    set SecScrubNurse=$p(ScrubNurse,",",2),SecScrubNurseDesc=$p(ScrubNurseDesc,",",2)
    set CircualNurse=operSchedule.CircualNurse                  // 巡回护士，多个护士以","拼接
    set CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualNurse) // 巡回护士姓名
    set FirstCircualNurse=$p(CircualNurse,",",1),FirstCircualNurseDesc=$p(CircualNurseDesc,",",1)
    set SecCircualNurse=$p(CircualNurse,",",2),SecCircualNurseDesc=$p(CircualNurseDesc,",",2)
    set InternshipNurse=""  //operSchedule.InternshipNurse          // 实习护士

    // 麻醉信息
    set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
    set TheatreInDT=anaestObj.GetValue("TheatreInDT")           // 入手术间时间
    set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")         // 离手术间时间
    
    //if TheatreInDT="" set TheatreInDT=operSchedule.TheatreInDT        // 术后登记中的入手术间时间
    //if TheatreOutDT="" set TheatreOutDT=operSchedule.TheatreOutDT   // 术后登记中的离手术间时间
    
    set OperStartDT=anaestObj.GetValue("OperStartDT")           // 手术开始时间
    set OperFinishDT=anaestObj.GetValue("OperFinishDT")         // 手术结束时间
    set AnaStartDT=anaestObj.GetValue("AnaStartDT")             // 麻醉开始时间
    set AnaFinishDT=anaestObj.GetValue("AnaFinishDT")           // 麻醉结束时间
    set TubeInDT=anaestObj.GetValue("TubeInDT")                 // 插管时间
    set TubeOutDT=anaestObj.GetValue("TubeOutDT")               // 拔管时间
    set AreaInDT=anaestObj.GetValue("AreaInDT")                 // 入手术室时间
    set AreaOutDT=anaestObj.GetValue("AreaOutDT")               // 离手术室时间
    set ECGDoctor=anaestObj.GetValue("ECGDoctor")               // 心电监护医生
    
    set TheatreInTime=""
    set AnestStartTime=""
    set OperStartTime=""
    set OperEndTime=""
    set AnestEndTime=""
    set TheatreOutTime=""
    
    set operStatusCode=""
    set:operSchedule.Status'="" operStatusCode=operSchedule.Status.Code
    if (operStatusCode'="RoomIn")
    {
        set TheatreInTime=$p(TheatreInDT," ",2)
        set AnestStartTime=$p(AnaStartDT," ",2)
        set OperStartTime=$p(OperStartDT," ",2)
        set OperEndTime=$p(OperFinishDT," ",2)
        set AnestEndTime=$p(AnaFinishDT," ",2)
        set TheatreOutTime=$p(TheatreOutDT," ",2)
    }
    else
    {
        kill keyTimeList
        do ..GetKeyTimeFromAnaData(opsId,.keyTimeList)
        set TheatreInTime=$p($g(keyTimeList("TheatreInTime"))," ",2)
        set AnestStartTime=$p($g(keyTimeList("AnestStartTime"))," ",2)
        set OperStartTime=$p($g(keyTimeList("OperStartTime"))," ",2)
        set OperEndTime=$p($g(keyTimeList("OperEndTime"))," ",2)
        set AnestEndTime=$p($g(keyTimeList("AnestEndTime"))," ",2)
        set TheatreOutTime=$p($g(keyTimeList("TheatreOutTime"))," ",2)
    }
    
    //if AreaInDT="" set AreaInDT=operSchedule.AreaInDT         // 术后登记中的入手术室时间
    //if AreaOutDT="" set AreaOutDT=operSchedule.AreaOutDT        // 术后登记中的离手术室时间
    
    set PACUInDT=anaestObj.GetValue("PACUInDT")                 // 入PACU时间
    set PACUOutDT=anaestObj.GetValue("PACUOutDT")               // 离PACU时间
    set PACUInTime=$p(PACUInDT," ",2)
    set PACUOutTime=$p(PACUOutDT," ",2)
    
    set OperDateTime=OperStartDT                                // 手术开始时间
    set:(OperDateTime="") OperDateTime=OperDate_" "_OperTime
    set PACUDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(PACUInDT,PACUOutDT,"H")
    set ROperDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(OperStartDT,OperFinishDT,"H")
    set WaitDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(TheatreInDT,AnaStartDT,"M")    
    set AnaestID=anaestObj.GetValue("RowId")                    // 麻醉申请ID
    set AnaMethod=anaestObj.GetValue("AnaMethod")               // 麻醉方法ID
    set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)   // 麻醉方法名称
    set ArrAnaMethod=anaestObj.GetValue("ArrAnaMethod")             // 排班麻醉方法ID
    if (ArrAnaMethod="") set ArrAnaMethod=AnaMethod
    set ArrAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",ArrAnaMethod) // 麻醉方法名称

    set AnaExpert=anaestObj.GetValue("AnaExpert")               // 麻醉指导
    set AnaExpertDesc=anaestObj.GetValue("AnaExpertDesc")       // 麻醉指导姓名
    set:(AnaExpert'="")&&(AnaExpertDesc="") AnaExpertDesc=AnaExpert
    set ArrAnaExpert=anaestObj.GetValue("ArrAnaExpert")             // 排班麻醉指导
    set ArrAnaExpertDesc=anaestObj.GetValue("ArrAnaExpertDesc")     // 排班麻醉指导姓名
    set:(ArrAnaExpert'="")&&(ArrAnaExpertDesc="") ArrAnaExpertDesc=ArrAnaExpert

    set Anesthesiologist=anaestObj.GetValue("Anesthesiologist") // 麻醉医生
    set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")     // 麻醉医生姓名
    set:(Anesthesiologist'="")&&(AnesthesiologistDesc="") AnesthesiologistDesc=Anesthesiologist
    set ArrAnesthesiologist=anaestObj.GetValue("ArrAnesthesiologist")   // 排班麻醉医生
    set ArrAnesthesiologistDesc=anaestObj.GetValue("ArrAnesthesiologistDesc")       // 排班麻醉医生姓名
    set:(ArrAnesthesiologist'="")&&(ArrAnesthesiologistDesc="") ArrAnesthesiologistDesc=ArrAnesthesiologist
    set AnaAssistant=anaestObj.GetValue("AnaAssistant")         // 麻醉助手
    set AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaAssistant)     // 麻醉助手姓名
    set ArrAnaAssistant=anaestObj.GetValue("ArrAnaAssistant")           // 排班麻醉助手
    set ArrAnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrAnaAssistant)       // 排班麻醉助手姓名
    set AnaStaff=anaestObj.GetValue("AnaStaff")                 // 实习进修
    set ArrAnaStaff=anaestObj.GetValue("ArrAnaStaff")                   // 排班实习进修
    set ASAClass=anaestObj.GetValue("ASAClass")                 // ASA分级
    set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")         // ASA分级描述
    set PreOperNote=anaestObj.GetValue("PreOperNote")           // 术前特殊情况
    set PreMedication=anaestObj.GetValue("PreMedication")       // 术前用药
    set PreFasting=anaestObj.GetValue("PreFasting")             // 术前禁食
    set PreFastingDesc=anaestObj.GetValue("PreFastingDesc")     // 术前禁食
    set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc")     // 离手术间去向代码
    set TheatreOutTransLocDesc=anaestObj.GetValue("TheatreOutTransLocDesc")     // 离手术间去向名称
    set LaborStartDT=anaestObj.GetValue("LaborStartDT")             // 无痛分娩开始监护时间
    set LaborEndDT=anaestObj.GetValue("LaborEndDT")                 // 无痛分娩结束监护时间
    set LaborEndTransLoc=anaestObj.GetValue("LaborEndTransLoc")     // 无痛分娩结束监护去向代码
    set LaborEndTransLocDesc=anaestObj.GetValue("LaborEndTransLocDesc")     // 无痛分娩结束监护去向名称
    
    set careprovlist=""
    set:AnesthesiologistDesc'="" careprovlist=careprovlist_$lb(AnesthesiologistDesc)
    set:AnaExpertDesc'="" careprovlist=careprovlist_$lb(AnaExpertDesc)
    set:AnaAssistantDesc'="" careprovlist=careprovlist_$lb(AnaAssistantDesc)
    set:AnaStaff'="" careprovlist=careprovlist_$lb(AnaStaff)
    set AnaCareProv=$ListToString(careprovlist,",")
    set AnaCareProv=##class(CIS.AN.BL.OperShift).CompleteCareProv(opsId,"A",AnaCareProv)
    
    set MainAnaesthesia=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
    set AppDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)   // 手术申请日期时间
    
    set PatHeight=operSchedule.PatHeight
    set PatWeight=operSchedule.PatWeight
    set AnaestMethod=anaestObj.GetValue("AnaMethod")   ;..GetAnaestMethod(opsId)
    
    set opaId=operSchedule.ExternalID

    // 获取排班信息
    set ArrOperRoom="",ArrRoomCode="",ArrRoomDesc="",ArrOperSeq="",ArrScrubNurse="",ArrScrubNurseDesc="",ArrCircualNurse="",ArrCircualNurseDesc="",ArrOperTime=""
    set:($IsObject(operSchedule.ArrOperRoom)) ArrOperRoom=operSchedule.ArrOperRoom.%Id(),ArrRoomDesc=operSchedule.ArrOperRoom.Description,ArrRoomCode=operSchedule.ArrOperRoom.Code
    set ArrOperSeq=operSchedule.ArrOperSeq
    set ArrScrubNurse=operSchedule.ArrScrubNurse
    set ArrOperTime=operSchedule.ArrOperTime
    set:(ArrOperTime'[":")&&(ArrOperTime'="") ArrOperTime=$zt(ArrOperTime,2)
    set ArrScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrScrubNurse)
    set ArrCircualNurse=operSchedule.ArrCircualNurse
    set ArrCircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrCircualNurse)
    set ArrFirstScrubNurse=$p(ArrScrubNurse,",",1),ArrFirstScrubNurseDesc=$p(ArrScrubNurseDesc,",",1)
    set ArrSecScrubNurse=$p(ArrScrubNurse,",",2),ArrSecScrubNurseDesc=$p(ArrScrubNurseDesc,",",2)
    set ArrFirstCircualNurse=$p(ArrCircualNurse,",",1),ArrFirstCircualNurseDesc=$p(ArrCircualNurseDesc,",",1)
    set ArrSecCircualNurse=$p(ArrCircualNurse,",",2),ArrSecCircualNurseDesc=$p(ArrCircualNurseDesc,",",2)
    set ArrAnaNurse=anaestObj.GetValue("ArrAnaNurse")
    set ArrAnaNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrAnaNurse)
    set AnaNurse=anaestObj.GetValue("AnaNurse")
    set AnaNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaNurse)
    
    
    set MDROS=operSchedule.MDROS        // 多重耐药菌
    set MDROSDesc=$CASE(MDROS,"N":"未知","-":"阴性","+":"阳性",:"")
    //b ;3
    set PACUBed="",PACUBedDesc=""
    set:operSchedule.PACUBed'="" PACUBed=operSchedule.PACUBed.%Id(),PACUBedDesc=operSchedule.PACUBed.Description
    
    set OPFeeFlag=operSchedule.OPFeeFlag        // 手术费用审核标志
    set OPFeeFlagDesc=$CASE(OPFeeFlag,"N":"否","Y":"是",:"")
    //set OPFeeFlagDesc=##class(CIS.AN.OperSchedule).OPFeeFlagLogicalToDisplay(operSchedule.OPFeeFlag)
    set ANFeeFlag=operSchedule.ANFeeFlag        // 麻醉费用审核标志
    set ANFeeFlagDesc=$CASE(ANFeeFlag,"N":"否","Y":"是",:"")
    //set ANFeeFlagDesc=##class(CIS.AN.OperSchedule).ANFeeFlagLogicalToDisplay(operSchedule.ANFeeFlag)

    kill archiveArr
    do ##class(CIS.AN.BL.RecordSheet).GetArchiveList(opsId,.archiveArr)
    set OperRiskAssessment=$g(archiveArr("OperRiskAssessment"))
    set OperSafetyCheck=$g(archiveArr("OperSafetyCheck"))
    set OperCount=$g(archiveArr("OperCount"))
    set AnaestConsent=$g(archiveArr("AnaestConsent"))
    set PrevANVisit=$g(archiveArr("PrevANVisit"))
    set PostANVisit=$g(archiveArr("PostANVisit"))
    set AnaestRecord=$g(archiveArr("AnaestRecord"))
    set PACURecord=$g(archiveArr("PACURecord"))
    set AnaestConclusion=$g(archiveArr("AnaestConclusion"))
    
    set MainPACURecordID=##class(CIS.AN.BL.PACURecord).GetPACURecordId(opsId)
    
    set PACUDoctor="",PACUDoctorDesc="",PACUShiftDoctor="",PACUShiftDoctorDesc=""
    set WardReceiveCareProv="",CarriedTube="",Complication="",PostOperNote=""
    set PACUInSteward="",PACUOutSteward="",PACUInStewardScore="",PACUOutStewardScore=""
    set PACUInStewardConscious="",PACUInStewardRespiration="",PACUInStewardMotion=""
    set PACUOutStewardConscious="",PACUOutStewardRespiration="",PACUOutStewardMotion=""
    if MainPACURecordID'=""
    {
        set pacuRecordObj=##class(CIS.AN.PACURecord).%OpenId(MainPACURecordID)
        set PACUDoctor=pacuRecordObj.PACUDoctor
        set PACUDoctorDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",pacuRecordObj.PACUDoctor)
        set PACUShiftDoctor=pacuRecordObj.ShiftDoctor
        set PACUShiftDoctorDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",pacuRecordObj.ShiftDoctor)
        set WardReceiveCareProv=pacuRecordObj.WardReceiveCareProv
        set CarriedTube=pacuRecordObj.CarriedTube
        set Complication=pacuRecordObj.Complication
        set PostOperNote=pacuRecordObj.PostOperNote
        if pacuRecordObj.InSteward'=""
        {
            set PACUInSteward=pacuRecordObj.InSteward.%Id()
            set PACUInStewardScore=pacuRecordObj.InSteward.Score
            set PACUInStewardConscious=pacuRecordObj.InSteward.Conscious
            set PACUInStewardRespiration=pacuRecordObj.InSteward.Respiration
            set PACUInStewardMotion=pacuRecordObj.InSteward.Motion
        }
        if pacuRecordObj.OutSteward'=""
        {
            set PACUOutSteward=pacuRecordObj.OutSteward.%Id()
            set PACUOutStewardScore=pacuRecordObj.OutSteward.Score
            set PACUOutStewardConscious=pacuRecordObj.OutSteward.Conscious
            set PACUOutStewardRespiration=pacuRecordObj.OutSteward.Respiration
            set PACUOutStewardMotion=pacuRecordObj.OutSteward.Motion
        }
    }

    set StatCategory = operSchedule.StatCategory
    set StatCategoryDesc = ""
    &sql(select Description into :StatCategoryDesc from CT_AN.DictData where Dictionary->Code='OperStatCategory' and Code=:StatCategory)
    set StatSeq = operSchedule.StatSeq
    
    set SiteDepth = operSchedule.SiteDepth
    set Endoscopy = operSchedule.Endoscopy
    
    set DrugAllergy= operSchedule.DrugAllergy
    set DrugAllergyNote= operSchedule.DrugAllergyNote
    set AppDocPhoneNo= operSchedule.AppDocPhoneNo
    set EstimatedOperTime=operSchedule.EstimatedOperTime
    set:EstimatedOperTime'="" EstimatedOperTime=$zt(EstimatedOperTime,2)
	set ArrPrintFlag=operSchedule.ArrPrintFlag
	set ArrPrintFlag=$CASE(ArrPrintFlag,"Y":"是","N":"否",:"")
    
    set result=$lb(opsId,opsId,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,
                   PatientID, MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,
                   PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,
                   StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,
                   PrevAnaMethodDesc,PlanSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,PlanSecAsstDesc,OperDesc,
                   OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,SecAsstDesc,BodySite,OperClassDesc,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialCondition,HighConsume,
                   IsoOperation,ECC,TransAutoBlood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHType,
                   HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,
                   CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCircualNurse,FirstCircualNurseDesc,SecCircualNurse,
                   SecCircualNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,
                   AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,
                   Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,
                   InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,
                   PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,
                   ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,
                   TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,opaId,
                   ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,
                   ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCircualNurse,ArrFirstCircualNurseDesc,ArrSecCircualNurse,ArrSecCircualNurseDesc,
                   MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,
                   ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,
                   OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,
                   MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,
                   PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,
                   PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,
                   PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion,
                   LaborStartDT,LaborEndDT,LaborEndTransLoc,LaborEndTransLocDesc,StatCategory,StatCategoryDesc,StatSeq,SiteDepth,Endoscopy,
                   ArrAnaNurse,ArrAnaNurseDesc,AnaNurse,AnaNurseDesc,AdmType,AdmTypeDesc,DrugAllergy,DrugAllergyNote,AppDocPhoneNo,Operation,EstimatedOperTime,ArrPrintFlag,Surgeon,PlanSurgeon,Hydrothorax)
    quit result
}

/// 从麻醉记录单上的数据中获取关键时间
/// w ##class(CIS.AN.BL.OperScheduleList).GetKeyTimeFromAnaData(220,.keyTimeList)
ClassMethod GetKeyTimeFromAnaData(opsId, ByRef keyTimeList) As %String
{
    kill needSyncEventCode
    set needSyncEventCode("OperStart")=""
    set needSyncEventCode("OperEnd")=""
    set needSyncEventCode("TubeIn")=""
    set needSyncEventCode("TubeOut")=""
    set needSyncEventCode("OperRoomIn")=""
    set needSyncEventCode("OperRoomOut")=""
    set needSyncEventCode("AnaStart")=""
    set needSyncEventCode("AnaEnd")=""
    set needSyncEventCode("PACUIn")=""
    set needSyncEventCode("PACUOut")=""
    
    set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,"AnaestRecord","")
    set paraItemRowId="",eventParaItemId=""
    for
    {
        set paraItemRowId=$o(^CIS.AN.ParaItemI("ISheet",+recordSheetId,paraItemRowId))
        quit:paraItemRowId=""
            
        set paraItemCode=$lg(^CIS.AN.ParaItemD(paraItemRowId),3)
        if paraItemCode="OperationEvent" set eventParaItemId=paraItemRowId
            
        quit:eventParaItemId'=""
    }
    
    set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,"PACURecord","")
    set paraItemRowId="",pacuEventParaItemId=""
    for
    {
        set paraItemRowId=$o(^CIS.AN.ParaItemI("ISheet",+recordSheetId,paraItemRowId))
        quit:paraItemRowId=""
            
        set paraItemCode=$lg(^CIS.AN.ParaItemD(paraItemRowId),3)
        if paraItemCode="OperationEvent" set pacuEventParaItemId=paraItemRowId
            
        quit:pacuEventParaItemId'=""
    }
        
    set EventCategoryId=+$O(^CT.AN.DataCategoryI("ICode"," KEYEVENT",""))
        
    set EventItemId="",ifAllFound=0
    for
    {
        set EventItemId=$o(^CT.AN.DataCateItemI("IDataCategory",EventCategoryId,EventItemId))
        quit:EventItemId=""
            
        set eventItem=##class(CT.AN.DataCateItem).%OpenId(EventItemId)
        set EventItemCode=eventItem.DataItem.Code
            
        if $d(needSyncEventCode(EventItemCode))&&(needSyncEventCode(EventItemCode)="")
        {
            set needSyncEventCode(EventItemCode)=eventItem.DataItem.%Id()
        }
            
        set ifAllFound=(needSyncEventCode("OperRoomIn")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("OperRoomOut")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("OperStart")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("OperEnd")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("AnaStart")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("AnaEnd")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("TubeIn")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("TubeOut")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("PACUIn")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("PACUOut")'="")
            
        quit:ifAllFound
    }
    
    //break //before get event time
    set TheatreInTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperRoomIn"))
    set AnestStartTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("AnaStart"))
    set OperStartTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperStart"))
    set OperEndTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperEnd"))
    set AnestEndTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("AnaEnd"))
    set TheatreOutTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperRoomOut"))
    set TubeInTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("TubeIn"))
    set TubeOutTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("TubeOut"))
    set PACUInTime=##class(CIS.AN.BL.AnaData).GetEventTime(pacuEventParaItemId,needSyncEventCode("PACUIn"))
    set PACUOutTime=##class(CIS.AN.BL.AnaData).GetEventTime(pacuEventParaItemId,needSyncEventCode("PACUOut"))
    
    set keyTimeList("TheatreInTime")=TheatreInTime
    set keyTimeList("AnestStartTime")=AnestStartTime
    set keyTimeList("OperStartTime")=OperStartTime
    set keyTimeList("OperEndTime")=OperEndTime
    set keyTimeList("AnestEndTime")=AnestEndTime
    set keyTimeList("TheatreOutTime")=TheatreOutTime
    set keyTimeList("TubeInTime")=TubeInTime
    set keyTimeList("TubeOutTime")=TubeOutTime
    set keyTimeList("PACUInTime")=PACUInTime
    set keyTimeList("PACUOutTime")=PACUOutTime
    quit "S^"
}

/// Creator：        yongyang
/// CreatDate：      2020年2月6日
/// Description：    根据手术申请ID获取麻醉方法名称（带有导管信息）
/// Table：          CIS_AN.OperSchedule,CIS_AN.AnaestCatheter
/// Input:          opsId:手术申请ID
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
        set NerveBlockSiteDesc=rs.Get("NerveBlockSiteDesc")
        
        set catheterInfo=""
        set:CatheterDesc'="" catheterInfo=catheterInfo_$lb(CatheterDesc)
        set:CatheterTypeDesc'="" catheterInfo=catheterInfo_$lb(CatheterTypeDesc)
        set:CatheterDepthDesc'="" catheterInfo=catheterInfo_$lb(CatheterDepthDesc)
        set:CatheterPathDesc'="" catheterInfo=catheterInfo_$lb(CatheterPathDesc)
        set:CatheterToolDesc'="" catheterInfo=catheterInfo_$lb(CatheterToolDesc)
        set:CatheterDirectionDesc'="" catheterInfo=catheterInfo_$lb(CatheterDirectionDesc)
        set:PunctureSpaceDesc'="" catheterInfo=catheterInfo_$lb(PunctureSpaceDesc)
        set:PositionMethodDesc'="" catheterInfo=catheterInfo_$lb(PositionMethodDesc)
        set:NerveBlockSiteDesc'="" catheterInfo=catheterInfo_$lb(NerveBlockSiteDesc)
        
        if catheterInfo="" set result=result_$lb(AnaMethodDesc)
        else  set result=result_$lb(AnaMethodDesc_"("_$ListToString(catheterInfo,",")_")")
    }
    
    quit $ListToString(result,"+")
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

/// Creator：        ccq
/// CreatDate：      2019年7月4日
/// Description：    根据手术申请ID获取拟施手术名称
/// Table：          CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:          opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetOperList("897")
ClassMethod GetOperList(opsId As %String, planOperData As %String) As %String
{
    set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
    set sc=rs.Execute(opsId)
    //set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
    set operIdList="",operDescList="",operNoteList="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
    set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList="",bodySiteList="",bodySiteDescList=""
    while(rs.%Next())
    {
        //set operObj=operList.GetAt(i)
        set operId=rs.Get("Operation")
        set operIdList=operIdList_$lb(operId)
        
        set operDesc=rs.Get("OperationDesc")
        
        set operNote=rs.Get("OperNote")
        set:(operDesc="") operDesc=operNote
        set operDescList=operDescList_$lb(operDesc)
        set operNoteList=operNoteList_$lb(operNote)

        set bodySite=rs.Get("BodySite")
        if (bodySiteList="") 
        {
            set bodySiteList=$lfs(bodySite,splitChar)   
        }
        else
        {
            set:($lf(bodySiteList,bodySite)=0) $li(bodySiteList,$ll(bodySiteList)+1)=bodySite   
        }

        set bodySiteDesc=rs.Get("BodySiteDesc")
        if (bodySiteDescList="") 
        {
            set bodyDescSiteList=$lfs(bodySiteDesc,splitChar)   
        }
        else
        {
            set:($lf(bodyDescSiteList,bodySiteDesc)=0) $li(bodyDescSiteList,$ll(bodyDescSiteList)+1)=bodySiteDesc   
        }
        
        set surgeon=rs.Get("Surgeon")
        if (surgeonList="") 
        {
            set surgeonList=$lfs(surgeon,splitChar) 
        }
        else
        {
            set:($lf(surgeonList,surgeon)=0) $li(surgeonList,$ll(surgeonList)+1)=surgeon    
        }
        
        //set:(surgeonStr'="") surgeonStr=surgeonStr_splitChar
        //set surgeonStr=surgeonStr_surgeon
        
        set surgeonDesc=rs.Get("SurgeonDesc")   
        set:(surgeonDesc="") surgeonDesc=surgeon
        if (surgeonDescList="") 
        {
            set surgeonDescList=$lfs(surgeonDesc,splitChar) 
        }
        else
        {
            set:($lf(surgeonDescList,surgeonDesc)=0) $li(surgeonDescList,$ll(surgeonDescList)+1)=surgeonDesc    
        }
        //set:(surgeonDescStr'="") surgeonDescStr=surgeonDescStr_splitChar
        //set surgeonDescStr=surgeonDescStr_surgeonDesc
        
        set assistant=rs.Get("Assistant")
        if (assistantList="") 
        {
            set assistantList=$lfs(assistant,splitChar) 
        }
        else
        {
            for j=1:1:$l(assistant,splitChar)
            {
                set curAssist=$p(assistant,splitChar,j)
                set:($lf(assistantList,curAssist)=0) $li(assistantList,$ll(assistantList)+1)=curAssist  
            }
                
        }
        //set:(assistantStr'="") assistantStr=assistantStr_splitChar
        //set assistantStr=assistantStr_assistant
        
        set assistantDesc=rs.Get("AssistantDesc")
        if (assistantDescList="") 
        {
            set assistantDescList=$lfs(assistantDesc,splitChar) 
        }
        else
        {
            for k=1:1:$l(assistantDesc,splitChar)
            {
                set curAssistDesc=$p(assistantDesc,splitChar,k)
                set:($lf(assistantDescList,curAssistDesc)=0) $li(assistantDescList,$ll(assistantDescList)+1)=curAssistDesc  
            }
            
        }
        //set:(assistantDescStr'="") assistantDescStr=assistantDescStr_splitChar
        //set assistantDescStr=assistantDescStr_assistantDesc

        set surgeonExpert=rs.Get("SurgeonExpert")
        set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
        set surgeonExpertStr=surgeonExpertStr_surgeonExpert
    }
    
    k planOperData
    set planOperData(1,"OperSchedule")=opsId
    set planOperData(1,"Operation")=$lts(operIdList,splitChar)
    set planOperData(1,"OperationDesc")=$lts(operDescList,"+")
    set planOperData(1,"OperNote")=$lts(operNoteList,splitChar)
    set planOperData(1,"BodySite")=$lts(bodySiteList,splitChar)
    set planOperData(1,"BodySiteDesc")=$lts(bodySiteDescList,splitChar)
    set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)               //surgeonStr
    set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)                               //surgeonDescStr
    set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
    set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
    set planOperData(1,"SurgeonExpert")=surgeonExpertStr
    
    set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
    quit result
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

/// Creator：        ccq
/// CreatDate：      2019年7月4日
/// Description：    根据手术申请ID获取拟施手术名称
/// Table：          CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:          opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetPlanOperList("7")
ClassMethod GetPlanOperList(opsId As %String, planOperData As %String) As %String
{
    set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindPlanOperationList")
    set sc=rs.Execute(opsId)
    //set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindPlanOperationList",opsId)
    set operIdList="",operDescList="",operNoteList="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
    set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList="",bodySiteList="",bodySiteDescList=""
    
    while(rs.%Next())
    {
        //set operObj=operList.GetAt(i)
        set operId=rs.Get("Operation")
        set operIdList=operIdList_$lb(operId)
        
        set operDesc=rs.Get("OperationDesc")
        
        set operNote=rs.Get("OperNote")
        set:(operDesc="") operDesc=operNote
        set operDescList=operDescList_$lb(operDesc)
        set operNoteList=operNoteList_$lb(operNote)

        set bodySite=rs.Get("BodySite")
        if (bodySiteList="") 
        {
            set bodySiteList=$lfs(bodySite,splitChar)   
        }
        else
        {
            set:($lf(bodySiteList,bodySite)=0) $li(bodySiteList,$ll(bodySiteList)+1)=bodySite   
        }

        set bodySiteDesc=rs.Get("BodySiteDesc")
        if (bodySiteDescList="") 
        {
            set bodyDescSiteList=$lfs(bodySiteDesc,splitChar)   
        }
        else
        {
            set:($lf(bodyDescSiteList,bodySiteDesc)=0) $li(bodyDescSiteList,$ll(bodyDescSiteList)+1)=bodySiteDesc   
        }
        
        set surgeon=rs.Get("Surgeon")
        if (surgeonList="") 
        {
            set surgeonList=$lfs(surgeon,splitChar) 
        }
        else
        {
            set:($lf(surgeonList,surgeon)=0) $li(surgeonList,$ll(surgeonList)+1)=surgeon    
        }
        
        //set:(surgeonStr'="") surgeonStr=surgeonStr_splitChar
        //set surgeonStr=surgeonStr_surgeon
        
        set surgeonDesc=rs.Get("SurgeonDesc")   
        set:(surgeonDesc="") surgeonDesc=surgeon
        if (surgeonDescList="") 
        {
            set surgeonDescList=$lfs(surgeonDesc,splitChar) 
        }
        else
        {
            set:($lf(surgeonDescList,surgeonDesc)=0) $li(surgeonDescList,$ll(surgeonDescList)+1)=surgeonDesc    
        }
        //set:(surgeonDescStr'="") surgeonDescStr=surgeonDescStr_splitChar
        //set surgeonDescStr=surgeonDescStr_surgeonDesc
        
        set assistant=rs.Get("Assistant")
        if (assistantList="") 
        {
            set assistantList=$lfs(assistant,splitChar) 
        }
        else
        {
            for j=1:1:$l(assistant,splitChar)
            {
                set curAssist=$p(assistant,splitChar,j)
                set:($lf(assistantList,curAssist)=0) $li(assistantList,$ll(assistantList)+1)=curAssist  
            }
                
        }
        //set:(assistantStr'="") assistantStr=assistantStr_splitChar
        //set assistantStr=assistantStr_assistant
        
        set assistantDesc=rs.Get("AssistantDesc")
        if (assistantDescList="") 
        {
            set assistantDescList=$lfs(assistantDesc,splitChar) 
        }
        else
        {
            for k=1:1:$l(assistantDesc,splitChar)
            {
                set curAssistDesc=$p(assistantDesc,splitChar,k)
                set:($lf(assistantDescList,curAssistDesc)=0) $li(assistantDescList,$ll(assistantDescList)+1)=curAssistDesc  
            }
            
        }
        //set:(assistantDescStr'="") assistantDescStr=assistantDescStr_splitChar
        //set assistantDescStr=assistantDescStr_assistantDesc

        set surgeonExpert=rs.Get("SurgeonExpert")
        set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
        set surgeonExpertStr=surgeonExpertStr_surgeonExpert
    }
    
    k planOperData
    set planOperData(1,"OperSchedule")=opsId
    set planOperData(1,"Operation")=$lts(operIdList,splitChar)
    set planOperData(1,"OperationDesc")=$lts(operDescList,"+")
    set planOperData(1,"OperNote")=$lts(operNoteList,splitChar)
    set planOperData(1,"BodySite")=$lts(bodySiteList,splitChar)
    set planOperData(1,"BodySiteDesc")=$lts(bodySiteDescList,splitChar)
    set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)               //surgeonStr
    set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)                               //surgeonDescStr
    set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
    set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
    set planOperData(1,"SurgeonExpert")=surgeonExpertStr
    set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
    quit result
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

/// Creator：      	yangguobin
/// CreatDate：    	2020-09-10
/// Description： 	保存病人交接时间
/// Table：        	CIS.AN.PatTransData
/// Input:			dataPara:数据
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PatTransfer).SavePatTransTime(^TMPYGB("SavePatTransTime"))
ClassMethod SavePatTransTime(SaveTransTimeFormData As %String) As %String
{
	set $zt="Error"
	set ^TMPYGB("SavePatTransTime")=SaveTransTimeFormData
	set sc=##class(CIS.AN.COM.String).ToArray(SaveTransTimeFormData,.array)
	
	m firstData=array(1)
	set moduleCode=$g(firstData("ModuleCode"))
	;m ^tangxiao20180912=array
	set moduleQuery=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindDataModule")
	set sc=moduleQuery.Execute("","",$get(firstData("ModuleCode")))
	set moduleId="",moduleDesc=""
	while(moduleQuery.Next())
	{
		set moduleId=moduleQuery.Get("RowId")	
		set moduleDesc=moduleQuery.Get("Description")
	}
	tstart

	set recordSheetId=""
	set:$get(firstData("RecordSheet"))'="" recordSheetId=firstData("RecordSheet")
	set:'##class(CIS.AN.RecordSheet).%ExistsId(firstData("RecordSheet")) recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetId($get(firstData("OPSID")),moduleId,$get(firstData("UpdateUserID")))

	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0)
	{
		trollback
		quit "E^"_recordSheetId	
	}
	set Type=firstData("Type")
	set RowId=..GetPatTransDataId(recordSheetId,firstData("PatLocation"),Type)

	if ( RowId'="")
	{
		trollback
		quit RowId
	}
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set opsId=recordSheet.OperSchedule.%Id()
	
	set dataIndex=0,saveResult="",packNo=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m TransTimeData=array(dataIndex)
		set TransTimeData("RecordSheet")=recordSheetId
		set TransTimeData("RowId")=RowId
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.TransTimeData)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
	
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：        杨国宾
/// CreatDate：      2020-09-11
/// Description：    判断病人交接状态
/// Table：          CIS.AN.PatTransData
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PatTransfer","GetPatTransDataId","1346")
ClassMethod GetPatTransDataId(RecordSheetId, PatLocation, Type)
{
	quit:(RecordSheetId="")||(PatLocation="")
	set RowId=""
	&sql(select %ID into :RowId from CIS_AN.PatTransData where RecordSheet=:RecordSheetId and PatLocation=:PatLocation and Type=:Type)	
	quit:RowId'="" "E^"_$li(^CT.AN.PatTransLocationD(PatLocation),2)_"已经扫过码"
	set PLRowId="",order=""
	&sql(select %ID ,order into :PLRowId,:order from CT_AN.PatTransLocation where RowId=:PatLocation and Type=:Type)
	q:order="" "进度或类型错误，请联系管理员重新维护"
	set i=0,flag=0
	for{
		set i=i+1
		quit:i=order
		set PLRowId=$O(^CT.AN.PatTransLocationI("IType"," "_Type," "_i,""))
		continue:+PLRowId=0
		set PatLocationBf=$li(^CT.AN.PatTransLocationD(PLRowId),1)
		&sql(select %ID into :RowId from CIS_AN.PatTransData where RecordSheet=:RecordSheetId and PatLocation=:PLRowId and Type=:Type)
		i RowId="" set flag="E^"_$li(^CT.AN.PatTransLocationD(PLRowId),2)_"还未扫码，请先点"_$li(^CT.AN.PatTransLocationD(PLRowId),2)_"扫码"
		quit:flag'=0
	}
	b ;006
	quit:flag'=0 flag
	quit ""
}

/// Creator：        杨国宾
/// CreatDate：      2020-09-10
/// Description：    查询病人交接时间
/// Table：          CIS.AN.PatTransData
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PatTransfer","FindPatTransTime","1346")
Query FindPatTransTime(RecordSheet, Type As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ODBCOUT(ScanDate) As ScanDate,
	  %ODBCOUT(ScanTime) As ScanTime,
	  PatLocation->Code As PatLocation
    from CIS_AN.PatTransData
	where (RecordSheet=:RecordSheet)
}

/// Creator：        杨国宾
/// CreatDate：      2020-12-21
/// Description：    查询病人交接项目及时间
/// Table：          CIS.AN.PatTransData
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PatTransfer","FindPatTransTimeByopsId","2052","输血交接")
Query FindPatTransTimeByopsId(RecordSheetId As %String = "", Type As %String = "") As %Query(ROWSPEC = "title,context") [ SqlProc ]
{
}

ClassMethod FindPatTransTimeByopsIdExecute(ByRef qHandle As %Binary, RecordSheetId As %String = "", Type As %String = "") As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	k ^TMPcontext($j)
    set dateformatnum=##class(websys.Conversions).DateFormat()
	if (##class(CIS.AN.RecordSheet).%ExistsId(RecordSheetId)=1)
	{
		set rowId=""
		for
		{
			set rowId=$O(^CIS.AN.PatTransDataI("RecordSheet",RecordSheetId,rowId))
			quit:rowId=""
			set PatTransData=##class(CIS.AN.PatTransData).%OpenId(rowId)
			set scanDate=$zd(PatTransData.ScanDate,dateformatnum)
			//set scanDate=##class(CIS.AN.COM.DateTime).ConvertToDate(PatTransData.ScanDate)
			set scanTime=##class(CIS.AN.COM.DateTime).ConvertToTime(PatTransData.ScanTime)
			set DateTime=scanDate_" "_scanTime
			set userId=PatTransData.UpdateUserID
			set userName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",userId)
			set PatTransLocationDesc=PatTransData.PatLocation.Description
			set title=PatTransLocationDesc
			set context="<div>"_userName_"</div><div>"_DateTime_"</div>"
			set ^TMPcontext($j,PatTransData.PatLocation.%Id())=context
		}
	}
	set rowId="",torder=""
	for
	{
		set torder=$O(^CT.AN.PatTransLocationI("IType"," "_Type,torder))
		quit:torder=""
		set rowId=$O(^CT.AN.PatTransLocationI("IType"," "_Type,torder,rowId))
		quit:rowId=""
		set PatTransLocation=##class(CT.AN.PatTransLocation).%OpenId(rowId)
		set title=PatTransLocation.Description
		set order=PatTransLocation.Order
		set context=$g(^TMPcontext($j,rowId))
		do OutputPatTransTime
	}
	k ^TMPcontext($j)
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputPatTransTime
	s ^CacheTemp(repid,ind)=$lb(title,context)
	s ind=ind+1
	q
}

ClassMethod FindPatTransTimeByopsIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatTransTimeByopsIdExecute ]
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

ClassMethod FindPatTransTimeByopsIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatTransTimeByopsIdExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(CIS.AN.BL.PatTransfer).GetTransOrder(2096)
ClassMethod GetTransOrder(RecordSheetId)
{
	set rowId="",retOrder=0
	for
	{
		set rowId=$O(^CIS.AN.PatTransDataI("RecordSheet",RecordSheetId,rowId))
		quit:rowId=""
		set PatTransData=##class(CIS.AN.PatTransData).%OpenId(rowId)
		set PatLocationId=PatTransData.PatLocation.%Id()
		set Order=##class(CIS.AN.COM.String).GetDescByID("CT.AN.PatTransLocation","Order",PatLocationId)
		if Order>retOrder  set retOrder=Order
	}
	quit retOrder
}

ClassMethod GetTransItemTime(RecordSheetId As %String = "", Type As %String = "") As %String
{
	set TransItemTime=##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.BL.PatTransfer","FindPatTransTimeByopsId",RecordSheetId,Type)
	set Order=0
	if (RecordSheetId'="") set Order=##class(CIS.AN.BL.PatTransfer).GetTransOrder(RecordSheetId)
	quit TransItemTime_"^"_Order
}

}
