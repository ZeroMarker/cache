Class CIS.AN.SRV.Assembler.OP.Registration Extends %RegisteredObject
{

/// 数据表名
Parameter TableName = "CIS.AN.OperSchedule";

/// 外部系统
Parameter ExternalSystem = "OPApp";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Query(params As CIS.AN.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		//查询Query，或者调用业务方法
		set list=""
		if (params.RowId'="")
		{
			set list=$lb(params.RowId)
		}
		elseif (params.ApplicationID'="")
		{
			set opsId=##class(CIS.AN.BL.DataMapping).GetInstanceID(..#TableName,params.ApplicationID,..#ExternalSystem)
			if opsId'="" set list=$lb(opsId)
		}
		elseif (params.EpisodeID'="")
		{
			set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(params.EpisodeID)
			set list=$LISTFROMSTRING(opsIdStr,",")
		}
		elseif (params.RegNo'="") 
		{
			set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo(params.RegNo)
			set list=$LISTFROMSTRING(opsIdStr,",")
		}
		elseif (params.MedcareNo'="") 
		{
			set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByMedcareNo(params.MedCareNo)
			set list=$LISTFROMSTRING(opsIdStr,",")
		}
		elseif (params.OldID'="")
		{
			set opsId=$o(^CIS.AN.OperScheduleI("Ext"," "_params.OldID,""))
			set list=$lb(opsId)
		}
		else
		{
			set list=""
			//set indexNode="OPDate"
    		set indexNode="AppDate"
    		set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(params.StartDate)
    		set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(params.EndDate,startDateH)
			for date=startDateH:1:endDateH
		    {
		        set opsId=0
		        for
		        {
		            set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
		            quit:(opsId="")
		            
		            set list=list_$lb(opsId)
		        }
		    }
		}
	    
	   	if (list'="")
	    {
	        for i=1:1:$ll(list)
	        {
		        set opsId=$lg(list,i)
		        do collection.Insert(..GetInstance(opsId))
	        }
	    }
	}
	
	quit collection
}

ClassMethod VerifyInput(params As CIS.AN.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.OPApp.DTO.OP.Appointment).GetInstance(4166)
ClassMethod GetInstance(opsId As %String) As CIS.AN.DTO.OP.Registration
{
	set instance=##class(CIS.AN.DTO.OP.Registration).Create()
	
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
    
    // 获取手术预约ID
    set instance.RowId=opsId
    set instance.ExternalID=##class(CIS.AN.BL.DataMapping).GetExternalID(..#TableName,opsId,..#ExternalSystem)
    set instance.ApplicationID=instance.ExternalID
    set instance.OldID=operSchedule.ExternalID
    
    // 获取患者个人信息
    set rs=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindPatientNew")
    set sc=rs.Execute(operSchedule.EpisodeID)
    while(rs.%Next())
    {
	    set instance.Patient.RegNo=rs.Get("RegNo")
    	set instance.Patient.PatientID=rs.Get("PatientID")
    	set instance.Patient.CardID=rs.Get("CardID")
    	set instance.Patient.CertID=""
    	set instance.Patient.Name=rs.Get("PatName")
    	set instance.Patient.Alias=""
    	set instance.Patient.Birthday=rs.Get("PatDOB")
    	set instance.Patient.Age=##class(CIS.AN.COM.DateTime).CalAge(rs.Get("PatDOBH"),operSchedule.OperDate)
    	set instance.Patient.Sex=rs.Get("PatGender")
    	set instance.Patient.Nation=""
    	set instance.Patient.SocialStatus=""
    	set instance.Patient.Address=""
    	set instance.Patient.TelephoneNo=rs.Get("MobPhone")
    	set instance.Patient.SecretLevel=rs.Get("PatSecretLevel")
    	set instance.Patient.SecretCode=rs.Get("PatSecretCode")
    	set instance.Patient.BloodType=operSchedule.BloodType
    	set instance.Patient.RHBloodType=operSchedule.RHBloodType
    
   		// 获取患者就诊信息
   		set instance.Admission.PatientID=rs.Get("PatientID")
   		set instance.Admission.EpisodeID=rs.Get("EpisodeID")
   		set instance.Admission.MedcareNo=rs.Get("Operation")
   		set instance.Admission.Type=rs.Get("AdmType")
   		set instance.Admission.TypeDesc=rs.Get("AdmTypeDesc")
   		set instance.Admission.DepartmentID=rs.Get("PatDeptID")
   		set instance.Admission.Department=rs.Get("PatDept")
   		set instance.Admission.WardID=rs.Get("PatWardID")
   		set instance.Admission.Ward=rs.Get("PatWard")
   		set instance.Admission.BedID=rs.Get("PatBedID")
   		set instance.Admission.Bed=rs.Get("PatBed")
   		set instance.Admission.AdmDate=rs.Get("AdmDate")
   		set instance.Admission.AdmTime=rs.Get("AdmTime")
   		set instance.Admission.VisitStatus=rs.Get("VisitStatus")
   		set instance.Admission.VisitStatusDesc=rs.Get("VisitStatusDesc")
   		set instance.Admission.DischargeDate=rs.Get("DischargeDate")
   		set instance.Admission.DischargeTime=rs.Get("DischargeTime")
    }
   	
   	// 获取手术信息
   	set instance.StatusCode=operSchedule.Status.Code
   	set instance.StatusDesc=operSchedule.Status.Description
   	set instance.SourceType=operSchedule.SourceType
   	set instance.SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
   	set instance.DaySurgery=operSchedule.DaySurgery
   	set instance.SurgeryType=operSchedule.OPAdmType
   	set instance.SurgeryTypeDesc=##class(CIS.AN.OperSchedule).OPAdmTypeLogicalToDisplay(operSchedule.OPAdmType)
   	set instance.ApplyDepartmentID=operSchedule.AppDeptID
   	set instance.ApplyDepartment=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
   	set instance.ApplyDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.AppDate,"")
   	set instance.OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
   	set instance.OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")
   	set instance.OperatingDepartmentID=operSchedule.OperDeptID
   	set instance.OperatingDepartment=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
   	set instance.AnaDepartmentID=operSchedule.AnaDept
   	set instance.AnaDepartment=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
   	set instance.AnaMethodID=anaesthesia.AnaMethod
   	set instance.AnaMethod=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",anaesthesia.AnaMethod)
   	set instance.AnaMethodStandardCode=""
   	set instance.PreviousDiagnosisID=$tr(operSchedule.PrevDiagnosis,$c(4),"")
   	set instance.PreviousDiagnosis=..GetDiagnosisDesc(instance.PreviousDiagnosisID)
   	set instance.PostDiagnosisID=$tr(operSchedule.PostDiagnosis,$c(4),"")
   	set instance.PostDiagnosis=..GetDiagnosisDesc(instance.PostDiagnosisID)
   	set instance.UnplannedReentry=operSchedule.ReentryOperation
   	set instance.Visitor=operSchedule.SurVisitors
   	set instance.OperPositionID=operSchedule.OperPosition
   	set instance.OperPosition=##class(CIS.AN.SRV.Assembler.OP.Appointment).GetOperPosDesc(instance.OperPositionID)
   	
   	// 获取拟施手术操作信息
   	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindPlanOperationList")
	set sc=rs.Execute(opsId)
	while(rs.Next())
	{
		set operation=##class(CIS.OPApp.DTO.OP.Operation).%New()
		set operation.OperNameID=rs.Get("Operation")
		set operation.OperName=rs.Get("OperationDesc")
		set operation.OperNameStandardCode=""
		set operation.OperCategoryID=rs.Get("OperClass")
		set operation.OperCategory=rs.Get("OperClassDesc")
		set operation.BladeTypeID=rs.Get("BladeType")
		set operation.BladeType=rs.Get("BladeTypeDesc")
		set operation.BladeTypeStandardCode=""
		set operation.BodySiteID=rs.Get("BodySite")
		set operation.BodySite=rs.Get("BodySiteDesc")
		set operation.SurgicalDepartmentID=rs.Get("SurgeonDeptID")
		set operation.SurgicalDepartment=rs.Get("SurgeonDeptDesc")
		set operation.Surgeon=##class(CIS.OPApp.SRV.Assembler.Base.CareProvider).GetInstance(rs.Get("Surgeon"))
		set operation.ExternalExpert=rs.Get("SurgeonExpert")
		set operation.Note=rs.Get("OperNote")
		
		set assistantIdStr=rs.Get("Assistant")
		for i=1:1:$length(assistantIdStr,",")
		{
			set assistantId=$p(assistantIdStr,",",i)
			if assistantId'=""
			{
				do operation.Assistants.Insert(##class(CIS.OPApp.SRV.Assembler.Base.CareProvider).GetInstance(assistantId))
			}
		}
		
		do instance.PlanOperations.Insert(operation)
	}
   	
   	// 获取实施手术操作信息
   	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rs.Execute(opsId)
	while(rs.Next())
	{
		set operation=##class(CIS.OPApp.DTO.OP.Operation).%New()
		set operation.OperNameID=rs.Get("Operation")
		set operation.OperName=rs.Get("OperationDesc")
		set operation.OperNameStandardCode=""
		set operation.OperCategoryID=rs.Get("OperClass")
		set operation.OperCategory=rs.Get("OperClassDesc")
		set operation.BladeTypeID=rs.Get("BladeType")
		set operation.BladeType=rs.Get("BladeTypeDesc")
		set operation.BladeTypeStandardCode=""
		set operation.BodySiteID=rs.Get("BodySite")
		set operation.BodySite=rs.Get("BodySiteDesc")
		set operation.SurgicalDepartmentID=rs.Get("SurgeonDeptID")
		set operation.SurgicalDepartment=rs.Get("SurgeonDeptDesc")
		set operation.Surgeon=##class(CIS.OPApp.SRV.Assembler.Base.CareProvider).GetInstance(rs.Get("Surgeon"))
		set operation.ExternalExpert=rs.Get("SurgeonExpert")
		set operation.Note=rs.Get("OperNote")
		
		set assistantIdStr=rs.Get("Assistant")
		for i=1:1:$length(assistantIdStr,",")
		{
			set assistantId=$p(assistantIdStr,",",i)
			if assistantId'=""
			{
				do operation.Assistants.Insert(##class(CIS.OPApp.SRV.Assembler.Base.CareProvider).GetInstance(assistantId))
			}
		}
		
		do instance.ActualOperations.Insert(operation)
	}
	
	// 获取手术间/恢复室床位信息
    set instance.OperRoomID=""
    set instance.OperRoom=""
    if $IsObject(operSchedule.OperRoom)
    {
	    set instance.OperRoomID=operSchedule.OperRoom.%Id()
	    set instance.OperRoom=operSchedule.OperRoom.Description
    }
    set instance.OperSeq=operSchedule.OperSeq
    
    // 获取手术护士信息
    set instance.ScrubNurses=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstanceList($LISTFROMSTRING(operSchedule.ScrubNurse,","))
    set instance.CirculatingNurses=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstanceList($LISTFROMSTRING(operSchedule.CircualNurse,","))
	
	// 获取麻醉医生信息
	set instance.Anaesthetist=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstance(anaesthesia.Anesthesiologist)
	set instance.AnaDirector=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstance(anaesthesia.AnaExpert)
	set instance.AnaAssistants=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstanceList($LISTFROMSTRING(anaesthesia.AnaAssistant,","))
	
   	// 获取关键事件信息
   	set instance.AreaIn=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.AreaInDT,"AreaIn")
   	set instance.RoomIn=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.TheatreInDT,"RoomIn")
   	set instance.AnaStart=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.AnaStartDT,"AnaStart")
   	set instance.TubeIn=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.TubeInDT,"TubeIn")
   	set instance.OperStart=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.OperStartDT,"OperStart")
   	set instance.OperEnd=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.OperFinishDT,"OperEnd")
   	set instance.TubeOut=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.TubeOutDT,"TubeOut")
   	set instance.AnaEnd=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.AnaFinishDT,"AnaEnd")
   	set instance.RoomOut=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.TheatreOutDT,"RoomOut")
   	set instance.PACUIn=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.PACUInDT,"PACUIn")
   	set instance.PACUOut=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.PACUOutDT,"PACUOut")
   	set instance.AreaOut=##class(CIS.AN.DTO.OP.KeyTime).Construct(anaesthesia.AreaOutDT,"AreaOut")
   	
   	// 获取手术登记提交信息
   	set instance.SubmitDate=""
   	set instance.SubmitUserID=""
   	set instance.SubmitUser=""
   	
   	// 获取手术执行闭环流程
   	set args=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
   	set args.ApplicationID=opsId
   	set instance.Procedures=##class(CIS.AN.SRV.Assembler.OP.Procedure).Query(args)
   	
   	// 获取手术交接班信息
   	set args=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
   	set args.ApplicationID=opsId
   	set instance.Shifts=##class(CIS.AN.SRV.Assembler.OP.Shift).Query(args)
   	
   	quit instance
}

ClassMethod GetDiagnosisDesc(diagnosis As %String) As %String
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

}
