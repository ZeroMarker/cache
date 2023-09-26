Class DWR.MSG.SkinAction Extends (%Persistent, %XML.Adaptor)
{

Property actionId As %String;

Property actionDesc As %String;

Property defaultFlag As %String;

Storage Default
{
<Data name="SkinActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>actionId</Value>
</Value>
<Value name="3">
<Value>actionDesc</Value>
</Value>
<Value name="4">
<Value>defaultFlag</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.SkinActionD</DataLocation>
<DefaultData>SkinActionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.SkinActionD</IdLocation>
<IndexLocation>^DWR.MSG.SkinActionI</IndexLocation>
<StreamLocation>^DWR.MSG.SkinActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
