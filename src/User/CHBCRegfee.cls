Class User.CHBCRegfee Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, SqlTableName = CHBCRegfee ]
{

Property ChrhFeeDr As %String;

Property ChrhRoomDr As %String;

Property ChrhFee As %String;

Storage Default
{
<Data name="CHBCRegfeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChrhFee</Value>
</Value>
<Value name="3">
<Value>ChrhFeeDr</Value>
</Value>
<Value name="4">
<Value>ChrhRoomDr</Value>
</Value>
</Data>
<DataLocation>^User.CHBCRegfeeD</DataLocation>
<DefaultData>CHBCRegfeeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CHBCRegfeeD</IdLocation>
<IndexLocation>^User.CHBCRegfeeI</IndexLocation>
<StreamLocation>^User.CHBCRegfeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
