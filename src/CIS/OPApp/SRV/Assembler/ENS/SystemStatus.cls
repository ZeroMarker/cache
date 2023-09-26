Class CIS.OPApp.SRV.Assembler.ENS.SystemStatus Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// w ##class(CIS.OPApp.SRV.Assembler.ENS.SystemStatus).Query()
ClassMethod Query(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	if ..#DEBUG=1 write "OPApp:SystemStatus Query:",!
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		if params.RowId'=""
		{
			set opsId=params.RowId
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(params.RowId)
			set appOEOrderItemID=operSchedule.AppOrderItem
			
			set procedures=##class(CIS.OPApp.SRV.Assembler.OP.Procedure).Query(params)
			while (procedures.GetNext(.key))
			{
				set procedure=procedures.GetAt(key)
				if ..#DEBUG=1 write "OPApp:Procedure:",procedure.ToJSON().%ToJSON(),!
				if ##class(CIS.OPApp.DTO.ENS.Oper.SystemStatus).Match(procedure)
				{
					set instance=##class(CIS.OPApp.DTO.ENS.Oper.SystemStatus).CloneFromProcedure(procedure)
					set instance.OEOrdItemID=appOEOrderItemID
					set instance.ExamID=opsId
					if ..#DEBUG=1 write "OPApp:SystemStatus:",instance.ToJSON().%ToJSON(),!
					do collection.Insert(instance)
				}
			}
		}
	}
	
	quit collection
}

ClassMethod VerifyInput(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.OPApp.SRV.Assembler.ENS.Appointment).GetInstance(859)
ClassMethod GetInstance(rowId As %String) As CIS.OPApp.DTO.ENS.Oper.SystemStatus
{
}

}
