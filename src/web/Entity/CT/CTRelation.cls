/// 名称: 家庭关系维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTRelation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTRelation";

/// RowId号
Property CTRLTRowId As %String;

/// 代码
Property CTRLTCode As %String;

/// 描述
Property CTRLTDesc As %String;

/// 开始日期
Property CTRLTDateFrom As %String;

/// 结束日期
Property CTRLTDateTo As %String;

}
