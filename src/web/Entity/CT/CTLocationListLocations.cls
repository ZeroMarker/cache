/// 名称: 关联科室子表
/// 描述: 实体类
/// 编写者：基础数据平台组-孙凤超
/// 编写日期: 2013-5-31     LOC_CTLOC_DR LOC_HospitalCT_DR  
Class web.Entity.CT.CTLocationListLocations Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLocationListLocations";

Property ParentRowId As %String;

/// 父表ID
Property LOCRowId As %String;

/// 子表ID
Property LOCParRef As %String;

/// Ref
Property LOCChildsub As %String;

/// 孩子
Property HospitalCTDR As %String;

/// 医院（必选）
Property CTLOCDR As %String;

///  科室列表（必选）

}
