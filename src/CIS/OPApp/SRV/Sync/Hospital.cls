Class CIS.OPApp.SRV.Sync.Hospital Extends %RegisteredObject
{

ClassMethod Store(struct As CIS.OPApp.DTO.ENS.Response.Struct) As %Status
{
	while struct.Models.Next(.key)
	{
		set model=struct.Models.GetAt(key)
		if model.InstanceOf("CIS.OPApp.DTO.Base.Hospital") do ..Mapping(model)
	}
	
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.Base.Hospital) As %Status
{
	set ExternalID=model.RowId
	set Description=model.Description
	
	set mappingId=$o(^CF.AN.HospitalI("IHosp"," "_ExternalID,""))
	if mappingId'=""
	{
		set mappingInstance=##class(CF.AN.Hospital).%OpenId(mappingId)
		do ..Compare(model,mappingInstance)
	}
	else
	{
		do ..CreateFromModel(model)
	}
	
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.Base.Hospital, instance As CF.AN.Hospital) As %Status
{
	set different=0
	if instance.ANDept'=model.Description set different=1,instance.ANDept=model.Description
	
	if different
	{
		set sc=instance.%Save()
		do ..Log("日志消息")
	}
}

ClassMethod Log(loggingMessage As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.Base.Hospital) As %Status
{
}

}
