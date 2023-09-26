Class web.DHCENS.STBLL.BOOKREG.MODEL.RBParentApptSchedule Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "RBASRec";

/// 门诊排班标识
Property RBASId As %String(TRUNCATE = 1);

/// 出诊日期
Property RBASDate As %String(TRUNCATE = 1);

/// 星期数(1-7)
Property RBASWeekDay As %String(TRUNCATE = 1);

/// 时间段代码
Property RBASSessionCode As %String(TRUNCATE = 1);

/// 时间段名称
Property RBASSessionName As %String(TRUNCATE = 1);

/// 医生ID
Property DoctorId As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 医生姓名
Property DoctorName As %String(TRUNCATE = 1);

/// 医生职称代码
Property DoctorTitleCode As %String(TRUNCATE = 1);

/// 医生职称
Property DoctorTitle As %String(TRUNCATE = 1);

/// 科室ID
Property DeptId As %String(TRUNCATE = 1);

/// 科室代码
Property DeptCode As %String(TRUNCATE = 1);

/// 科室
Property Dept As %String(TRUNCATE = 1);

/// 科室备注
Property DeptNote As %String(TRUNCATE = 1);

/// 上级科室id
Property DeptParentId As %String(TRUNCATE = 1);

/// 上级科室code
Property DeptParentCode As %String(TRUNCATE = 1);

/// 上级科室名称
Property DeptParentName As %String(TRUNCATE = 1);

/// 上级科室备注
Property DeptParentNote As %String(TRUNCATE = 1);

/// 顶级级科室id
Property DeptMainId As %String(TRUNCATE = 1);

/// 顶级科室code
Property DeptMainCode As %String(TRUNCATE = 1);

/// 顶级科室名称
Property DeptMainName As %String(TRUNCATE = 1);

/// 专业ID
Property SubjectId As %String(TRUNCATE = 1);

/// 专业名
Property Subject As %String(TRUNCATE = 1);

/// 挂号总费用
Property RBASPrice As %String(TRUNCATE = 1);

/// 挂号费
Property RegFee As %String(TRUNCATE = 1);

/// 诊查费
Property CheckupFee As %String(TRUNCATE = 1);

/// 服务费
Property ServiceFee As %String(TRUNCATE = 1);

/// 其它费用
Property OtherFee As %String(TRUNCATE = 1);

/// 出诊级别ID
Property RBASSessionTypeId As %String(TRUNCATE = 1);

/// 出诊级别
Property RBASSessionType As %String(TRUNCATE = 1);

/// 挂号专业代码
Property ClinicGroupCode As %String(TRUNCATE = 1);

/// 挂号专业
Property ClinicGroupName As %String(TRUNCATE = 1);

/// 就诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// 可预约挂号数量
Property RBASSessionLoad As %String(TRUNCATE = 1);

/// 出诊开始时间
Property StartTime As %String(TRUNCATE = 1);

/// 出诊结束时间
Property EndTime As %String(TRUNCATE = 1);

/// 候诊时间范围
Property AdmitTimeRange As %String(TRUNCATE = 1);

/// 备注
Property Note As %String(TRUNCATE = 1);

/// 开放日期
Property EnableDate As %String(TRUNCATE = 1);

/// 开放时间
Property EnableTime As %String(TRUNCATE = 1);

/// 诊室代码
Property ClinicRoomCode As %String(TRUNCATE = 1);

/// 诊室名称
Property ClinicRoomName As %String(TRUNCATE = 1);

/// 排队人数
Property WaitNum As %String(TRUNCATE = 1);

/// 排班分时信息
Property RBChildApptScheduleList As list Of web.DHCENS.STBLL.BOOKREG.MODEL.RBChildApptSchedule(XMLNAME = "TimeRangeList");

}
