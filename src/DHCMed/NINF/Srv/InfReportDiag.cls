/// 名称: DHCMed.NINF.Srv.InfReportDiag
/// 描述: 感染监测 疾病诊断 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-07
Class DHCMed.NINF.Srv.InfReportDiag Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 诊断ID 指向MRC_ICDDx
Property DiagnosID As %String(TRUNCATE = 1);

/// 诊断ICD10
Property DiagnosICD As %String(TRUNCATE = 1);

/// 诊断名称
Property DiagnosDesc As %String(TRUNCATE = 1);

/// 诊断日期
Property DiagnosDate As %String(TRUNCATE = 1);

/// 诊断时间
Property DiagnosTime As %String(TRUNCATE = 1);

/// 诊断类型
Property DiagnosType As DHCMed.NINF.Srv.Dictionary;

Storage Default
{
<Data name="InfReportDiagState">
<Value name="1">
<Value>DiagnosDate</Value>
</Value>
<Value name="2">
<Value>DiagnosDesc</Value>
</Value>
<Value name="3">
<Value>DiagnosICD</Value>
</Value>
<Value name="4">
<Value>DiagnosID</Value>
</Value>
<Value name="5">
<Value>DiagnosTime</Value>
</Value>
<Value name="6">
<Value>DiagnosType</Value>
</Value>
</Data>
<State>InfReportDiagState</State>
<StreamLocation>^DHCMed.NINF.Srv.InfReportDiagS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
