/// 名称: DHCMed.NINF.Rep.CSSReportICD
/// 描述: 横断面调查 诊断信息
/// 编写者：zhufei
/// 编写日期: 2013-07-23
Class DHCMed.NINF.Rep.CSSReportICD Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 指向MRC_ICDDx
Property ICDDr As %String(TRUNCATE = 1);

/// ICD10
Property ICD10 As %String(TRUNCATE = 1);

/// 疾病诊断
Property ICDDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CSSReportICDState">
<Value name="1">
<Value>InfPos</Value>
</Value>
<Value name="2">
<Value>TestRst</Value>
</Value>
<Value name="3">
<Value>InfType</Value>
</Value>
<Value name="4">
<Value>ICDDr</Value>
</Value>
<Value name="5">
<Value>ICD10</Value>
</Value>
<Value name="6">
<Value>ICDDesc</Value>
</Value>
</Data>
<State>CSSReportICDState</State>
<StreamLocation>^DHCMed.NINF.Rep.CSSReportICDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
