Class CIS.OPApp.SRV.Assembler.OP.Procedure Extends %RegisteredObject
{

/// 数据表名
Parameter TableName = "CIS.AN.SurgicalProcedure";

/// 外部系统
Parameter ExternalSystem = "OPApp";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Query(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		//查询Query，或者调用业务方法
		set list=""
		if (params.RowId'="")
		{
			set opsId=params.RowId
			set rowId=""
			for
			{
				set rowId=$o(^CIS.AN.SurgicalProcedureI("IOPS",opsId,rowId))
				quit:rowId=""
				
				do collection.Insert(..GetInstance(rowId))
		    }
		}
	}
	
	quit collection
}

ClassMethod VerifyInput(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.AN.DTO.OP.Appointment).GetInstance(4166)
ClassMethod GetInstance(rowId As %String) As CIS.OPApp.DTO.OP.Procedure
{
	set instance=##class(CIS.OPApp.DTO.OP.Procedure).Create()
	set surgicalProcedure=##class(CIS.AN.SurgicalProcedure).%OpenId(rowId)
	
	set instance.Code=surgicalProcedure.ProcedureCode
	set instance.Description=##class(CIS.AN.SurgicalProcedure).ProcedureCodeLogicalToDisplay(surgicalProcedure.ProcedureCode)
	set instance.Date=##class(CIS.AN.COM.DateTime).ConvertToDate(surgicalProcedure.ActionDate,"")
	set instance.Time=##class(CIS.AN.COM.DateTime).ConvertToTime(surgicalProcedure.ActionTime,"")
	set instance.UserID=surgicalProcedure.ActionUser
	set instance.User=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",instance.UserID)
	set instance.ActionCode=surgicalProcedure.ActionWay
	set instance.Action=##class(CIS.AN.SurgicalProcedure).ActionWayLogicalToDisplay(surgicalProcedure.ActionWay)
	set instance.Note=surgicalProcedure.ActionNote
	set instance.Seq=surgicalProcedure.ActionSeq
	
	quit instance
}

}
