Class DWR.MSG.OETabs Extends (%Persistent, %XML.Adaptor)
{

Property tabId As %String;

Property tabName As %String;

Property subTabId As %String;

Property subTabName As %String;

Property arcRowId As %String;

Property arcDesc As %String;

Property arcQty As %String;

Storage Default
{
<Data name="OETabsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>tabName</Value>
</Value>
<Value name="3">
<Value>tabId</Value>
</Value>
<Value name="4">
<Value>subTabId</Value>
</Value>
<Value name="5">
<Value>subTabName</Value>
</Value>
<Value name="6">
<Value>arcRowId</Value>
</Value>
<Value name="7">
<Value>arcDesc</Value>
</Value>
<Value name="8">
<Value>arcQty</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.OETabsD</DataLocation>
<DefaultData>OETabsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.OETabsD</IdLocation>
<IndexLocation>^DWR.MSG.OETabsI</IndexLocation>
<StreamLocation>^DWR.MSG.OETabsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
