Import sqluser

Class web.CSSDHUI.System.BaseCodeType Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	查询基础数据、参数
/// Creator:	ljl
/// CreateDate:	2022-11-21
/// Table:	CSSD_BaseDataType
/// Input:	类型使用:"Y" 基础数据,"C"参数
/// Return:	RowId,Code,Description
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.BaseCodeType","SelectAll","")
Query SelectAll() As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Code,Description") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID, CSSDBDT_Code, CSSDBDT_Name, CSSDBDT_Remark FROM CSSD_BaseDataType "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("ID")
		s Code = Result.Data("CSSDBDT_Code")
		s Description = Result.Data("CSSDBDT_Name")
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
