/// 诊断信息
Class DHCHAI.MK.INFReportDiag Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
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
Property DiagnosType As DHCHAI.MK.INFDictionary;

Storage Default
{
<Data name="INFReportDiagState">
<Value name="1">
<Value>DiagnosID</Value>
</Value>
<Value name="2">
<Value>DiagnosICD</Value>
</Value>
<Value name="3">
<Value>DiagnosDesc</Value>
</Value>
<Value name="4">
<Value>DiagnosDate</Value>
</Value>
<Value name="5">
<Value>DiagnosTime</Value>
</Value>
<Value name="6">
<Value>DiagnosType</Value>
</Value>
</Data>
<State>INFReportDiagState</State>
<StreamLocation>^DHCHAI.MK.INFReportDiagS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
