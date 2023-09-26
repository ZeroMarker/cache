/// 名称：EMRservice.BODynamicConfigTable
/// 描述：电子病历维护程序角色表WebService接口
/// 编写者：yejian
/// 编写日期: 2010-10-22
Class EMRservice.BODynamicConfigTable Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DynamicConfigTable";

ClassMethod GetClassProperties(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLDynamicConfigTable).GetClassProperties(ClassName)
}

ClassMethod AddRecord(ClassName As %String, Properties As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord(ClassName, Properties)
}

ClassMethod UpdateRecord(ClassName As %String, ID As %String, Properties As %String) [ WebMethod ]
{
	d ##class(EMRservice.BL.BLDynamicConfigTable).UpdateRecord(ClassName, ID, Properties)
}

ClassMethod DelRecord(ClassName As %String, ID As %String) [ WebMethod ]
{
	d ##class(EMRservice.BL.BLDynamicConfigTable).DelRecord(ClassName, ID)
}

ClassMethod GetDBConfigProperties(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLDynamicConfigTable).GetDBConfigProperties(ClassName)
}

ClassMethod DelDBConfigRecord(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLDynamicConfigTable).DelDBConfigRecord(ClassName)
}

ClassMethod UpdateDBConfigRecord(ClassName As %String, TableName As %String, ConfigName As %String, Properties As %String, IniValue As %String) [ WebMethod ]
{
	d ##class(EMRservice.BL.BLDynamicConfigTable).UpdateDBConfigRecord(ClassName, TableName, ConfigName, Properties, IniValue)
}

ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, StartIndex As %String, PagingSize As %String) As %XML.DataSet [ WebMethod ]
{
	q ##class(EMRservice.BL.BLDynamicConfigTable).QueryDynTable(TableName, Fields, Filter, StartIndex, PagingSize)
}

ClassMethod GetConfigMetaTable() As %XML.DataSet [ WebMethod ]
{
	q ##class(EMRservice.BL.BLDynamicConfigTable).GetConfigMetaTable()
}

ClassMethod Test() As %XML.DataSet [ WebMethod ]
{
	d ##class(EMRservice.BL.BLDynamicConfigTable).QueryDynTable("DHCEPRFS_META.MRItem","Code,Type,TypeParams","","10","300")
}

}
