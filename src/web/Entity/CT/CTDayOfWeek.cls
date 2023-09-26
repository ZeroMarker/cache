/// Function: 资源预约- 星期维护
/// Creator: sunfengchao
/// CreateDate: 2015-5-28 
Class web.Entity.CT.CTDayOfWeek Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// DOW_RowId DOW_Day DOW_Name DOW_Sequence DOW_Checked DOW_Weekend
Parameter PersistentClassName = "web.Entity.CT.CTDayOfWeek";

/// ID
Property DOWRowId As %String;

/// 星期的天数
Property DOWDay As %String;

/// 描述
Property DOWName As %String;

/// 第几天
Property DOWSequence As %String;

/// 默认在RB
Property DOWChecked As %String;

/// 是否是周末 
Property DOWWeekend As %String;

}
