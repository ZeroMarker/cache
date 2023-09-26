/// 名称: 医嘱子分类接收科室维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-6
Class web.Entity.CT.ARCItemCatRecLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItemCatRecLoc";

/// ParentRowId
Property RLParRef As %String;

/// RowId号
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

/// zrf 2021-6-30  就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
Property RLClinicType As %String;

}
