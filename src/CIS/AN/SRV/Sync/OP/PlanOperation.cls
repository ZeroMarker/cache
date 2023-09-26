Class CIS.AN.SRV.Sync.OP.PlanOperation Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "AIS: storing planoperations start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.AN.DTO.OP.Operation") do ..Mapping(model)
	}
	if ..#DEBUG=1 write "AIS: storing planoperations end",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.AN.DTO.OP.Operation) As %Status
{
	set rowId=..CreateFromModel(model)
	quit $$$OK
}

ClassMethod Compare(model As CIS.AN.DTO.OP.Operation, instance As CIS.AN.PlanOperList) As %Status
{
	quit $$$OK
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.AN.DTO.OP.Operation) As %Status
{
	set instance=##class(CIS.AN.PlanOperList).%New()
	
	set instance.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(model.ApplicationID)
	set instance.Operation=model.OperNameID
	set instance.OperNote=model.Note
	set instance.SurgeonExpert=model.ExternalExpert
	set instance.OperClass=model.OperCategoryID
	set instance.BladeType=model.BladeTypeID
	set instance.BodySite=model.BodySiteID
	set instance.SurgeonDeptID=model.SurgicalDepartmentID
	set instance.Surgeon=model.Surgeon.RowId
	
	set assistantList="",assistant=""
	while (model.Assistants.GetNext(.key))
	{
		set assistant=model.Assistants.GetAt(key)
		set assistantList=assistantList_$lb(assistant.RowId)
	}
	
	set instance.Assistant=$LISTTOSTRING(assistantList,",")
	
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
	&sql(delete from CIS_AN.PlanOperList where OperSchedule=:opsId)
	if (SQLCODE'=0)&(SQLCODE'=100) quit $$$ERROR("")
	quit $$$OK
}

}
