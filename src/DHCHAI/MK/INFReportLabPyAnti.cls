/// 药敏结果
Class DHCHAI.MK.INFReportLabPyAnti Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 抗生素ID
Property AntibioticsID As %String(TRUNCATE = 1);

/// 抗生素名称
Property AntibioticsDesc As %String(TRUNCATE = 1);

/// 抗生素名称1
Property AntibioticsDesc1 As %String(TRUNCATE = 1);

/// 药敏结果
Property SenTestRst As DHCHAI.MK.INFDictionary;

Storage Default
{
<Data name="INFReportLabPyAntiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntibioticsID</Value>
</Value>
<Value name="3">
<Value>AntibioticsDesc</Value>
</Value>
<Value name="4">
<Value>AntibioticsDesc1</Value>
</Value>
<Value name="5">
<Value>SenTestRst</Value>
</Value>
</Data>
<Data name="INFReportLabPyAntiState">
<Value name="1">
<Value>AntibioticsID</Value>
</Value>
<Value name="2">
<Value>AntibioticsDesc</Value>
</Value>
<Value name="3">
<Value>AntibioticsDesc1</Value>
</Value>
<Value name="4">
<Value>SenTestRst</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.MK.INFReportLa60BCD</DataLocation>
<DefaultData>INFReportLabPyAntiDefaultData</DefaultData>
<IdLocation>^DHCHAI.MK.INFReportLa60BCD</IdLocation>
<IndexLocation>^DHCHAI.MK.INFReportLa60BCI</IndexLocation>
<State>INFReportLabPyAntiState</State>
<StreamLocation>^DHCHAI.MK.INFReportLa60BCS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
