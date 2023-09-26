Class User.DHCExaRoom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCExaRoom ]
{

Property ExarBorDr As DHCExaBorough;

Property ExarCode As %String(TRUNCATE = 1);

Property ExarMemo As %String(TRUNCATE = 1);

Property ExarName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCExaRoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExarBorDr</Value>
</Value>
<Value name="3">
<Value>ExarCode</Value>
</Value>
<Value name="4">
<Value>ExarMemo</Value>
</Value>
<Value name="5">
<Value>ExarName</Value>
</Value>
</Data>
<DataLocation>^User.DHCExaRoomD</DataLocation>
<DefaultData>DHCExaRoomDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCExaRoomD</IdLocation>
<IndexLocation>^User.DHCExaRoomI</IndexLocation>
<StreamLocation>^User.DHCExaRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
