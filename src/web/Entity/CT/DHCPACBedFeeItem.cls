/// 名称:科室/部门/病区  科室/病区-病区床位-床位附加费用
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-2-7
Class web.Entity.CT.DHCPACBedFeeItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCPACBedFeeItem";

/// BEDI_RowId
Property BEDIRowId As %String;

/// 床位类型
Property BEDIBEDParRef As %String;

/// Child Sub
Property BEDIBEDChildsub As %String;

/// Child Sub
Property BEDIChildsub As %String;

/// 费用类型
Property BEDIIFeeType As %String;

/// 费用医嘱项
Property BEDIARCIMDR As %String;

/// 开始时间
Property BEDIStartDate As %String;

/// 结束时间
Property BEDIEndDate As %String;

/// 费别
Property BEDIAdmReasonDR As %String;

/// 起始年龄
Property BEDIStartAge As %String;

/// 截止年龄
Property BEDIEndAge As %String;

/// 床位费时制
Property BEDIFeeTime As %String;

}
