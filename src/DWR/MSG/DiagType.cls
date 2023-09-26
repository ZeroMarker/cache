Class DWR.MSG.DiagType Extends (%Persistent, %XML.Adaptor)
{

Property diagTypeId As %String;

Property diagTypeCode As %String;

Property diagTypeDesc As %String;

Storage Default
{
<Data name="DiagTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>diagTypeId</Value>
</Value>
<Value name="3">
<Value>diagTypeCode</Value>
</Value>
<Value name="4">
<Value>diagTypeDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.DiagTypeD</DataLocation>
<DefaultData>DiagTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.DiagTypeD</IdLocation>
<IndexLocation>^DWR.MSG.DiagTypeI</IndexLocation>
<StreamLocation>^DWR.MSG.DiagTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
