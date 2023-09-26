/// 动作日志
Class EMRinstance.Events.ActionLog Extends %Persistent
{

Property UsrID As %String;

Property UsrLoc As %String;

Property Action As %String;

Property EMRTemplate As %String;

Property IP As %String;

Property LogDate As %Date;

Property LogTime As %Time;

Storage Default
{
<Data name="ActionLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UsrID</Value>
</Value>
<Value name="3">
<Value>UsrLoc</Value>
</Value>
<Value name="4">
<Value>Action</Value>
</Value>
<Value name="5">
<Value>LogDate</Value>
</Value>
<Value name="6">
<Value>LogTime</Value>
</Value>
<Value name="7">
<Value>IP</Value>
</Value>
<Value name="8">
<Value>Computer</Value>
</Value>
<Value name="9">
<Value>EMRTemplate</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Events.ActionLogD</DataLocation>
<DefaultData>ActionLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.Events.ActionLogD</IdLocation>
<IndexLocation>^DHCEMRI.Events.ActionLogI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.ActionLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
