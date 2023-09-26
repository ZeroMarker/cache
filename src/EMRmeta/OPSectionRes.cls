/// 章节和资源区的对应关系
Class EMRmeta.OPSectionRes Extends %Persistent
{

Index IdxSec On (TemplateId, SectionCode);

Property TemplateId As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property Resource As %String(TRUNCATE = 1);

Storage Default
{
<Data name="OPSectionResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateId</Value>
</Value>
<Value name="3">
<Value>SectionCode</Value>
</Value>
<Value name="4">
<Value>Resource</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.OPSectionResD</DataLocation>
<DefaultData>OPSectionResDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.OPSectionResD</IdLocation>
<IndexLocation>^DHCEMRM.OPSectionResI</IndexLocation>
<StreamLocation>^DHCEMRM.OPSectionResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
