Class EPRservice.Query.CS1 Extends %Persistent [ ClassType = persistent, Owner = {lz}, Not ProcedureBlock ]
{

Property CS1 As %String(MAXLEN = 332);

Storage Default
{
<Data name="CS1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CS1</Value>
</Value>
</Data>
<DataLocation>^EPRservice.Query.CS1D</DataLocation>
<DefaultData>CS1DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRservice.Query.CS1D</IdLocation>
<IndexLocation>^EPRservice.Query.CS1I</IndexLocation>
<StreamLocation>^EPRservice.Query.CS1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
