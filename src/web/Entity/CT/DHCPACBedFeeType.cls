/// 床位附加费用类型
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2020-1-15
Class web.Entity.CT.DHCPACBedFeeType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCPACBedFeeType";

// RowId

Property FTRowId As %String;

// 代码

Property FTCode As %String;

// 描述

Property FTDesc As %String;

// 开始日期

Property FTStartDate As %String;

// 结束日期

Property FTEndDate As %String;

}
