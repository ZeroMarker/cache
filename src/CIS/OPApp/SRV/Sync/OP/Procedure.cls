Class CIS.OPApp.SRV.Sync.OP.Procedure Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "OPApp: storing procedures start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.OPApp.DTO.OP.Procedure") 
		{
			if model.Validate(.message) do ..Mapping(model)
		}
	}
	if ..#DEBUG=1 write "OPApp: storing procedures end",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.OP.Procedure) As %Status
{
	do ..CreateFromModel(model)
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.OP.Procedure, instance As CIS.AN.SurgicalProcedure) As %Status
{
	quit $$$OK
}

ClassMethod Log(loggingMessage As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.OP.Procedure) As %Status
{
	set ret=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureByDT(model.ApplicationID,model.Code,model.UserID,model.Date_" "_model.Time,model.ActionCode)
	quit $$$OK
}

}
