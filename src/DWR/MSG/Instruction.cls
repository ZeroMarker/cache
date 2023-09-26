Class DWR.MSG.Instruction Extends (%Persistent, %XML.Adaptor)
{

Property instructId As %String;

Property instructDesc As %String;

Storage Default
{
<Data name="InstructionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>instructId</Value>
</Value>
<Value name="3">
<Value>instructDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.InstructionD</DataLocation>
<DefaultData>InstructionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.InstructionD</IdLocation>
<IndexLocation>^DWR.MSG.InstructionI</IndexLocation>
<StreamLocation>^DWR.MSG.InstructionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
