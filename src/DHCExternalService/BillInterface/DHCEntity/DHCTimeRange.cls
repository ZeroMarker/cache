Class DHCExternalService.BillInterface.DHCEntity.DHCTimeRange Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 退号时间点
Property TRCancelTime As %String(TRUNCATE = 1);

/// 代码
Property TRCode As %String(TRUNCATE = 1);

/// 名称
Property TRDesc As %String(TRUNCATE = 1);

/// 出诊结束时间
Property TREndTime As %String(TRUNCATE = 1);

/// 预约号回归时间点
Property TRReturnTime As %String(TRUNCATE = 1);

/// 出诊开始时间
Property TRStartTime As %String(TRUNCATE = 1);

/// 有效截止日期
Property TRValidEndDate As %String(TRUNCATE = 1);

/// 有效开始日期
Property TRValidStartDate As %String(TRUNCATE = 1);

}
