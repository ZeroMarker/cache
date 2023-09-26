/// Description：住院Demo-出院带药
/// Table：User.DHCDSSDEMODischargeDrug
Class web.CDSSEntity.Demo.DischargeDrug Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DischargeDrug";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 医嘱时间
Property OrderTime As %String;

/// 执行时间
Property ExecutionTime As %String;

/// 医嘱内容
Property OrderContent As %String;

/// 剂量
Property Dosage As %String;

/// 单位
Property Unit As %String;

/// 频次
Property Frequency As %String;

/// 给药途径
Property DrugRoute As %String;

/// 药品规格
Property DrugSpecs As %String;

/// 录入人员
Property Recorder As %String;

/// 药品名称==医嘱内容
Property DrugName As %String;

}
