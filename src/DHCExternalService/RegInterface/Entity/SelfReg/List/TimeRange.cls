Class DHCExternalService.RegInterface.Entity.SelfReg.List.TimeRange Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

/// 门诊排班项记录标识
Property ScheduleItemCode As %String(TRUNCATE = 1);

/// 分时号
Property TimeRangeSeqNo As %String(TRUNCATE = 1);

/// 门诊排班日期(YYYY-MM-DD)
Property ServiceDate As %String(TRUNCATE = 1);

/// 星期数(1-7)
Property WeekDay As %String(TRUNCATE = 1);

/// 排班时段代码
Property SessionCode As %String(TRUNCATE = 1);

/// 排班时段名称
Property SessionName As %String(TRUNCATE = 1);

/// 开始时间(HH:MM)
Property StartTime As %String(TRUNCATE = 1);

/// 结束时间(HH:MM)
Property EndTime As %String(TRUNCATE = 1);

/// 剩余号信息串
Property AvailableNumStr As %String(TRUNCATE = 1);

/// 该时段可预约的总号源数
Property AvailableTotalNum As %String(TRUNCATE = 1);

/// 该时段剩余号源数
Property AvailableLeftNum As %String(TRUNCATE = 1);

}
