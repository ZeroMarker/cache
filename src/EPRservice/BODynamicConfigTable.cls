/// 名称：EPRservice.BODynamicConfigTable
/// 描述：电子病历维护程序角色表WebService接口
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRservice.BODynamicConfigTable Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DynamicConfigTable";

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   根据类名得到类的属性,类名对大小写敏感
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称|类型|数据库字段名|是否必须|描述,
/// test: d ##class(EPRservice.BLDynamicConfigTable).GetClassProperties("EPRmeta.SysOption")    
ClassMethod GetClassProperties(ClassName As %String, Spliter As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.BLDynamicConfigTable).GetClassProperties(ClassName, Spliter)
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   创建一个新对象，并将属性设置上
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(EPRservice.BLDynamicConfigTable).AddRecord("EPRmeta.SysOption", "Description=Description,OptionValue=OptionValue")    
ClassMethod AddRecord(ClassName As %String, Properties As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.BLDynamicConfigTable).AddRecord(ClassName, Properties)
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：        
/// test: d ##class(EPRservice.BLDynamicConfigTable).UpdateRecord("EPRmeta.SysOption", "61", "Description=Description1,OptionValue=OptionValue1")    
ClassMethod UpdateRecord(ClassName As %String, ID As %String, Properties As %String) [ WebMethod ]
{
	d ##class(EPRservice.BLDynamicConfigTable).UpdateRecord(ClassName, ID, Properties)
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   修改对象
/// Table：        
/// Input：        ClassName：类名 ID:主键 Properties: 属性=Value, 逗号分隔
/// Output：       
/// Return：          
ClassMethod DelRecord(ClassName As %String, ID As %String) [ WebMethod ]
{
	d ##class(EPRservice.BLDynamicConfigTable).DelRecord(ClassName, ID)
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(EPRservice.BLDynamicConfigTable).GetDBConfigProperties("EPRmeta.SysOption")    
ClassMethod GetDBConfigProperties(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.BLDynamicConfigTable).GetDBConfigProperties(ClassName)
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   删除配置表记录
/// Table：        
/// Input：        ID：RowId
/// Output：       
/// Return：        
/// test: d ##class(EPRservice.BLDynamicConfigTable).DelDBConfigRecord("EPRmeta.SysOption") 
ClassMethod DelDBConfigRecord(ClassName As %String) As %String [ WebMethod ]
{
	q ##class(EPRservice.BLDynamicConfigTable).DelDBConfigRecord(ClassName)
}

/// Creator：      LingChen
/// CreatDate：    2011-01-21
/// Description:   更新配置表记录
/// Table：        
/// Input：        ClassName：表名  Properties：勾选的属性
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: d ##class(EPRservice.BLDynamicConfigTable).UpdateDBConfigRecord("EPRmeta.SysOption", "Description") 
ClassMethod UpdateDBConfigRecord(TableName As %String, ConfigName As %String, Properties As %String, IniValue As %String) [ WebMethod ]
{
	d ##class(EPRservice.BLDynamicConfigTable).UpdateDBConfigRecord(TableName, ConfigName, Properties, IniValue)
}

/// 返回查询，将所有字段合并成一个字段 
/// Creator：      LingChen
/// CreatDate：    2011-01-26
/// Description:   查询
/// Table：        
/// Input：        TableName:传入所要查询的表名
///                Fields: 查询的字段，格式 Col1||分割符||Col2 ... 
/// Output：       EPRservice.dataset.QueryDynTableDataSet
/// Return：       
/// Others：       其它说明
///  
ClassMethod QueryDynTable(TableName As %String, Fields As %String, Filter As %String, Spliter As %String, StartIndex As %String, PagingSize As %String) As EPRservice.dataset.QueryDynTableDataSet [ WebMethod ]
{
	q ##class(EPRservice.BLDynamicConfigTable).QueryDynTable(TableName, Fields, Filter, Spliter, StartIndex, PagingSize)
}

/// 查询EPRmeta.DynamicConfigTable中所有的数据
/// Creator：      LingChen
/// CreatDate：    2011-01-26
/// Description:   查询
/// Table：        
/// Input：         
///                 
/// Output：       EPRservice.dataset.DynamicConfigTableDataSet
/// Return：       
/// Others：       其它说明
ClassMethod GetConfigTable() As EPRservice.dataset.DynamicConfigTableDataSet [ WebMethod ]
{
	Quit ##class(EPRservice.BLDynamicConfigTable).GetConfigTable()
}

}
