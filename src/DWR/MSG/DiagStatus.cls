Class DWR.MSG.DiagStatus Extends (%Persistent, %XML.Adaptor)
{

Property diagStatId As %String;

Property diagStatCode As %String;

Property diagStatDesc As %String;

Storage Default
{
<Data name="DiagStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>diagStatId</Value>
</Value>
<Value name="3">
<Value>diagStatCode</Value>
</Value>
<Value name="4">
<Value>diagStatDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.DiagStatusD</DataLocation>
<DefaultData>DiagStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.DiagStatusD</IdLocation>
<IndexLocation>^DWR.MSG.DiagStatusI</IndexLocation>
<StreamLocation>^DWR.MSG.DiagStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
