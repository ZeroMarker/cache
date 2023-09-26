/// Function:预约渠道
/// CreateDate:2021-11-15
/// Creator:sunfengchao
Class web.Entity.CT.RBCApptType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCApptType";

Property ATRowId As %String;

/// 代码
Property ATCode As %String;

/// 描述 
Property ATDesc As %String;

/// 开始日期  
Property ATDateFrom As %String;

/// 结束日期  
Property ATDateTo As %String;

}
