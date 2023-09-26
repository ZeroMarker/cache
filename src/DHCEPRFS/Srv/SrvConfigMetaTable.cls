Class DHCEPRFS.Srv.SrvConfigMetaTable Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// /rameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvConfigMetaTable";

ClassMethod GetClassProperties(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLConfigMetaTable).GetClassProperties(ClassName)
}

ClassMethod AddRecord(ClassName As %String, Properties As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLConfigMetaTable).AddRecord(ClassName, Properties)
}

ClassMethod UpdateRecord(ClassName As %String, ID As %String, Properties As %String) [ WebMethod ]
{
	d ##class(DHCEPRFS.BL.BLConfigMetaTable).UpdateRecord(ClassName, ID, Properties)
}

ClassMethod DelRecord(ClassName As %String, ID As %String) [ WebMethod ]
{
	d ##class(DHCEPRFS.BL.BLConfigMetaTable).DelRecord(ClassName, ID)
}

ClassMethod GetDBConfigProperties(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLConfigMetaTable).GetDBConfigProperties(ClassName)
}

ClassMethod DelDBConfigRecord(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLConfigMetaTable).DelDBConfigRecord(ClassName)
}

ClassMethod UpdateDBConfigRecord(ClassName As %String, TableName As %String, ConfigName As %String, Properties As %String, IniValue As %String) [ WebMethod ]
{
	d ##class(DHCEPRFS.BL.BLConfigMetaTable).UpdateDBConfigRecord(ClassName, TableName, ConfigName, Properties, IniValue)
}

ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, StartIndex As %String, PagingSize As %String) As %XML.DataSet [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLConfigMetaTable).QueryDynTable(TableName, Fields, Filter, StartIndex, PagingSize)
}

ClassMethod GetConfigMetaTable() As %XML.DataSet [ WebMethod ]
{
	//q ##class(DHCEPRFS.BL.BLConfigMetaTable).GetConfigMetaTable()
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLConfigMetaTable:GetConfigMetaTableGB")
	d obj.SetArgs()
	q obj
}

ClassMethod Test() As %XML.DataSet [ WebMethod ]
{
	d ##class(DHCEPRFS.BL.BLConfigMetaTable).QueryDynTable("DHCEPRFS_META.MRItem","Code,Type,TypeParams","","10","300")
}

}
