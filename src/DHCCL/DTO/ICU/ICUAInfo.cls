/// 重症监护信息
Class DHCCL.DTO.ICU.ICUAInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 重症监护Id
Property IcuaId As %String;

/// 患者就诊号
Property EpisodeID As %String;

/// 患者Id
Property PatientID As %String;

/// 患者姓名
Property PatName As %String;

/// 患者登记号
Property RegNo As %String;

/// 患者性别
Property PatGender As %String;

/// 患者出生日期
Property PatBirth As %String;

/// 患者年龄
Property PatAge As %String;

/// 患者病案号
Property MedcareNo As %String;

/// 患者当前所在科室Id
Property CurDeptId As %String;

/// 患者当前所在科室描述
Property CurDeptDesc As %String;

/// 患者当前所在病区Id
Property CurWardId As %String;

/// 患者当前所在病区描述
Property CurWardDesc As %String;

/// 患者当前所在床位Id
Property CurBedId As %String;

/// 患者当前所在床位描述
Property CurBedCode As %String;

/// 患者就诊类型
Property PAAdmReasonDesc As %String;

/// 患者就诊日期
Property AdmDate As %String;

/// 患者在院天数
Property AdmStayDay As %String;

/// 患者诊断描述
Property DiagnoseDesc As %String;

/// 患者入病区日期时间
Property InWardDT As %String;

/// 重症监护开始日期时间
Property ICUAStartDT As %String;

/// 重症监护转归日期时间
Property ICUALeaveDT As %String;

/// 重症监护转归状态代码
Property ICUALeaveConditionCode As %String;

/// 重症监护转归状态描述
Property ICUALeaveConditionDesc As %String;

/// 重症监护科室Id
Property ICUADeptId As %String;

/// 重症监护科室描述
Property ICUADeptDesc As %String;

/// 重症监护病区Id
Property ICUAWardId As %String;

/// 重症监护病区描述
Property ICUAWardDesc As %String;

/// 重症监护床位代码
Property ICUABedCode As %String;

/// 重症患者身高
Property ICUAPatHeight As %String;

/// 重症患者体重
Property ICUAPatWeight As %String;

/// 责任护士Id
Property ICUAChargeNurseDr As %String;

/// 责任护士名称
Property ICUAChargeNurseDesc As %String;

/// 主管护士Id
Property ICUASupervisorNurseDr As %String;

/// 主管护士名称
Property ICUASupervisorNurseDesc As %String;

/// 主治医师Id
Property ICUAResidentCtcpDr As %String;

/// 主治医师名称
Property ICUAResidentCtcpDesc As %String;

/// 住院医师Id
Property ICUAAttendingCtcpDr As %String;

/// 住院医师名称
Property ICUAAttendingCtcpDesc As %String;

/// 在ICU天数
Property InWardDays As %String;

}
