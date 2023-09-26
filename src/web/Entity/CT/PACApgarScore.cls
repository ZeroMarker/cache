/// Function:新生儿评分(阿氏评分) PAC_ApgarScore
/// Creator: 基础数据平台组 孙凤超
/// CreateDate:2012-08-29
Class web.Entity.CT.PACApgarScore Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACApgarScore";

Property APGSRowId As %String;

/// RowId
Property APGSCode As %String;

/// 代码
Property APGSDesc As %String;

/// 描述
Property APGSNationalCode As %String;

Property APGSCount As %String;

}
