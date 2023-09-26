/// 名称:床位类型-床位类型附加费用
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-15
Class web.Entity.CT.DHCPACBedTypeFeeItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCPACBedTypeFeeItem";

// RowId

Property BEDTPIRowId As %String;

/// 床位类型
Property BEDTPIBEDTPParRef As %String;

/// Child Sub
Property BEDTPIChildsub As %String;

/// 费用类型
Property BEDTPIFeeType As %String;

/// 费用医嘱项
Property BEDTPIARCIMDR As %String;

/// 开始时间
Property BEDTPIStartDate As %String;

/// 结束时间
Property BEDTPIEndDate As %String;

/// 费别
Property BEDTPIAdmReasonDR As %String;

/// 起始年龄
Property BEDTPIStartAge As %String;

/// 截止年龄
Property BEDTPIEndAge As %String;

/// 母亲床位类型
Property BEDTPIMomBedTypeDR As %String;

/// 床位费时制
Property BEDTPIFeeTime As %String;

}
