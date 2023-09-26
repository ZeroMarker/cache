Class CIS.OPApp.SRV.Sync.AN.Anaethesia Extends %RegisteredObject
{

/// if debug is 1, then  write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.OP.Registration) As %Status
{
	set instance=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(model.RowId)
	do ..Compare(model,instance)
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.OP.Registration, instance As CIS.AN.Anaesthesia) As %Status
{
	set instance.AnaMethod=model.AnaMethodID
	
	set instance.AnaExpert=model.AnaDirector.RowId
	set instance.Anesthesiologist=model.Anaesthetist.RowId
	
	set doctorList="",doctor=""
	while (model.AnaAssistants.GetNext(.key))
	{
		set doctor=model.AnaAssistants.GetAt(key)
		set doctorList=doctorList_$lb(doctor.RowId)
	}
	set instance.AnaAssistant=$LISTTOSTRING(doctorList,",")
	
	set instance.AreaInDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.AreaIn.ToDateTime())
	set instance.TheatreInDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.RoomIn.ToDateTime())
	set instance.AnaStartDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.AnaStart.ToDateTime())
	set instance.TubeInDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.TubeIn.ToDateTime())
	set instance.OperStartDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.OperStart.ToDateTime())
	set instance.OperFinishDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.OperEnd.ToDateTime())
	set instance.TubeOutDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.TubeOut.ToDateTime())
	set instance.AnaFinishDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.AnaEnd.ToDateTime())
	set instance.TheatreOutDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.RoomOut.ToDateTime())
	set instance.PACUInDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.PACUIn.ToDateTime())
	set instance.PACUOutDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.PACUOut.ToDateTime())
	set instance.AreaOutDT=##class(CIS.AN.COM.DateTime).StandardizeTimeStamp(model.AreaOut.ToDateTime())
	
	do instance.%Save()
	quit $$$OK
}

ClassMethod Log(message As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.OP.Registration) As %Status
{
}

}
