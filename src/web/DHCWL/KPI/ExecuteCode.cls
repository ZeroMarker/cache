Class web.DHCWL.KPI.ExecuteCode Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// s json=##class(web.DHCWL.KPI.ExecuteCode).GetExecuteCode()
ClassMethod GetExecuteCode(type = "KPI", start = 1, end = 3) As DHCWL.util.Json
{
	n (type,start,end)
	s jsonPros="ExeCodeWrite,ExeCodeCall,ExeCodeVersion,ExcCodeCUDate,ExeCodeCreator,ExcCodeDescription"
	s sqlField=##class(DHCWL.util.GetSetService).MapFildFromClassProByStr("DHCWL.MKPI.ExecuteCode",jsonPros)
	s tableName=##class(DHCWL.util.GetSetService).GetTableName("DHCWL.MKPI.ExecuteCode")
	s sql="select "_sqlField_" from "_tableName_" where ExeCode_Type='"_type_"'"
	w sql,!
	q ##class(DHCWL.util.GetSetService).GetJsonBySQL(sql,start,end,jsonPros)
}

}
