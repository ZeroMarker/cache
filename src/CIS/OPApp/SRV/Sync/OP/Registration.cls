Class CIS.OPApp.SRV.Sync.OP.Registration Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Store(models As %ListOfObjects) As %Status
{
	if ..#DEBUG=1 write "OPApp: storing arrangements start...",!
	while models.GetNext(.key)
	{
		set model=models.GetAt(key)
		if model.InstanceOf("CIS.OPApp.DTO.OP.Registration") 
		{
			if model.Validate(.message) do ..Mapping(model)
		}
	}
	if ..#DEBUG=1 write "OPApp: storing registrations end",!
	quit $$$OK
}

ClassMethod Mapping(model As CIS.OPApp.DTO.OP.Registration) As %Status
{
	if ..#DEBUG=1 write "OPApp: mapping registration: start...",!
	set dataMapping=##class(CIS.OPApp.DTO.Base.DataMapping).%New()
	set dataMapping.TableName="CIS.AN.OperSchedule"
	set dataMapping.ExternalSystem="AIS"
	set dataMapping.InstanceID=model.ApplicationID
	set dataMapping.ExternalID=##class(CIS.OPApp.BL.DataMapping).GetExternalID(dataMapping.TableName,dataMapping.InstanceID,dataMapping.ExternalSystem)
	
	set instance=##class(CIS.AN.OperSchedule).%OpenId(dataMapping.InstanceID)
	
	set dataMapping.ExternalID=model.ExternalID
	do ##class(CIS.OPApp.BL.DataMapping).Store(dataMapping)
	
	do ..Compare(model,instance)
	
	if ..#DEBUG=1 write "OPApp: mapping registration: end",!
	quit $$$OK
}

ClassMethod Compare(model As CIS.OPApp.DTO.OP.Registration, instance As CIS.AN.OperSchedule) As %Status
{
	if ##class(CF.AN.Location).%ExistsId(model.OperRoomID)
	{
		set instance.OperRoom=##class(CF.AN.Location).%OpenId(model.OperRoomID)
	}
	set instance.OperSeq=model.OperSeq
	
	set instance.OperPosition=model.OperPositionID
	set instance.PostDiagnosis=model.PostDiagnosisID
   	
   	set nurseList="",nurse=""
	while (model.ScrubNurses.GetNext(.key))
	{
		set nurse=model.ScrubNurses.GetAt(key)
		set nurseList=nurseList_$lb(nurse.RowId)
	}
	set instance.ScrubNurse=$LISTTOSTRING(nurseList,",")
	
	set nurseList="",nurse=""
	while (model.CirculatingNurses.GetNext(.key))
	{
		set nurse=model.CirculatingNurses.GetAt(key)
		set nurseList=nurseList_$lb(nurse.RowId)
	}
	set instance.CircualNurse=$LISTTOSTRING(nurseList,",")
	
	if model.StatusCode=""
	{
		set instance.Status=##class(CIS.AN.BL.OperStatus).GetInstance("Finish")
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
	
		set operations=##class(%ListOfObjects).%New()
		while(model.ActualOperations.GetNext(.key))
		{
			set operation=model.ActualOperations.GetAt(key)
			set operation.ApplicationID=rowId
			do operations.Insert(operation)
		}
		do ##class(CIS.OPApp.SRV.Sync.OP.Operation).Clear(rowId)
		do ##class(CIS.OPApp.SRV.Sync.OP.Operation).Store(operations)
		
		do ##class(CIS.OPApp.SRV.Sync.AN.Anaethesia).Mapping(model)
		
		set procedures=##class(%ListOfObjects).%New()
		while(model.Procedures.GetNext(.key))
		{
			set procedure=model.Procedures.GetAt(key)
			set procedure.ApplicationID=rowId
			do procedures.Insert(procedure)
		}
		do ##class(CIS.OPApp.SRV.Sync.OP.Procedure).Store(procedures)
		
		set shifts=##class(%ListOfObjects).%New()
		while(model.Shifts.GetNext(.key))
		{
			set shift=model.Shifts.GetAt(key)
			set shift.ApplicationID=rowId
			do shifts.Insert(shift)
		}
		do ##class(CIS.OPApp.SRV.Sync.OP.Shift).Clear(rowId)
		do ##class(CIS.OPApp.SRV.Sync.OP.Shift).Store(shifts)
		
		do ..TriggerEvent(rowId)
		// 当前先不考虑兼容旧版本
		//do ..CompatibleWithOldVersion(model)
		quit rowId
	}
	
	quit sc
}

ClassMethod Log(loggingMessage As %String) As %Status
{
}

ClassMethod CreateFromModel(model As CIS.OPApp.DTO.OP.Registration) As %Status
{
}

/// 兼容旧版本
ClassMethod CompatibleWithOldVersion(model As CIS.OPApp.DTO.OP.Registration) As %Status
{
	quit $$$OK
}

ClassMethod TriggerEvent(opsId) As %Status
{
	try
	{
		set args=##class(CIS.OPApp.DTO.Event.Args.OnOperRegister).%New()
		set args.RowId=opsId
		
		set sc=##class(CIS.OPApp.SRV.Event.OnOperRegister).Trigger(args)
	}
	catch(e)
	{
		//write e.DisplayString(),!
	}
	quit $$$OK
}

}
