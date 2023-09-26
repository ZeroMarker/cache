Class CIS.AN.SRV.Sync.OP.Infection Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(struct As CIS.AN.DTO.ENS.Response.Struct) As %Status
{
	quit $$$OK
}

ClassMethod Mapping(model As CIS.AN.DTO.OP.Appointment) As %Status
{
	quit $$$OK
}

ClassMethod Compare(model As CIS.AN.DTO.OP.Infection, instance As CIS.AN.OperSchedule) As %Status
{
	set instance.HbsAg=$s(model.HBsAg="阳性":"+",model.HBsAg="阴性":"-",model.HBsAg="已查未归":"UR",1:"N")
   	set instance.HcvAb=$s(model.HCVAb="阳性":"+",model.HCVAb="阴性":"-",model.HCVAb="已查未归":"UR",1:"N")
   	set instance.HivAb=$s(model.HivAb="阳性":"+",model.HivAb="阴性":"-",model.HivAb="已查未归":"UR",1:"N")
   	set instance.Syphilis=$s(model.TPAb="阳性":"+",model.TPAb="阴性":"-",model.TPAb="已查未归":"UR",1:"N")
   	set instance.MDROS=$s(model.MDROS="阳性":"+",model.MDROS="阴性":"-",model.MDROS="已查未归":"UR",1:"N")
	
	set sc=instance.%Save()
	quit sc
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.AN.DTO.OP.Infection) As %Status
{
	quit ""
}

}
