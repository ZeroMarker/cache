/// EPRservice.Query.BOExportTables
Class EPRservice.Query.BOExportTables Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.254.100/trakcare/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOExportTables";

ClassMethod ClearData(argTableName As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).ClearData(argTableName)
}

ClassMethod DelClassGlobal(argClassName As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).DelClassGlobal(argClassName)
}

ClassMethod DelCompiledClass(argClassName As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).DelCompiledClass(argClassName)
}

/// TODO: add arguments and implementation.
/// Test
ClassMethod Delete(argId As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).Delete(argId)
}

ClassMethod GenerateTable(argTableName As %String, argNamespace As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).GenerateTable(argTableName,argNamespace)
}

ClassMethod GetAllTables() As EPRservice.Query.DSExportTables [ WebMethod ]
{
 Set result=##class(EPRservice.Query.DSExportTables).%New()
 Quit result
}

ClassMethod GetExportHistory(argTableName As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).GetExportHistory(argTableName)
}

ClassMethod GetTableByName(argTableName As %String) As EPRservice.Query.ExportTables [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).GetTableByName(argTableName)
}

ClassMethod Insert(argExportTable As EPRservice.Query.ExportTables) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).Insert(argExportTable)
}

ClassMethod SetExportHistory(argTableName As %String, argHistory As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.Query.ExportTables).SetExportHistory(argTableName,argHistory)
}

}
