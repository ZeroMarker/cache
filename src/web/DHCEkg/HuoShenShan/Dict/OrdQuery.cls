Class web.DHCEkg.HuoShenShan.Dict.OrdQuery Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "query";

/// 心电图机的标识名称
Property ECGTitle As %String;

/// 开始日期
Property ExamStartDate As %String;

/// 结束日期
Property ExamEndDate As %String;

/// 检查类型
Property Modality As %String;

/// 检查科室
Property ExamDepartment As %String;

/// 检查医师的姓名
Property PerformingPhysician As %String;

/// 病人姓名
Property PatientName As %String;

/// 病人号
Property PatientID As %String;

/// 检查号
Property ExamID As %String;

/// 申请号
Property RequestID As %String;

/// 申请科室
Property RequestDepartment As %String;

}
