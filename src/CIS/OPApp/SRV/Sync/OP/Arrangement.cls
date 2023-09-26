Class CIS.OPApp.SRV.Sync.OP.Arrangement Extends %RegisteredObject
{

/// if debug is 1, then if ..#DEBUG=1 write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "OPApp: storing arrangements start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.OPApp.DTO.OP.Arrangement") 
		{
			if model.Validate(.message) do ..Mapping(model)
		}
	}
	if ..#DEBUG=1 write "OPApp: storing arrangements end",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.OP.Arrangement) As %Status
{
	if ..#DEBUG=1 write "OPApp: mapping arrangement: start... ID:",model.ApplicationID,!
	set dataMapping=##class(CIS.OPApp.DTO.Base.DataMapping).%New()
	set dataMapping.TableName="CIS.AN.OperSchedule"
	set dataMapping.ExternalSystem="AIS"
	set dataMapping.InstanceID=model.ApplicationID
	set dataMapping.ExternalID=##class(CIS.OPApp.BL.DataMapping).GetExternalID(dataMapping.TableName,dataMapping.InstanceID,dataMapping.ExternalSystem)
	
	set instance=##class(CIS.AN.OperSchedule).%OpenId(dataMapping.InstanceID)
	
	//if (instance.EpisodeID'=model.EpisodeID) quit $$$ERROR("EpisodeID can not match instance!")
	
	set dataMapping.ExternalID=model.ExternalID
	do ##class(CIS.OPApp.BL.DataMapping).Store(dataMapping)
	
	set sc=..Compare(model,instance)
	if ..#DEBUG=1 write "OPApp: status:",$System.Status.GetErrorText(sc),!
	if ..#DEBUG=1 write "OPApp: mapping arrangement: end",!
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.OP.Arrangement, instance As CIS.AN.OperSchedule) As %Status
{
	if ##class(CF.AN.Location).%ExistsId(model.OperRoomID)
	{
		set instance.ArrOperRoom=##class(CF.AN.Location).%OpenId(model.OperRoomID)
		set instance.OperRoom=instance.ArrOperRoom
	}
	else
	{
		set instance.ArrOperRoom=""
		set instance.OperRoom=""
	}
	
	set instance.ArrOperSeq=model.OperSeq
	set instance.OperSeq=model.OperSeq
   	
   	set nurseList="",nurse=""
	while (model.ScrubNurses.GetNext(.key))
	{
		set nurse=model.ScrubNurses.GetAt(key)
		set nurseList=nurseList_$lb(nurse.RowId)
	}
	set instance.ArrScrubNurse=$LISTTOSTRING(nurseList,",")
	set instance.ScrubNurse=instance.ArrScrubNurse
	
	set nurseList="",nurse=""
	while (model.CirculatingNurses.GetNext(.key))
	{
		set nurse=model.CirculatingNurses.GetAt(key)
		set nurseList=nurseList_$lb(nurse.RowId)
	}
	set instance.ArrCircualNurse=$LISTTOSTRING(nurseList,",")
	set instance.CircualNurse=instance.ArrCircualNurse
	
	if model.StatusCode=""
	{
		if (instance.Status.Code="Application")||(instance.Status.Code="Audit") set instance.Status=##class(CIS.AN.BL.OperStatus).GetInstance("Arrange")
	}
	else
	{
		set instance.Status=##class(CIS.AN.BL.OperStatus).GetInstance(model.StatusCode)
	}
	
	set sc=instance.%Save()
	if $$$ISOK(sc)
	{
		set rowId=instance.%Id()
		set model.RowId=rowId
		
		set procedures=##class(%ListOfObjects).%New()
		while(model.Procedures.GetNext(.key))
		{
			set procedure=model.Procedures.GetAt(key)
			set procedure.ApplicationID=rowId
			do procedures.Insert(procedure)
		}
		do ##class(CIS.OPApp.SRV.Sync.OP.Procedure).Store(procedures)
		
		// 当前先不考虑兼容旧版本
		//do ..CompatibleWithOldVersion(model)
	}
	
	quit sc
}

ClassMethod Log(loggingMessage As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.OP.Arrangement) As %Status
{
}

/// 兼容旧版本
ClassMethod CompatibleWithOldVersion(model As CIS.OPApp.DTO.OP.Appointment) As %Status
{
	if ..#DEBUG=1 write "AIS: compatible with old version(4.x): start...",!
	set rowId=model.RowId
	
	if ..#DEBUG=1 write "AIS: compatible with old version(4.x): end",!
	quit $$$OK
}

}
