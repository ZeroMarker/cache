Class CIS.OPApp.SRV.Sync.OP.Appointment Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(struct As CIS.OPApp.DTO.ENS.Response.Struct) As %Status
{
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.OP.Appointment) As %Status
{
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.OP.Appointment, instance As CIS.AN.OperSchedule) As %Status
{
}

ClassMethod Log(loggingMessage As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.OP.Appointment) As %Status
{
}

}
