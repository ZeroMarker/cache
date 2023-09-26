Class EMRmeta.EPRPageURL Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Title As %String(TRUNCATE = 1);

Property URL As %String(MAXLEN = 32767, TRUNCATE = 1);

Property Paras As %String(MAXLEN = 32767, TRUNCATE = 1);

Property Num As %String(MAXLEN = 32767, TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Index IdxNum On Num;

Storage Default
{
<Data name="EPRPageURLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>URL</Value>
</Value>
<Value name="4">
<Value>Paras</Value>
</Value>
<Value name="5">
<Value>Num</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EPRPageURLD</DataLocation>
<DefaultData>EPRPageURLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EPRPageURLD</IdLocation>
<IndexLocation>^DHCEMRM.EPRPageURLI</IndexLocation>
<StreamLocation>^DHCEMRM.EPRPageURLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
