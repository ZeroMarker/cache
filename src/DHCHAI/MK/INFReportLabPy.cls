/// 病原体+药敏结果
Class DHCHAI.MK.INFReportLabPy Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 病原体ID
Property PathogenyID As %String(TRUNCATE = 1);

/// 病原体名称
Property PathogenyDesc As %String(TRUNCATE = 1);

/// 病原体名称1
Property PathogenyDesc1 As %String(TRUNCATE = 1);

/// 药敏实验
Property DrugSenTest As list Of DHCHAI.MK.INFReportLabPyAnti;

Storage Default
{
<Data name="INFReportLabPyState">
<Value name="1">
<Value>PathogenyID</Value>
</Value>
<Value name="2">
<Value>PathogenyDesc</Value>
</Value>
<Value name="3">
<Value>PathogenyDesc1</Value>
</Value>
<Value name="4">
<Value>DrugSenTest</Value>
</Value>
</Data>
<State>INFReportLabPyState</State>
<StreamLocation>^DHCHAI.MK.INFReportLabPyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
