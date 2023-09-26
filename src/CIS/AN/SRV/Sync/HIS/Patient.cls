Class CIS.AN.SRV.Sync.HIS.Patient Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "AIS: storing patients start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.AN.DTO.HIS.Person") do ..Mapping(model)
	}
	if ..#DEBUG=1 write "AIS: storing patients end",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.AN.DTO.HIS.Person) As %Status
{
	if ..#DEBUG=1 write "AIS: mapping patient: start...",!
	set dataMapping=##class(CIS.AN.DTO.Base.DataMapping).%New()
	set dataMapping.TableName="CIS.AN.Patient"
	set dataMapping.ExternalSystem="OPApp"
	set dataMapping.ExternalID=model.PatientID
	set dataMapping.InstanceID=##class(CIS.AN.BL.DataMapping).GetInstanceID(dataMapping.TableName,dataMapping.ExternalID,dataMapping.ExternalSystem)
	
	if (dataMapping.InstanceID="")
	{
		if ..#DEBUG=1 write "AIS: mapping patient: can not find mapping data",!
		set rowId=..CreateFromModel(model)
		set dataMapping.InstanceID=rowId
		do ##class(CIS.AN.BL.DataMapping).Store(dataMapping)
	}
	else
	{
		if ..#DEBUG=1 write "AIS: mapping patient: found mapping data:",dataMapping.InstanceID,!
		set instance=##class(CIS.AN.Patient).%OpenId(dataMapping.InstanceID)
		do ..Compare(model,instance)
	}
	if ..#DEBUG=1 write "AIS: mapping patient: end",!
	quit $$$OK
}

ClassMethod Compare(model As CIS.AN.DTO.HIS.Person, instance As CIS.AN.Patient) As %Status
{
	set instance.RegNo=model.RegNo
	set instance.PatientID=model.PatientID
	set instance.CardID=model.CardID
	set instance.CertID=model.CertID
	set instance.FullName=model.Name
	set instance.Alias=model.Alias
	set instance.InpatientNo=model.PatientID
	set instance.OutpatientNo=model.PatientID
	set instance.DOB=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.Birthday,"")
	set instance.Sex=$s(model.Sex["男":##class(CIS.AN.BL.Sex).Male(),model.Sex["女":##class(CIS.AN.BL.Sex).Female(),1:##class(CIS.AN.BL.Sex).Unknown())
	set instance.TelephoneNo=model.TelephoneNo
	set instance.SecretLevel=model.SecretLevel
	set instance.SecretCode=model.SecretCode
	
	set sc=instance.%Save()
	
	quit sc
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.AN.DTO.HIS.Person) As %String
{
	set instance=##class(CIS.AN.Patient).%New()
	
	set instance.RegNo=model.RegNo
	set instance.PatientID=model.PatientID
	set instance.CardID=model.CardID
	set instance.CertID=model.CertID
	set instance.FullName=model.Name
	set instance.Alias=model.Alias
	set instance.InpatientNo=model.PatientID
	set instance.OutpatientNo=model.PatientID
	set instance.DOB=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.Birthday,"")
	set instance.Sex=$s(model.Sex["男":##class(CIS.AN.BL.Sex).Male(),model.Sex["女":##class(CIS.AN.BL.Sex).Female(),1:##class(CIS.AN.BL.Sex).Unknown())
	set instance.Active="Y"
	set instance.TelephoneNo=model.TelephoneNo
	set instance.SecretLevel=model.SecretLevel
	set instance.SecretCode=model.SecretCode
	
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
