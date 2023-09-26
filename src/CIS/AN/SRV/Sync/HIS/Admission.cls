Class CIS.AN.SRV.Sync.HIS.Admission Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "AIS: storing admissions start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.OPApp.DTO.HIS.Admission") do ..Mapping(model)
	}
	if ..#DEBUG=1 write "AIS: storing admissions end",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.HIS.Admission) As %Status
{
	if ..#DEBUG=1 write "AIS: mapping admission: start...",!
	set dataMapping=##class(CIS.AN.DTO.Base.DataMapping).%New()
	set dataMapping.TableName="CIS.AN.Admission"
	set dataMapping.ExternalSystem="OPApp"
	set dataMapping.ExternalID=model.EpisodeID
	set dataMapping.InstanceID=##class(CIS.AN.BL.DataMapping).GetInstanceID(dataMapping.TableName,dataMapping.ExternalID,dataMapping.ExternalSystem)
	
	if (dataMapping.InstanceID="")
	{
		if ..#DEBUG=1 write "AIS: mapping admission: can not find mapping data",!
		set rowId=..CreateFromModel(model)
		set dataMapping.InstanceID=rowId
		do ##class(CIS.AN.BL.DataMapping).Store(dataMapping)
	}
	else
	{
		if ..#DEBUG=1 write "AIS: mapping admission: found mapping data:",dataMapping.InstanceID,!
		set instance=##class(CIS.AN.Admission).%OpenId(dataMapping.InstanceID)
		do ..Compare(model,instance)
	}
	if ..#DEBUG=1 write "AIS: mapping admission: end",!
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.HIS.Admission, instance As CIS.AN.Admission) As %Status
{
	set instance.EpisodeID=model.EpisodeID
	set instance.Patient=##class(CIS.AN.BL.Patient).GetInstance(model.PatientID)
	set instance.MedcareNo=model.MedcareNo
	set instance.Type=model.Type
	set instance.AdmDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.AdmDate,"")
	set instance.AdmTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.AdmTime,"")
	set instance.Department=model.DepartmentID
	set instance.Ward=model.WardID
	set instance.Bed=model.BedID
	set instance.VisitStatus=model.VisitStatus
	set instance.AdmReason=""
	set instance.DischargeDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.DischargeDate,"")
	set instance.DischargeTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.DischargeTime,"")
	
	set sc=instance.%Save()
	quit sc
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.HIS.Admission) As %String
{
	set instance=##class(CIS.AN.Admission).%New()
	
	set instance.EpisodeID=model.EpisodeID
	set instance.Patient=##class(CIS.AN.BL.Patient).GetInstance(model.PatientID)
	set instance.MedcareNo=model.MedcareNo
	set instance.Type=model.Type
	set instance.AdmDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.AdmDate,"")
	set instance.AdmTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.AdmTime,"")
	set instance.Department=model.DepartmentID
	set instance.Ward=model.WardID
	set instance.Bed=model.BedID
	set instance.VisitStatus=model.VisitStatus
	set instance.AdmReason=""
	set instance.DischargeDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.DischargeDate,"")
	set instance.DischargeTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.DischargeTime,"")
	
	set sc=instance.%Save()
	if $$$ISOK(sc)
	{
		quit instance.%Id()
	}
	else
	{
		quit ""
	}
}

}
