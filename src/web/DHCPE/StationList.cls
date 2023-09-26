Import SQLUser

/// 创建时间		：
/// 创建人		：xuwm
/// 存在系统		：体检系统 测试
/// 关联数据		: DHC_PE_Station
/// 索引			: ^DHCPEST(RowId)
/// 主要功能		：
/// 主要功能		："站点"操作 插入 删除 更改 
/// 最后修改时间	：
/// 最后修改人	：
/// 完成
Class web.DHCPE.StationList Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

/// d ##Class(%ResultSet).RunQuery("web.DHCPE.StationList","StationList")
Query StationList() As %SQLQuery(ROWSPEC = "站点名称:%String, 站点编码:%String, 站点ID:%String")
{
	SELECT ST_Desc, ST_Code,ST_RowId  
	FROM DHC_PE_Station
}

}
