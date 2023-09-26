Class DHCEPRFS.Srv.SrvMetaLifeCycle Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "SrvMetaLifeCycle";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Desc:查询Meta表数据
ClassMethod QueryMetaTable(TableName As %String) As %XML.DataSet [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).QueryMetaTable(TableName)
}

/// Desc:增加记录并创建日志
ClassMethod AddRecord(ATableName As %String, AActUserType As %String, AActUserCode As %String, AProperties As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).AddRecord(ATableName,AActUserType,AActUserCode,AProperties)
}

/// Desc:更新记录并创建日志
ClassMethod UpdateRecord(ATableName As %String, AFieldRowID As %String, AActUserType As %String, AActUserCode As %String, AProperties As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).UpdateRecord(ATableName,AFieldRowID,AActUserType,AActUserCode,AProperties)
}

/// Desc:删除记录并创建日志
ClassMethod DelRecord(ATableName As %String, AFieldRowID As %String, AActUserType As %String, AActUserCode As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).DelRecord(ATableName,AFieldRowID,AActUserType,AActUserCode)
}

/// Desc:查询表日志信息
ClassMethod GetMetaLCManageLog(TableName As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMetaLifeCycle:GetMetaLCManageLog")
	d ds.SetArgs(TableName)
	q ds
}

/// Desc:查询表指定属性日志信息
ClassMethod GetPropertyLog(TableName As %String, FieldRowID As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMetaLifeCycle:GetPropertyLog")
	d ds.SetArgs(TableName,FieldRowID)
	q ds
}

/// Desc:查询配置表
ClassMethod GetMetaLCConfig() As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMetaLifeCycle:GetMetaLCConfig")
	q ds
}

/// Desc:更新配置表
ClassMethod UpdateMetaLCConfig(TableName As %String, ConfigName As %String, ClassName As %String, QueryFunction As %String, IsActive As %String, Fields As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).UpdateMetaLCConfig(TableName,ConfigName,ClassName,QueryFunction,IsActive,Fields)
}

/// Desc:获得类中的Query名
ClassMethod GetClassQueries(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetClassQueries(ClassName)
}

/// Desc:获得类的属性
ClassMethod GetClassProperties(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetClassProperties(ClassName)
}

/// Desc:对当前时间点所有配置生命周期管理的表创建备份
ClassMethod CreateMetaBackups() As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMetaLifeCycle).CreateMetaBackups()
}

}
