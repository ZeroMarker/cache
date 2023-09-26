/// 名称: 药品业务表 医嘱优先级维护
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2015-12-10
Class web.Entity.KB.DHCPHDiseasePriority Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseasePriority";

Property PDPRowId As %String;

Property PDPInstDr As %String;

Property PDPPriorityDR As %String;

}
