/// 名称: 科室列表维护
/// 描述: 实体类
/// 编写者：基础数据平台组-孙凤超
/// 编写日期: 2013-5-31 LL_RowId LL_Code LL_Desc 
Class web.Entity.CT.CTLocationList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLocationList";

/// RowId
Property LLRowId As %String;

/// 代码
Property LLCode As %String;

/// 描述
Property LLDesc As %String;

}
