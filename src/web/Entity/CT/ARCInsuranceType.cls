/// Creator:基础数据平台组 孙凤超
/// Function:付款人实体类
/// CreateDate:2013-5-13
Class web.Entity.CT.ARCInsuranceType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCInsuranceType";

Property INSTRowId As %String;

Property INSTCode As %String;

/// 代码
Property INSTDesc As %String;

/// 描述
Property INSTDateFrom As %String;

/// 开始日期
Property INSTDateTo As %String;

///  结束日期

}
