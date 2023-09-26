Class User.DHCBorUser Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCBorUser ]
{

Index BoruBorDrIndex On BoruBorDr;

Index BoruUseDrIndex On BoruUseDr;

Property BoruBorDr As DHCExaBorough;

Property BoruUseDr As %String(TRUNCATE = 1);

Property BoruUdefault As %String;

Storage Default
{
<Data name="DHCBorUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BoruBorDr</Value>
</Value>
<Value name="3">
<Value>BoruUseDr</Value>
</Value>
<Value name="4">
<Value>BoruUdefault</Value>
</Value>
</Data>
<DataLocation>^User.DHCBorUserD</DataLocation>
<DefaultData>DHCBorUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCBorUserD</IdLocation>
<IndexLocation>^User.DHCBorUserI</IndexLocation>
<StreamLocation>^User.DHCBorUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
