/// Description：住院Demo-手术医嘱
/// Table：User.DHCDSSDEMOOperaOrders
Class web.CDSSEntity.Demo.OperaOrders Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.OperaOrders";

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

/// 手术方式
Property OperaMethod As %String;

/// 手术日期
Property OperaDate As %String;

/// 录入人员 
Property Recorder As %String;

/// 手术名称==医嘱内容
Property OperationName As %String;

/// 手术类型（择期、急诊）
Property OperClass As %String;

/// 手术等级
Property OperLevel As %String;

/// 手术麻醉方式
Property OperAnest As %String;

/// 手术切口类型
Property OperIncisionType As %String;

}
