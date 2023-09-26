/// 名称: 身体部位维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-4
Class web.Entity.CT.OECBodySite Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECBodySite";

/// RowId号
Property BODSRowId As %String;

/// 代码
Property BODSCode As %String;

/// 描述
Property BODSDesc As %String;

}
