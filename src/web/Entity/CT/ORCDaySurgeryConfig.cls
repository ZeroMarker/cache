/// 日间手术参数配置表
/// 基础数据平台-李可凡
/// 2021-05-10
Class web.Entity.CT.ORCDaySurgeryConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.ORCDaySurgeryConfig";

/// 日间手术参数配置RowId
Property DSCRowId As %String;

/// 代码
Property DSCCode As %String;

/// 名称
Property DSCName As %String;

/// 内容
Property DSCContent As %String;

/// 参数说明
Property DSCExplain As %String;

}
