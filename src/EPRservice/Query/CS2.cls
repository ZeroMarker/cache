Class EPRservice.Query.CS2 Extends %Persistent [ ClassType = persistent, Owner = {lz}, Not ProcedureBlock ]
{

Property CS2 As %String(MAXLEN = 221);

Storage Default
{
<Data name="CS2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CS2</Value>
</Value>
</Data>
<DataLocation>^EPRservice.Query.CS2D</DataLocation>
<DefaultData>CS2DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRservice.Query.CS2D</IdLocation>
<IndexLocation>^EPRservice.Query.CS2I</IndexLocation>
<StreamLocation>^EPRservice.Query.CS2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
