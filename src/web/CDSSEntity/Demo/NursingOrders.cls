/// Description：住院Demo-护理医嘱
/// Table：User.DHCDSSDEMONursingOrders
Class web.CDSSEntity.Demo.NursingOrders Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.NursingOrders";

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

/// 频次 
Property Frequency As %String;

/// 停止时间 
Property StopTime As %String;

/// 录入人员 
Property Recorder As %String;

/// 护理名称==医嘱内容
Property NursingName As %String;

}
