Class DWR.MSG.DiagItem Extends (%Persistent, %XML.Adaptor)
{

Property diagICDId As %String;

Property diagICDDesc As %String;

Storage Default
{
<Data name="DiagItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>diagICDId</Value>
</Value>
<Value name="3">
<Value>diagICDDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.DiagItemD</DataLocation>
<DefaultData>DiagItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.DiagItemD</IdLocation>
<IndexLocation>^DWR.MSG.DiagItemI</IndexLocation>
<StreamLocation>^DWR.MSG.DiagItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
