/// 名称:医嘱状态变化原因
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2015-1-12
Class web.Entity.CT.OECAdminStatusChReason Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECAdminStatusChReason";

Property ASCRRowId As %String;

/// 代码
Property ASCRCode As %String;

/// ASA分级
Property ASCRDesc As %String;

/// 撤销类操作原因(Y/N)
Property ASCRCancelOperaReason As %String;

/// PDA电脑端执行原因(Y/N)
Property ASCRPDAExcuteReason As %String;

/// 开始日期
Property ASCRDateFrom As %String;

/// 结束日期
Property ASCRDateTo As %String;

}
