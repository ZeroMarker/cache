/// Desc：实例数据-牙位图牙面打散表
/// Creator:    niucaicai
/// CreateDate: 2020-07-13
Class EMRinstance.IToothArea Extends (%Persistent, %XML.Adaptor)
{

Index IdxForUpdate On (InstanceDataID, ToothImageCode, ToothInCode, InCode);

Index IdxForDelete On (InstanceDataID, ToothImageCode, ToothInCode, InCode);

Index IdxUniqueAnum On (EpisodeID, InstanceDataID, ToothImageCode, ToothInCode, Anum) [ Unique ];

Index IdxUniqueCode On (EpisodeID, InstanceDataID, ToothImageCode, ToothInCode, Code) [ Unique ];

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property ToothImageCode As %String(TRUNCATE = 1);

Property Tnum As %String(TRUNCATE = 1);

Property Anum As %String(TRUNCATE = 1);

Property ToothInCode As %String(TRUNCATE = 1);

Property InCode As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Property DisplayName As %String(TRUNCATE = 1);

Property ScriptMode As %String(TRUNCATE = 1);

Property CodeSystem As %String(TRUNCATE = 1);

Property CodeSystemName As %String(TRUNCATE = 1);

Property Area As %String(TRUNCATE = 1);

Storage Default
{
<Data name="IToothAreaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ChartItemID</Value>
</Value>
<Value name="5">
<Value>InstanceDataID</Value>
</Value>
<Value name="6">
<Value>TemplateID</Value>
</Value>
<Value name="7">
<Value>TemplateVersion</Value>
</Value>
<Value name="8">
<Value>SectionCode</Value>
</Value>
<Value name="9">
<Value>CompositeCode</Value>
</Value>
<Value name="10">
<Value>ToothImageCode</Value>
</Value>
<Value name="12">
<Value>ToothCode</Value>
</Value>
<Value name="13">
<Value>ACode</Value>
</Value>
<Value name="14">
<Value>ADisplayName</Value>
</Value>
<Value name="15">
<Value>ScriptMode</Value>
</Value>
<Value name="16">
<Value>Area</Value>
</Value>
<Value name="17">
<Value>Code</Value>
</Value>
<Value name="18">
<Value>DisplayName</Value>
</Value>
<Value name="19">
<Value>Tnum</Value>
</Value>
<Value name="20">
<Value>Anum</Value>
</Value>
<Value name="21">
<Value>ToothInCode</Value>
</Value>
<Value name="22">
<Value>InCode</Value>
</Value>
<Value name="23">
<Value>CodeSystem</Value>
</Value>
<Value name="24">
<Value>CodeSystemName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.IToothAreaD</DataLocation>
<DefaultData>IToothAreaDefaultData</DefaultData>
<IdLocation>^DHCEMRI.IToothAreaD</IdLocation>
<IndexLocation>^DHCEMRI.IToothAreaI</IndexLocation>
<StreamLocation>^DHCEMRI.IToothAreaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
