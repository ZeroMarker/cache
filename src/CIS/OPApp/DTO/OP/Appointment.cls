Class CIS.OPApp.DTO.OP.Appointment Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "Appointment";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 外部ID
Property ExternalID As %String;

/// 内部ID
Property RowId As %String;

/// 申请表ID
Property ApplicationID As %String;

/// 旧版申请表ID（5.0以前的手术申请）
Property OldID As %String;

/// 患者
Property Patient As CIS.OPApp.DTO.HIS.Person;

/// 就诊
Property Admission As CIS.OPApp.DTO.HIS.Admission;

/// 手术预约状态
Property StatusCode As %String;

/// 手术预约状态描述
Property StatusDesc As %String;

/// 手术预约类型: B,E,D
Property SourceType As %String(TRUNCATE = 1);

/// 手术预约类型描述: B 择期, E 急诊, D 日间
Property SourceTypeDesc As %String(TRUNCATE = 1);

/// 日间手术：Y 是，N 否
Property DaySurgery As %String(TRUNCATE = 1);

/// 手术类型: OOP,IOP,DOP
Property SurgeryType As %String(TRUNCATE = 1);

/// 手术类型描述: 门诊手术,住院手术,科内手术
Property SurgeryTypeDesc As %String(TRUNCATE = 1);

/// 手术申请科室Id
Property ApplyDepartmentID As %String(TRUNCATE = 1);

/// 手术申请科室
Property ApplyDepartment As %String(TRUNCATE = 1);

/// 手术申请日期
Property ApplyDate As %String(TRUNCATE = 1);

/// 手术申请时间
Property ApplyTime As %String(TRUNCATE = 1);

/// 手术申请用户ID
Property ApplyUserID As %String(TRUNCATE = 1);

/// 手术申请用户
Property ApplyUser As %String(TRUNCATE = 1);

/// 手术日期
Property OperDate As %String(TRUNCATE = 1);

/// 手术时间
Property OperTime As %String(TRUNCATE = 1);

/// 手术室Id
Property OperatingDepartmentID As %String(TRUNCATE = 1);

/// 手术室
Property OperatingDepartment As %String(TRUNCATE = 1);

/// 麻醉科Id
Property AnaDepartmentID As %String(TRUNCATE = 1);

/// 麻醉科
Property AnaDepartment As %String(TRUNCATE = 1);

/// 术前诊断ID
Property PreviousDiagnosisID As %String(TRUNCATE = 1);

/// 术前诊断
Property PreviousDiagnosis As %String(TRUNCATE = 1);

/// 拟施手术
Property PlanOperations As list Of CIS.OPApp.DTO.OP.Operation;

/// 手术体位ID
Property OperPositionID As %String;

/// 手术体位
Property OperPosition As %String;

/// 麻醉方法ID（拟施麻醉）
Property AnaMethodID As %String(TRUNCATE = 1);

/// 麻醉方法（拟施麻醉）
Property AnaMethod As %String(TRUNCATE = 1);

/// 麻醉方法国家标准码（拟施麻醉）
Property AnaMethodStandardCode As %String(TRUNCATE = 1);

/// 非计划重返手术
Property UnplannedReentry As %String(TRUNCATE = 1);

/// 计划台次
Property PlanSeq As %String(TRUNCATE = 1);

/// 台次类型
Property SeqType As %String(TRUNCATE = 1);

/// 台次类型描述
Property SeqTypeDesc As %String(TRUNCATE = 1);

/// 参观者
Property Visitor As %String(TRUNCATE = 1);

/// 感染情况
Property Infection As CIS.OPApp.DTO.OP.Infection;

/// 手术要求
Property Requirement As CIS.OPApp.DTO.OP.Requirement;

}
