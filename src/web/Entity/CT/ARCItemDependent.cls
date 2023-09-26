/// Creator:李欣
/// CreatorTiem:2017-09-15
/// Table:User.ARCITemDependent
/// Original:陈莹
Class web.Entity.CT.ARCItemDependent Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.ARCItemDependent";

/// RowId
Property DEPRowId As %String;

/// 父表RowId
Property DEPParRef As %String;

/// 开始时间
Property DEPDateFrom As %String;

/// 结束时间
Property DEPDateTo As %String;

/// 医嘱项
Property DEPARCIMDR As %String;

/// 数量
Property DEPDoseQty As %String;

/// 单位
Property DEPUnitDR As %String;

}
