/// Desc：实例数据-牙位图牙位打散表
/// Creator:    niucaicai
/// CreateDate: 2020-07-10
Class EMRinstance.IToothItems Extends (%Persistent, %XML.Adaptor)
{

Index IdxForUpdate On (InstanceDataID, ToothImageCode, Num);

Index IdxForDelete On (InstanceDataID, ToothImageCode, Num);

Index IdxUnique On (EpisodeID, InstanceDataID, ToothImageCode, Num, InCode) [ Unique ];

Index IdxEpisodeIDInCode On (EpisodeID, InCode);

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property ToothImageCode As %String(TRUNCATE = 1);

Property Num As %String(TRUNCATE = 1);

Property DisplayName As %String(TRUNCATE = 1);

Property QuadrantType As %String(TRUNCATE = 1);

Property InCode As %String(TRUNCATE = 1);

Property AreaType As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Property PDisplayName As %String(TRUNCATE = 1);

Property CodeSystem As %String(TRUNCATE = 1);

Property CodeSystemName As %String(TRUNCATE = 1);

Property Position As %String(TRUNCATE = 1);

Storage Default
{
<Data name="IToothItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ToothImageCode</Value>
</Value>
<Value name="3">
<Value>Num</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
<Value name="5">
<Value>AreaType</Value>
</Value>
<Value name="6">
<Value>Code</Value>
</Value>
<Value name="7">
<Value>PDisplayName</Value>
</Value>
<Value name="8">
<Value>CodeSystem</Value>
</Value>
<Value name="9">
<Value>CodeSystemName</Value>
</Value>
<Value name="10">
<Value>Position</Value>
</Value>
<Value name="11">
<Value>ACode</Value>
</Value>
<Value name="12">
<Value>ADisplayName</Value>
</Value>
<Value name="13">
<Value>ScriptMode</Value>
</Value>
<Value name="14">
<Value>Area</Value>
</Value>
<Value name="15">
<Value>PatientID</Value>
</Value>
<Value name="16">
<Value>EpisodeID</Value>
</Value>
<Value name="17">
<Value>ChartItemID</Value>
</Value>
<Value name="18">
<Value>InstanceDataID</Value>
</Value>
<Value name="19">
<Value>TemplateID</Value>
</Value>
<Value name="20">
<Value>TemplateVersion</Value>
</Value>
<Value name="21">
<Value>SectionCode</Value>
</Value>
<Value name="22">
<Value>CompositeCode</Value>
</Value>
<Value name="23">
<Value>QuadrantType</Value>
</Value>
<Value name="24">
<Value>InCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.IToothItemsD</DataLocation>
<DefaultData>IToothItemsDefaultData</DefaultData>
<IdLocation>^DHCEMRI.IToothItemsD</IdLocation>
<IndexLocation>^DHCEMRI.IToothItemsI</IndexLocation>
<StreamLocation>^DHCEMRI.IToothItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
