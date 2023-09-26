Class User.DHCMGRestCheckOut Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CheckDate As %String(TRUNCATE = 1);

Property CheckTime As %String(TRUNCATE = 1);

Property CheckUser As %String(TRUNCATE = 1);

Property CheckAddNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCMGRestCheckOutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckDate</Value>
</Value>
<Value name="3">
<Value>CheckTime</Value>
</Value>
<Value name="4">
<Value>CheckUser</Value>
</Value>
<Value name="5">
<Value>CheckAddNum</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGRestCheckOutD</DataLocation>
<DefaultData>DHCMGRestCheckOutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGRestCheckOutD</IdLocation>
<IndexLocation>^User.DHCMGRestCheckOutI</IndexLocation>
<StreamLocation>^User.DHCMGRestCheckOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
