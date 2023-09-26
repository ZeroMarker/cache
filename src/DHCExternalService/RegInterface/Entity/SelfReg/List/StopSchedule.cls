Class DHCExternalService.RegInterface.Entity.SelfReg.List.StopSchedule Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 门诊排班项记录标识
Property ScheduleCode As %String(TRUNCATE = 1);

/// 门诊排班日期(YYYY-MM-DD)
Property ServiceDate As %String(TRUNCATE = 1);

/// 排班时段代码
Property TimeRangeCode As %String(TRUNCATE = 1);

/// 排班时段名称
Property TimeRangeName As %String(TRUNCATE = 1);

/// 开始时间(HH:MM)
Property StartTime As %String(TRUNCATE = 1);

/// 结束时间(HH:MM)
Property EndTime As %String(TRUNCATE = 1);

/// 科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 科室名称
Property DepartmentName As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 医生名称
Property DoctorName As %String(TRUNCATE = 1);

/// 停诊原因
Property Reason As %String(TRUNCATE = 1);

/// 移动订单号
Property OrderId As %String(TRUNCATE = 1);

/// 替诊医生代码
Property ReplaceDoctorId As %String(TRUNCATE = 1);

/// 替诊医生姓名
Property ReplaceDoctorName As %String(TRUNCATE = 1);

/// 病人编号
Property AppPAPMINo As %String(TRUNCATE = 1);

/// 病人姓名
Property AppPAPMIName As %String(TRUNCATE = 1);

/// 病人手机
Property AppPAPMIMobphone As %String(TRUNCATE = 1);

/// 病人身份证
Property AppPAPMICred As %String(TRUNCATE = 1);

/// 病人预约序号
Property AppSeqNo As %String(TRUNCATE = 1);

/// 病人预约订单号
Property AppTranctionNo As %String(TRUNCATE = 1);

}
