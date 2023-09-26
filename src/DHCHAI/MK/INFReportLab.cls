/// 检验信息
Class DHCHAI.MK.INFReportLab Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 检验标本
Property Specimen As DHCHAI.MK.INFDictionary;

/// 感染部位
Property InfectionPos As DHCHAI.MK.INFDictionary;

/// 送检日期
Property SubmissionDate As %String(TRUNCATE = 1);

/// 检验方法
Property AssayMethod As DHCHAI.MK.INFDictionary;

/// 病原学检验
Property PathogenTest As DHCHAI.MK.INFDictionary;

/// 检验结果(病原体+药敏实验)
Property TestResults As list Of DHCHAI.MK.INFReportLabPy;

Storage Default
{
<Data name="INFReportLabState">
<Value name="1">
<Value>Specimen</Value>
</Value>
<Value name="2">
<Value>InfectionPos</Value>
</Value>
<Value name="3">
<Value>SubmissionDate</Value>
</Value>
<Value name="4">
<Value>AssayMethod</Value>
</Value>
<Value name="5">
<Value>PathogenTest</Value>
</Value>
<Value name="6">
<Value>TestResults</Value>
</Value>
</Data>
<State>INFReportLabState</State>
<StreamLocation>^DHCHAI.MK.INFReportLabS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
