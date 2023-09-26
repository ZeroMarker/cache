/// Function:  证件类型定义entity 
/// Creator:   sunfengchao
/// CreateDate:2016-6-23
Class web.Entity.CT.DHCCredType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCCredType";

/// RowID
Property CRTRowID As %String;

/// 代码
Property CRTCode As %String;

/// 描述
Property CRTDesc As %String;

/// 默认
Property CRTdefault As %String;

/// 激活
Property CRTActive As %String;

/// 开始日期
Property CRTDateFrom As %String;

/// 结束日期
Property CRTDateTo As %String;

}
