Class User.DHCBorExaRoom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCBorExaRoom ]
{

Index BordBorDrIndex On BorDr;

Index BordExaRoomDrIndex On BorExaRoomDr;

Property BorDr As DHCExaBorough;

Property BorExaRoomDr As %String(TRUNCATE = 1);

Property Memo As %String(TRUNCATE = 1);

Property comm1 As %String(TRUNCATE = 1);

Property comm2 As %String(TRUNCATE = 1);

Property BorExaRoomForOne As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCBorExaRoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BordBorDr</Value>
</Value>
<Value name="3">
<Value>BordExaRoomDr</Value>
</Value>
<Value name="4">
<Value>BordMemo</Value>
</Value>
<Value name="5">
<Value>BorDr</Value>
</Value>
<Value name="6">
<Value>BorExaRoomDr</Value>
</Value>
<Value name="7">
<Value>Memo</Value>
</Value>
<Value name="8">
<Value>comm1</Value>
</Value>
<Value name="9">
<Value>comm2</Value>
</Value>
<Value name="10">
<Value>BorExaRoomForOne</Value>
</Value>
</Data>
<DataLocation>^User.DHCBorExaRoomD</DataLocation>
<DefaultData>DHCBorExaRoomDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCBorExaRoomD</IdLocation>
<IndexLocation>^User.DHCBorExaRoomI</IndexLocation>
<StreamLocation>^User.DHCBorExaRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
