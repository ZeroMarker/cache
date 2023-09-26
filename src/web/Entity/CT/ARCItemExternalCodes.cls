/// 名称: 医嘱项检验外码关联
/// 描述: 实体类，目前只用于保存日志
/// 编写者：基础数据平台组-李森
/// 编写日期: 2014-1-13
Class web.Entity.CT.ARCItemExternalCodes Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItemExternalCodes";

/// 医嘱项DR ARCItmMast
Property EXTParRef As %String;

/// RowId号
Property EXTRowId As %String;

/// 代码
Property EXTCode As %String;

/// 描述
Property EXTDesc As %String;

/// 接收科室 CTLoc
Property EXTCTLOCDR As %String;

/// 默认科室 Y/N
Property EXTDefaultReceive As %String;

/// 默认发送 Y/N
Property EXTDEfaultSend As %String;

/// 开始日期
Property EXTDateFrom As %String;

/// 截止日期
Property EXTDateTo As %String;

}
