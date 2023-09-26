Class User.DHCPerState Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCPerState ]
{

Property PersCode As %String(TRUNCATE = 1);

Property PersMemo As %String(TRUNCATE = 1);

Property PersName As %String(TRUNCATE = 1);

Property PersTem As %String(TRUNCATE = 1);

Property PersShowName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCPerStateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersCode</Value>
</Value>
<Value name="3">
<Value>PersMemo</Value>
</Value>
<Value name="4">
<Value>PersName</Value>
</Value>
<Value name="5">
<Value>PersTem</Value>
</Value>
<Value name="6">
<Value>PersShowName</Value>
</Value>
</Data>
<DataLocation>^User.DHCPerStateD</DataLocation>
<DefaultData>DHCPerStateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPerStateD</IdLocation>
<IndexLocation>^User.DHCPerStateI</IndexLocation>
<StreamLocation>^User.DHCPerStateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
