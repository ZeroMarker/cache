Class DHCExternalService.OPAlloc.Entity.List.OPAllocReport Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 队列表id
Property AdmQueID As %String(TRUNCATE = 1);

/// 就诊日期(YYYY-MM-DD)
Property AdmDate As %String(TRUNCATE = 1);

/// 队列状态
Property QueStatus As %String(TRUNCATE = 1);

/// 患者姓名
Property PatName As %String(TRUNCATE = 1);

/// 病人id
Property PatientID As %String(TRUNCATE = 1);

/// 医院
Property HospitalName As %String(TRUNCATE = 1);

/// 就诊科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 就诊科室
Property Department As %String(TRUNCATE = 1);

/// 医生代码
Property DoctorCode As %String(TRUNCATE = 1);

/// 医生
Property Doctor As %String(TRUNCATE = 1);

/// 诊室
Property QueExamRoom As %String(TRUNCATE = 1);

/// 就诊序号
Property QueSeqCode As %String(TRUNCATE = 1);

/// 候诊地点
Property AdmitAddress As %String(TRUNCATE = 1);

/// 就诊时段
Property RegRangeTime As %String(TRUNCATE = 1);

/// 候诊时间
Property AdmitRange As %String(TRUNCATE = 1);

/// 可报到标志(Y/N)
Property AutoReportFlag As %String(TRUNCATE = 1);

/// 不可报到标志原因
Property AutoReportMsg As %String(TRUNCATE = 1);

}
