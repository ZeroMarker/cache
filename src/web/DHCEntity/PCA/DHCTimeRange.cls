Class web.DHCEntity.PCA.DHCTimeRange Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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

/// 挂号开始时间
Property TRRegSTTime As %String(TRUNCATE = 1);

/// 挂号结束时间
Property TRRegEndTime As %String(TRUNCATE = 1);

/// 允许就诊日后退号天数
Property AllowSpaceReturnDay As %String(TRUNCATE = 1);

/// 需要报到
Property TRCheckin As %String(TRUNCATE = 1);

}
