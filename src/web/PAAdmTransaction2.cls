/// 
Class web.PAAdmTransaction2 Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property dummy As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PAAdmTransaction2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>dummy</Value>
</Value>
</Data>
<DataLocation>^web.PAAdmTransaction2D</DataLocation>
<DefaultData>PAAdmTransaction2DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PAAdmTransaction2D</IdLocation>
<IndexLocation>^web.PAAdmTransaction2I</IndexLocation>
<StreamLocation>^web.PAAdmTransaction2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
