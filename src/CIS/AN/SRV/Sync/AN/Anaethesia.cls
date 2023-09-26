Class CIS.AN.SRV.Sync.AN.Anaethesia Extends %RegisteredObject
{

ClassMethod Store(models As %ListOfObjects) As %Status
{
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.AN.DTO.AN.Anaesthesia") do ..Mapping(model)
	}
	quit $$$OK
}

ClassMethod Mapping(model As CIS.AN.DTO.AN.Anaesthesia) As %Status
{
	set opsId=model.ApplicationID
	set instance=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
	do ..Compare(model,instance)
	do ..CompatibleWithOldVersion(model)
	
	quit $$$OK
}

ClassMethod Compare(model As CIS.AN.DTO.AN.Anaesthesia, instance As CIS.AN.Anaesthesia) As %Status
{
	set instance.AnaMethod=model.AnaMethodID
	
	set sc=instance.%Save()
	quit sc
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.AN.DTO.AN.Anaesthesia) As %String
{
	quit ""
}

/// 兼容旧版本
ClassMethod CompatibleWithOldVersion(model As CIS.AN.DTO.AN.Anaesthesia) As %Status
{
	kill anaesthesia
	set anaesthesia("RowId")=model.OldID
    set anaesthesia("ParentRowId")=model.EpisodeID
    set saveResult=##class(CIS.AN.BL.OperApplication).SaveORAnaesthesia(.anaesthesia)
}

}
