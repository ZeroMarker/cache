Class DWR.MSG.DiagTabs Extends (%Persistent, %XML.Adaptor)
{

Property tabId As %String;

Property tabName As %String;

Property diagICDId As %String;

Property diagICDDesc As %String;

Storage Default
{
<Data name="DiagTabsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>tabId</Value>
</Value>
<Value name="3">
<Value>tabName</Value>
</Value>
<Value name="4">
<Value>diagICDId</Value>
</Value>
<Value name="5">
<Value>diagICDDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.DiagTabsD</DataLocation>
<DefaultData>DiagTabsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.DiagTabsD</IdLocation>
<IndexLocation>^DWR.MSG.DiagTabsI</IndexLocation>
<StreamLocation>^DWR.MSG.DiagTabsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
