Class DHCExternalService.RegInterface.Entity.SelfReg.GetOPRapidRegistASRp Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 门诊排班项记录标识
Property ScheduleItemCode As %String(TRUNCATE = 1);

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

/// 科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 科室名称
Property DepartmentName As %String(TRUNCATE = 1);

/// 诊室代码
Property ClinicRoomCode As %String(TRUNCATE = 1);

/// 诊室名称
Property ClinicRoomName As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 医生名称
Property DoctorName As %String(TRUNCATE = 1);

/// 医生职称代码
Property DoctorTitleCode As %String(TRUNCATE = 1);

/// 医生职称
Property DoctorTitle As %String(TRUNCATE = 1);

/// 医生专长
Property DoctorSpec As %String(TRUNCATE = 1);

/// 出诊级别代码
Property DoctorSessTypeCode As %String(TRUNCATE = 1);

/// 出诊级别
Property DoctorSessType As %String(TRUNCATE = 1);

/// 专业代码
Property ServiceCode As %String(TRUNCATE = 1);

/// 专业名称
Property ServiceName As %String(TRUNCATE = 1);

/// 预约挂号总费用
Property Fee As %String(TRUNCATE = 1);

/// 挂号费
Property RegFee As %String(TRUNCATE = 1);

/// 诊查费
Property CheckupFee As %String(TRUNCATE = 1);

/// 服务费
Property ServiceFee As %String(TRUNCATE = 1);

/// 其它费
Property OtherFee As %String(TRUNCATE = 1);

/// 就诊地址
Property AdmitAddress As %String(TRUNCATE = 1);

/// 候诊时间范围
Property AdmitTimeRange As %String(TRUNCATE = 1);

/// 备注
Property Note As %String(TRUNCATE = 1);

}
