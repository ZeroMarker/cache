Class CIS.AN.SRV.Sync.OP.Appointment Extends %RegisteredObject
{

/// 数据表名
Parameter TableName = "CIS.AN.OperSchedule";

/// 外部系统
Parameter ExternalSystem = "OPApp";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "AIS: storing appointments start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.AN.DTO.OP.Appointment") 
		{
			if model.Validate() do ..Mapping(model)
		}
	}
	if ..#DEBUG=1 write "AIS: storing appointments end",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.AN.DTO.OP.Appointment) As %Status
{
	if ..#DEBUG=1 write "AIS: mapping appointment: start...",!
	set dataMapping=##class(CIS.AN.DTO.Base.DataMapping).%New()
	set dataMapping.TableName="CIS.AN.OperSchedule"
	set dataMapping.ExternalSystem="OPApp"
	set dataMapping.ExternalID=model.ApplicationID
	set dataMapping.InstanceID=##class(CIS.AN.BL.DataMapping).GetInstanceID(dataMapping.TableName,dataMapping.ExternalID,dataMapping.ExternalSystem)
	
	if (dataMapping.InstanceID="")
	{
		if ..#DEBUG=1 write "AIS: mapping appointment: can not find mapping data",!
		if ..Conflicted(model)
		{
			set model.RowId=model.ApplicationID
			set rowId=model.RowId
			do ##class(CIS.AN.SRV.Sync.HIS.Patient).Mapping(model.Patient)
			do ##class(CIS.AN.SRV.Sync.HIS.Admission).Mapping(model.Admission)
		}
		else
		{
			set rowId=..CreateFromModel(model)
		}
		set dataMapping.InstanceID=rowId
		do ##class(CIS.AN.BL.DataMapping).Store(dataMapping)
	}
	else
	{
		if ..#DEBUG=1 write "AIS: mapping appointment: found mapping data:",dataMapping.InstanceID,!
		set instance=##class(CIS.AN.OperSchedule).%OpenId(dataMapping.InstanceID)
		do ..Compare(model,instance)
	}
	if ..#DEBUG=1 write "AIS: mapping appointment: end",!
	quit $$$OK
}

ClassMethod Conflicted(model As CIS.AN.DTO.OP.Appointment) As %Boolean
{
	set result = 0
	
	if ##class(CIS.AN.OperSchedule).%ExistsId(model.ApplicationID)
	{
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(model.ApplicationID)
		if operSchedule.EpisodeID=model.Admission.EpisodeID set result = 1
	}
	
	quit result
}

ClassMethod Compare(model As CIS.AN.DTO.OP.Appointment, instance As CIS.AN.OperSchedule) As %Status
{
	set instance.RegNo=model.Patient.RegNo
	set instance.PatName=model.Patient.Name
	set instance.PatDOB=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.Patient.Birthday,"")
	set instance.PatGender=model.Patient.Sex
	set instance.BloodType=model.Patient.BloodType
	set instance.RHBloodType=model.Patient.RHBloodType
	
	set instance.EpisodeID=model.Admission.EpisodeID
	set instance.MedicareNo=model.Admission.MedcareNo
	set instance.PatDeptID=model.Admission.DepartmentID
	set instance.PatWardID=model.Admission.WardID
	set instance.PatBedID=model.Admission.BedID
	
	set instance.ExternalID=""
	set instance.Status=##class(CIS.AN.BL.OperStatus).GetInstance(model.StatusCode)
	set instance.SourceType=model.SourceType
	set instance.DaySurgery=model.DaySurgery
	set instance.OPAdmType=model.SurgeryType
	set instance.AppDeptID=model.ApplyDepartmentID
	set instance.AppDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.ApplyDate,+$h)
	set instance.AppTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.ApplyTime,+$p($h,",",2))
	set instance.AppUserID=model.ApplyUserID
	set instance.OperDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.OperDate,"")
	set instance.OperTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.OperTime,"")
	set instance.OperDeptID=model.OperatingDepartmentID
	set instance.AnaDept=model.AnaDepartmentID
	set instance.PrevDiagnosis=model.PreviousDiagnosisID
	set instance.ReentryOperation=model.UnplannedReentry
	set instance.SurVisitors=model.Visitor
	set instance.SeqType=model.SeqType
	set instance.PlanSeq=model.PlanSeq
	set instance.OperPosition=model.OperPositionID
	
	set instance.HbsAg=$s(model.Infection.HBsAg="阳性":"+",model.Infection.HBsAg="阴性":"-",model.Infection.HBsAg="已查未归":"UR",1:"N")
   	set instance.HcvAb=$s(model.Infection.HCVAb="阳性":"+",model.Infection.HCVAb="阴性":"-",model.Infection.HCVAb="已查未归":"UR",1:"N")
   	set instance.HivAb=$s(model.Infection.HivAb="阳性":"+",model.Infection.HivAb="阴性":"-",model.Infection.HivAb="已查未归":"UR",1:"N")
   	set instance.Syphilis=$s(model.Infection.TPAb="阳性":"+",model.Infection.TPAb="阴性":"-",model.Infection.TPAb="已查未归":"UR",1:"N")
   	set instance.MDROS=$s(model.Infection.MDROS="阳性":"+",model.Infection.MDROS="阴性":"-",model.Infection.MDROS="已查未归":"UR",1:"N")
   	
   	set instance.SurgicalMaterials=model.Requirement.Instruments
   	set instance.HighConsume=model.Requirement.Materials
   	set instance.SpecialConditions=model.Requirement.SpecialCondition
   	set instance.IsoOperation=model.Requirement.Isolated
   	set instance.ECC=model.Requirement.CPB
   	set instance.TransAutoblood=model.Requirement.IOAT
   	set instance.PrepareBlood=model.Requirement.PrepareBlood
   	set instance.InfectionOper=model.Requirement.Infectious
   	set instance.MIS=model.Requirement.MinimallyInvasive
   	set instance.Antibiosis=model.Requirement.Antibiotic
   	set instance.OperRequirement=model.Requirement.Note
   	
	set sc=instance.%Save()
	if $$$ISOK(sc)
	{
		set rowId=instance.%Id()
		set model.RowId=rowId
		
		do ##class(CIS.AN.SRV.Sync.HIS.Patient).Mapping(model.Patient)
		do ##class(CIS.AN.SRV.Sync.HIS.Admission).Mapping(model.Admission)
		
		set operations=##class(%ListOfObjects).%New()
		while(model.PlanOperations.GetNext(.key))
		{
			set operation=model.PlanOperations.GetAt(key)
			set operation.ApplicationID=rowId
			do operations.Insert(operation)
		}
		do ##class(CIS.AN.SRV.Sync.OP.PlanOperation).Clear(rowId)
		do ##class(CIS.AN.SRV.Sync.OP.PlanOperation).Store(operations)
		do ##class(CIS.AN.SRV.Sync.OP.Operation).Clear(rowId)
		do ##class(CIS.AN.SRV.Sync.OP.Operation).Store(operations)
		
		set anaethesia=##class(CIS.AN.DTO.AN.Anaesthesia).%New()
		set anaethesia.EpisodeID=model.Admission.EpisodeID
		set anaethesia.ApplicationID=rowId
		set anaethesia.AnaMethod=model.AnaMethod
		set anaethesia.AnaMethodID=model.AnaMethodID
		set anaethesia.AnaMethodStandardCode=model.AnaMethodStandardCode
		do ##class(CIS.AN.SRV.Sync.AN.Anaethesia).Mapping(anaethesia)
		
		// 当前先不考虑兼容旧版本
		//do ..CompatibleWithOldVersion(model)
		quit rowId
	}
	
	quit sc
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.AN.DTO.OP.Appointment) As %Status
{
	set instance=##class(CIS.AN.OperSchedule).%New()
	
	set instance.RegNo=model.Patient.RegNo
	set instance.PatName=model.Patient.Name
	set instance.PatDOB=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.Patient.Birthday,"")
	set instance.PatGender=model.Patient.Sex
	set instance.BloodType=model.Patient.BloodType
	set instance.RHBloodType=model.Patient.RHBloodType
	
	set instance.EpisodeID=model.Admission.EpisodeID
	set instance.MedicareNo=model.Admission.MedcareNo
	set instance.PatDeptID=model.Admission.DepartmentID
	set instance.PatWardID=model.Admission.WardID
	set instance.PatBedID=model.Admission.BedID
	
	set instance.ExternalID=""
	set instance.Status=##class(CIS.AN.BL.OperStatus).GetInstance(model.StatusCode)
	set instance.SourceType=model.SourceType
	set instance.DaySurgery=model.DaySurgery
	set instance.OPAdmType=model.SurgeryType
	set instance.AppDeptID=model.ApplyDepartmentID
	set instance.AppDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.ApplyDate,+$h)
	set instance.AppTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.ApplyTime,+$p($h,",",2))
	set instance.AppUserID=model.ApplyUserID
	set instance.OperDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.OperDate,"")
	set instance.OperTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.OperTime,"")
	set instance.OperDeptID=model.OperatingDepartmentID
	set instance.AnaDept=model.AnaDepartmentID
	set instance.PrevDiagnosis=model.PreviousDiagnosisID
	set instance.ReentryOperation=model.UnplannedReentry
	set instance.SurVisitors=model.Visitor
	set instance.SeqType=model.SeqType
	set instance.PlanSeq=model.PlanSeq
	set instance.OperPosition=model.OperPositionID
	
	set instance.HbsAg=$s(model.Infection.HBsAg="阳性":"+",model.Infection.HBsAg="阴性":"-",model.Infection.HBsAg="已查未归":"UR",1:"N")
   	set instance.HcvAb=$s(model.Infection.HCVAb="阳性":"+",model.Infection.HCVAb="阴性":"-",model.Infection.HCVAb="已查未归":"UR",1:"N")
   	set instance.HivAb=$s(model.Infection.HivAb="阳性":"+",model.Infection.HivAb="阴性":"-",model.Infection.HivAb="已查未归":"UR",1:"N")
   	set instance.Syphilis=$s(model.Infection.TPAb="阳性":"+",model.Infection.TPAb="阴性":"-",model.Infection.TPAb="已查未归":"UR",1:"N")
   	set instance.MDROS=$s(model.Infection.MDROS="阳性":"+",model.Infection.MDROS="阴性":"-",model.Infection.MDROS="已查未归":"UR",1:"N")
   	
   	set instance.SurgicalMaterials=model.Requirement.Instruments
   	set instance.HighConsume=model.Requirement.Materials
   	set instance.SpecialConditions=model.Requirement.SpecialCondition
   	set instance.IsoOperation=model.Requirement.Isolated
   	set instance.ECC=model.Requirement.CPB
   	set instance.TransAutoblood=model.Requirement.IOAT
   	set instance.PrepareBlood=model.Requirement.PrepareBlood
   	set instance.InfectionOper=model.Requirement.Infectious
   	set instance.MIS=model.Requirement.MinimallyInvasive
   	set instance.Antibiosis=model.Requirement.Antibiotic
   	set instance.OperRequirement=model.Requirement.Note
   	
	set sc=instance.%Save()
	if $$$ISOK(sc)
	{
		set rowId=instance.%Id()
		set model.RowId=rowId
		
		do ##class(CIS.AN.SRV.Sync.HIS.Patient).Mapping(model.Patient)
		do ##class(CIS.AN.SRV.Sync.HIS.Admission).Mapping(model.Admission)
		
		set operations=##class(%ListOfObjects).%New()
		while(model.PlanOperations.GetNext(.key))
		{
			set operation=model.PlanOperations.GetAt(key)
			set operation.ApplicationID=rowId
			do operations.Insert(operation)
		}
		do ##class(CIS.AN.SRV.Sync.OP.PlanOperation).Store(operations)
		do ##class(CIS.AN.SRV.Sync.OP.Operation).Store(operations)
		
		set anaethesia=##class(CIS.AN.DTO.AN.Anaesthesia).%New()
		set anaethesia.EpisodeID=model.Admission.EpisodeID
		set anaethesia.ApplicationID=rowId
		set anaethesia.AnaMethod=model.AnaMethod
		set anaethesia.AnaMethodID=model.AnaMethodID
		set anaethesia.AnaMethodStandardCode=model.AnaMethodStandardCode
		do ##class(CIS.AN.SRV.Sync.AN.Anaethesia).Mapping(anaethesia)
		
		// 当前先不考虑兼容旧版本
		// do ..CompatibleWithOldVersion(model)
		quit rowId
	}
	else
	{
		quit ""
	}
}

/// 兼容旧版本
ClassMethod CompatibleWithOldVersion(model As CIS.AN.DTO.OP.Appointment) As %Status
{
	if ..#DEBUG=1 write "AIS: compatible with old version(4.x): start...",!
	set rowId=model.RowId
	
	if (model.OldAnaestID="")
    {
        set anaesthesia("RowId")=model.OldAnaestID
        set anaesthesia("ParentRowId")=model.Admission.EpisodeID
        set saveResult=##class(CIS.AN.BL.OperApplication).SaveORAnaesthesia(.anaesthesia)
    }

    // 将OR_Anaesthesia表的RowId保存到CIS_AN.OperSchedule表中，方便直接调用
    if ($piece(saveResult,"^",1)="S")
    {
	    set schedule("RowId")=rowId
        set schedule("ClassName")="CIS.AN.OperSchedule"
        set anaId=$piece(saveResult,"^",2)
        set schedule("ExtAnaestID")=anaId
        set saveResult=##class(CIS.AN.COM.DataService).SaveData(.schedule)
    }
    
	if ..#DEBUG=1 write "AIS: compatible with old version(4.x): opsId:",rowId,!
	set saveResult=##class(CIS.AN.SRV.OperAppService).SendOperAppInfo(rowId,.ret)
	if ..#DEBUG=1 write "AIS: compatible with old version(4.x): end",!
	quit $$$OK
}

}
