/// Description：住院Demo-死亡医嘱
/// Table：User.DHCDSSDEMODeathOrders
Class web.CDSSEntity.Demo.DeathOrders Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DeathOrders";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 医嘱时间
Property OrderTime As %String;

/// 执行时间
Property ExecutionTime As %String;

/// 医嘱类型
Property OrderType As %String;

/// 医嘱内容
Property OrderContent As %String;

/// 录入人员
Property Recorder As %String;

}
