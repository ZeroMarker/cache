Class User.DHCDepMark Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDepMark ]
{

Index DepmBorDrIndex On DepmBorDr;

Index DepmDepDrIndex On DepmDepDr;

Index DepmMarkDrIndex On DepmMarkDr;

Index DempDepDrMarkDrIndex On (DepmDepDr, DepmMarkDr);

Property DepmBorDr As DHCExaBorough;

Property DepmCheckin As %String(TRUNCATE = 1);

Property DepmCompDr As DHCRoomComp;

Property DepmDepDr As %String(TRUNCATE = 1);

Property DepmMarkDr As User.CTCareProv;

Property DepmRoomDr As DHCExaRoom;

Property DepmSign As %String(TRUNCATE = 1);

Property DepmState As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCDepMarkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepmCompDr</Value>
</Value>
<Value name="3">
<Value>DepmMarkDr</Value>
</Value>
<Value name="4">
<Value>DepmRoomDr</Value>
</Value>
<Value name="5">
<Value>DepmSign</Value>
</Value>
<Value name="6">
<Value>DepmState</Value>
</Value>
<Value name="7">
<Value>DepmBorDr</Value>
</Value>
<Value name="8">
<Value>DepmDepDr</Value>
</Value>
<Value name="9">
<Value>Checkin</Value>
</Value>
<Value name="10">
<Value>DepmCheckin</Value>
</Value>
</Data>
<DataLocation>^User.DHCDepMarkD</DataLocation>
<DefaultData>DHCDepMarkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCDepMarkD</IdLocation>
<IndexLocation>^User.DHCDepMarkI</IndexLocation>
<StreamLocation>^User.DHCDepMarkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
