Class CIS.OPApp.SRV.Sync.OP.Shift Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "OPApp: storing shifts start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.OPApp.DTO.OP.Shift") do ..Mapping(model)
	}
	if ..#DEBUG=1 write "OPApp: storing shifts start...",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.OP.Operation) As %Status
{
	set rowId=..CreateFromModel(model)
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.OP.Shift, instance As CIS.AN.OperShift) As %Status
{
	quit $$$OK
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.OP.Shift) As %Status
{
	set instance=##class(CIS.AN.OperShift).%New()
	
	set instance.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(model.ApplicationID)
	set instance.ShiftCareProvID=model.HandOverCareProv.RowId
	set instance.ReliefCareProvID=model.TakeOverCareProv.RowId
	set instance.ShiftType=model.Type
	set instance.ShiftNote=model.Note
	set instance.ShiftDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(model.Date,"")
	set instance.ShiftTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(model.Time,"")
	set instance.CareProvDept=model.CareProvDeptID
	
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

ClassMethod Clear(opsId As %String) As %Status
{
	&sql(delete from CIS_AN.OperShift where OperSchedule=:opsId)
	if (SQLCODE'=0)&(SQLCODE'=100) quit $$$ERROR("")
	quit $$$OK
}

}
