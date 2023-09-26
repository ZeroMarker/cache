/// 名称:电子病历-过敏严重程度实体类
/// 编写者:基础平台组 - 孙凤超
/// 编写日期:2013-9-16
Class web.Entity.CT.PACAllergySeverity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PAC_AllergySeverity";

Property ALRGSEVRowId As %String;

Property ALRGSEVCode As %String;

Property ALRGSEVDesc As %String;

Property ALRGSEVDateFrom As %String;

Property ALRGSEVDateTo As %String;

/// 优先级
Property ALRGSEVPriority As %String;

}
