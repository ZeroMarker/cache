Class User.DHCMGCDutyTeach Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DutyDr As User.DHCMGCDuty;

Property DutyTeach As %String(TRUNCATE = 1);

Index Duty On DutyDr;

Storage Default
{
<Data name="DHCMGCDutyTeachDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DutyDr</Value>
</Value>
<Value name="3">
<Value>DutyTeach</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCDutyTeachD</DataLocation>
<DefaultData>DHCMGCDutyTeachDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCDutyTeachD</IdLocation>
<IndexLocation>^User.DHCMGCDutyTeachI</IndexLocation>
<StreamLocation>^User.DHCMGCDutyTeachS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
