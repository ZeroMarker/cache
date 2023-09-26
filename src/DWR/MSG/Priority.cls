Class DWR.MSG.Priority Extends (%Persistent, %XML.Adaptor)
{

Property oecprId As %String;

Property oecprDesc As %String;

Storage Default
{
<Data name="PriorityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>oecprId</Value>
</Value>
<Value name="3">
<Value>oecprDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.PriorityD</DataLocation>
<DefaultData>PriorityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.PriorityD</IdLocation>
<IndexLocation>^DWR.MSG.PriorityI</IndexLocation>
<StreamLocation>^DWR.MSG.PriorityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
