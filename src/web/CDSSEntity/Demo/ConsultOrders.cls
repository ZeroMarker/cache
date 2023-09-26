/// Description：住院Demo-会诊医嘱
/// Table：User.DHCDSSDEMOConsultOrders
Class web.CDSSEntity.Demo.ConsultOrders Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.ConsultOrders";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 医嘱时间
Property OrderTime As %String;

/// 医嘱类型 
Property OrderType As %String;

/// 医嘱内容 
Property OrderContent As %String;

/// 初步诊断
Property PreliminaryDiag As %String;

/// 录入人员 
Property Recorder As %String;

}
