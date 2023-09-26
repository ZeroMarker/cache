Class CIS.OPApp.SRV.Assembler.Base.CareProvider Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

ClassMethod Query(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	if ..VerifyInput(params)
	{
		//查询Query，或者调用业务方法
		
		//获取数据
		//调用Compose方法
	}
}

ClassMethod VerifyInput(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %Boolean
{
	if params.EpisodeID=""
	{
		if params.StartDate="" quit 0
		if params.EndDate="" quit 0
	}
	
	quit 1
}

/// w ##class(CIS.OPApp.SRV.Assembler.Base.CareProvider).GetInstance(2323)
ClassMethod GetInstance(rowId As %String) As CIS.OPApp.DTO.Base.CareProvider
{
	set instance=##class(CIS.OPApp.DTO.Base.CareProvider).%New()
	
	if ##class(User.CTCareProv).%ExistsId(rowId)
	{
		set careprov=##class(User.CTCareProv).%OpenId(rowId)
		
		set instance.RowId=rowId
		set instance.Name=careprov.CTPCPDesc
		set instance.Alias=careprov.CTPCPOtherName
		set instance.DepartmentID=careprov.CTPCPCTLOCDR
		set instance.Department=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",instance.DepartmentID)
	}
	elseif rowId'=""
	{
		set instance.RowId=rowId
		set instance.Name=rowId
	}
	
	quit instance
}

}
