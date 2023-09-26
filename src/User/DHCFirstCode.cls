Class User.DHCFirstCode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCFirstCode ]
{

Property FirstcCode As %String(TRUNCATE = 1);

Property FirstcMemo As %String(TRUNCATE = 1);

Property FirstcName As %String(TRUNCATE = 1);

Property FirstcTem As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCFirstCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FirstcCode</Value>
</Value>
<Value name="3">
<Value>FirstcMemo</Value>
</Value>
<Value name="4">
<Value>FirstcName</Value>
</Value>
<Value name="5">
<Value>FirstcTem</Value>
</Value>
</Data>
<DataLocation>^User.DHCFirstCodeD</DataLocation>
<DefaultData>DHCFirstCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCFirstCodeD</IdLocation>
<IndexLocation>^User.DHCFirstCodeI</IndexLocation>
<StreamLocation>^User.DHCFirstCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
