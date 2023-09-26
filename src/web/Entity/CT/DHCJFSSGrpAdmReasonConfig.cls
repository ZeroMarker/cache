/// 名称:3安全组与病人类型配置
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2015-3-16
Class web.Entity.CT.DHCJFSSGrpAdmReasonConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCJFSSGrpAdmReasonConfig";

Property GrpReaRowId As %String;

Property GrpReaSSGrpDr As %String;

Property GrpReaAdmReasonDr As %String;

Property GrpReaDefaultAdmReason As %String;

Property GrpReaComment1 As %String;

}
