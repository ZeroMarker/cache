Class DHCExternalService.RegInterface.Entity.RBASRec Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// RBASId	门诊排班标识
Property RBASId As %String(TRUNCATE = 1);

/// RBASDate	出诊日期(格式:yyyy-mm-dd)
Property RBASDate As %String(TRUNCATE = 1);

/// RBASWeekDay	星期数(1-7)
Property RBASWeekDay As %String(TRUNCATE = 1);

/// RBASSessionCode	时间段代码(S\X\Y)
Property RBASSessionCode As %String(TRUNCATE = 1);

/// RBASSessionName	时间段名称(上午\下午\夜晚)
Property RBASSessionName As %String(TRUNCATE = 1);

/// DoctorId	医生ID
Property DoctorId As %String(TRUNCATE = 1);

/// DoctorName	医生姓名
Property DoctorName As %String(TRUNCATE = 1);

/// DoctorTitleCode	医生职称代码
Property DoctorTitleCode As %String(TRUNCATE = 1);

/// DoctorTitle	医生职称
Property DoctorTitle As %String(TRUNCATE = 1);

/// DeptId	科室ID
Property DeptId As %String(TRUNCATE = 1);

/// Dept	科室
Property Dept As %String(TRUNCATE = 1);

/// SubjectId	专业ID
Property SubjectId As %String(TRUNCATE = 1);

/// Subject	专业名
Property Subject As %String(TRUNCATE = 1);

/// DoctorIntro	医生介绍
Property DoctorIntro As %String(TRUNCATE = 1);

/// RBASPrice	挂号总费用
Property RBASPrice As %String(TRUNCATE = 1);

/// RegFee	挂号费
Property RegFee As %String(TRUNCATE = 1);

/// CheckupFee	诊查费
Property CheckupFee As %String(TRUNCATE = 1);

/// ServiceFee	服务费
Property ServiceFee As %String(TRUNCATE = 1);

/// OtherFee	其它费用
Property OtherFee As %String(TRUNCATE = 1);

/// RBASSessionTypeId	出诊级别ID
Property RBASSessionTypeId As %String(TRUNCATE = 1);

/// RBASSessionType	出诊级别
Property RBASSessionType As %String(TRUNCATE = 1);

/// ClinicGroupCode	挂号专业代码
Property ClinicGroupCode As %String(TRUNCATE = 1);

/// ClinicGroupName	挂号专业
Property ClinicGroupName As %String(TRUNCATE = 1);

/// AdmitAddress	就诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// RBASSessionLoad	可预约挂号数量
Property RBASSessionLoad As %String(TRUNCATE = 1);

/// StartTime	出诊开始时间 (HH:MM)
Property StartTime As %String(TRUNCATE = 1);

/// EndTime	出诊结束时间 (HH:MM)
Property EndTime As %String(TRUNCATE = 1);

/// AdmitTimeRange	候诊时间范围
Property AdmitTimeRange As %String(TRUNCATE = 1);

/// Note	备注
Property Note As %String(TRUNCATE = 1);

}
