Class CIS.AN.SRV.Assembler.OP.Shift Extends %RegisteredObject
{

/// 数据表名
Parameter TableName = "CIS.AN.OperSchedule";

/// 外部系统
Parameter ExternalSystem = "OPApp";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// w ##class(CIS.AN.SRV.Assembler.OP.KeyTime).Query()
ClassMethod Query(params As CIS.AN.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		//查询Query，或者调用业务方法
		set opsId=""
		if (params.RowId'="")
		{
			set opsId=params.RowId
		}
		elseif (params.ApplicationID'="")
		{
			set opsId=params.ApplicationID
		}
		
		if opsId'=""
		{
			set rowId=""
			for
			{
				set rowId=$o(^CIS.AN.OperShiftI("IOPS",opsId,rowId))
				quit:rowId=""
				
				set instance=..GetInstance(rowId)
				do collection.Insert(instance)
			}
		}
	}
	
	quit collection
}

/// w ##class(CIS.AN.SRV.Assembler.OP.KeyTime).VerifyInput()
ClassMethod VerifyInput(params As CIS.AN.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.AN.SRV.Assembler.OP.KeyTime).GetInstance(4166)
ClassMethod GetInstance(rowId As %String) As CIS.AN.DTO.OP.Shift
{
	set instance=##class(CIS.AN.DTO.OP.Shift).%New()
	
	if ##class(CIS.AN.OperShift).%ExistsId(rowId)
	{
		set shift=##class(CIS.AN.OperShift).%OpenId(rowId)
		
		set instance.ApplicationID=shift.OperSchedule.%Id()
		set instance.HandOverCareProv=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstance(shift.ShiftCareProvID)
		set instance.TakeOverCareProv=##class(CIS.AN.SRV.Assembler.Base.CareProvider).GetInstance(shift.ReliefCareProvID)
		set instance.Type=shift.ShiftType
		set instance.TypeDesc=##class(CIS.AN.OperShift).ShiftTypeLogicalToDisplay(instance.Type)
		set instance.Note=shift.ShiftNote
		set instance.Date=##class(CIS.AN.COM.DateTime).ConvertToDate(shift.ShiftDate,"")
		set instance.Time=##class(CIS.AN.COM.DateTime).ConvertToTime(shift.ShiftTime,"")
		set instance.CareProvDeptID=shift.CareProvDept
		set instance.CareProvDept=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",shift.CareProvDept)
	}
	
	quit instance
}

}
