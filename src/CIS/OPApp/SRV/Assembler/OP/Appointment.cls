Class CIS.OPApp.SRV.Assembler.OP.Appointment Extends %RegisteredObject
{

/// if debug is 1, then  write console logs
Parameter DEBUG = 0;

/// w ##class(CIS.OPApp.SRV.Assembler.OP.Appointment).Query()
ClassMethod Query(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		//查询Query，或者调用业务方法
		set list=""
		if (params.EpisodeID'="")
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
			set indexNode="OPDate"
    		//set indexNode="AppDate"
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

ClassMethod VerifyInput(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.OPApp.SRV.Assembler.OP.Appointment).GetInstanceFromOPA(4166)
ClassMethod GetInstanceFromOPA(opaId As %String) As CIS.OPApp.DTO.OP.Appointment
{
	set opsId=$o(^CIS.AN.OperScheduleI("Ext"," "_opaId,""))
	quit ..GetInstance(opsId)
}

/// w ##class(CIS.OPApp.SRV.Assembler.OP.Appointment).GetInstance(4166)
ClassMethod GetInstance(opsId As %String) As CIS.OPApp.DTO.OP.Appointment
{
	set instance=##class(CIS.OPApp.DTO.OP.Appointment).Create()
	
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
    
    // 获取手术预约ID
    set instance.RowId=opsId
    set instance.ExternalID=opsId
    set instance.ApplicationID=opsId
    set instance.OldID=operSchedule.ExternalID
    
    // 获取患者个人信息
    set rs=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindPatient")
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
   		//set instance.Admission.MedcareNo=rs.Get("MedcareNo")
   		set instance.Admission.MedcareNo=##class(CIS.AN.BL.Admission).GetMedCareNo(instance.Admission.EpisodeID)
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
   	set instance.ApplyTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.AppTime,"")
   	set instance.ApplyUserID=operSchedule.AppUserID
   	set instance.ApplyUser=""
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
   	set instance.UnplannedReentry=operSchedule.ReentryOperation
   	set instance.Visitor=operSchedule.SurVisitors
   	set instance.SeqType=operSchedule.SeqType
   	set instance.SeqTypeDesc=operSchedule.SeqType
   	set instance.PlanSeq=operSchedule.PlanSeq
   	set instance.OperPositionID=operSchedule.OperPosition
   	set instance.OperPosition=..GetOperPosDesc(instance.OperPositionID)
   	
   	// 获取手术操作信息
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
   	
   	// 获取感染信息
   	set instance.Infection.HBsAg=$s(operSchedule.HbsAg="+":"阳性",operSchedule.HbsAg="-":"阴性",1:"未知")
   	set instance.Infection.HCVAb=$s(operSchedule.HcvAb="+":"阳性",operSchedule.HcvAb="-":"阴性",1:"未知")
   	set instance.Infection.HivAb=$s(operSchedule.HivAb="+":"阳性",operSchedule.HivAb="-":"阴性",1:"未知")
   	set instance.Infection.TPAb=$s(operSchedule.Syphilis="+":"阳性",operSchedule.Syphilis="-":"阴性",1:"未知")
   	set instance.Infection.MDROS=$s(operSchedule.MDROS="+":"阳性",operSchedule.MDROS="-":"阴性",1:"未知")
   	
   	// 获取手术要求
   	set instance.Requirement.Equipments=""
   	set instance.Requirement.Instruments=operSchedule.SurgicalMaterials
   	set instance.Requirement.Materials=operSchedule.HighConsume
   	set instance.Requirement.SpecialCondition=operSchedule.SpecialConditions
   	set instance.Requirement.Isolated=operSchedule.IsoOperation
   	set instance.Requirement.CPB=operSchedule.ECC
   	set instance.Requirement.IOAT=operSchedule.TransAutoblood
   	set instance.Requirement.PrepareBlood=operSchedule.PrepareBlood
   	set instance.Requirement.Infectious=operSchedule.InfectionOper
   	set instance.Requirement.MinimallyInvasive=operSchedule.MIS
   	set instance.Requirement.Antibiotic=operSchedule.Antibiosis
   	set instance.Requirement.Note=operSchedule.OperRequirement
   	
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

}
