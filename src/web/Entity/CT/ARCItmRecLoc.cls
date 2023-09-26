/// 名称: 医嘱项接收科室
/// 描述: 实体类，目前只用于保存日志
/// 编写者：基础数据平台组-李森
/// 编写日期: 2014-1-13
Class web.Entity.CT.ARCItmRecLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItmRecLoc";

/// 医嘱项DR ARCItmMast
Property ARCRLARCIMDR As %String;

/// RowId号
Property ARCRLRowId As %String;

/// 病人科室 CTLoc
Property ARCRLOrdLocDR As %String;

/// 接收科室 CTLoc
Property ARCRLRecLocDR As %String;

/// 医嘱优先级 OECPriority
Property ARCRLOrderPriorityDR As %String;

/// 默认科室 Y/N
Property ARCRLDefaultFlag As %String;

/// 开始时间
Property ARCRLTimeFrom As %String;

/// 结束时间
Property ARCRLTimeTo As %String;

/// 开始日期
Property ARCRLDateFrom As %String;

/// 结束日期
Property ARCRLDateTo As %String;

/// 医院
Property ARCRLCTHospitalDR As %String;

/// zrf 2021-8-19  就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
Property ARCRLClinicType As %String;

/// 功能
Property ARCRLFunction As %String;

}
