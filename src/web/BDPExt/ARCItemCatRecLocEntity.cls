/// 医嘱子类接收科室导入用类
/// 2020-04-02
/// 钟荣枫
Class web.BDPExt.ARCItemCatRecLocEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.BDPExt.ARCItemCatRecLocEntity";

/// 医嘱子类代码
Property ARCICCode As %String;

/// 医嘱子类名称
Property ARCICDesc As %String;

/// Rowid
Property RLRowId As %String;

/// 接收科室
Property RLRecLocDR As %String;

/// 病人科室
Property RLOrdLocDR As %String;

/// 功能
Property RLFunction As %String;

/// 默认 Y/N
Property RLDefaultFlag As %String;

/// 开始时间
Property RLTimeFrom As %String;

/// 结束时间
Property RLTimeTo As %String;

/// 医院
Property RLCTHospitalDR As %String;

/// 开始日期
Property RLDateFrom As %String;

/// 结束日期
Property RLDateTo As %String;

/// 医嘱优先级
Property RLOrderPriorityDR As %String;

/// 医嘱子分类医院
Property LinkHospId As %String;

/// 病人科室医院
Property RLOrdLocDRHosp As %String;

/// 接收科室医院
Property RLRecLocDRHosp As %String;

/// 就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
Property RLClinicType As %String;

}
