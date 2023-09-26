/// Description：住院Demo-检验医嘱
/// Table：User.DHCDSSDEMOLabOrders
Class web.CDSSEntity.Demo.LabOrders Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.LabOrders";

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

/// 样本
Property Specimen As %String;

/// 部位
Property Position As %String;

/// 频次
Property Frequency As %String;

/// 录入人员
Property Recorder As %String;

/// 检验==医嘱内容
Property LabName As %String;

}
