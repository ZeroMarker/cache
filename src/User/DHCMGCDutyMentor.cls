Class User.DHCMGCDutyMentor Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DutyDr As User.DHCMGCDuty;

Property DutyMentor As %String(TRUNCATE = 1);

Index Duty On DutyDr;

Storage Default
{
<Data name="DHCMGCDutyMentorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DutyDr</Value>
</Value>
<Value name="3">
<Value>DutyMentor</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCDutyMentorD</DataLocation>
<DefaultData>DHCMGCDutyMentorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCDutyMentorD</IdLocation>
<IndexLocation>^User.DHCMGCDutyMentorI</IndexLocation>
<StreamLocation>^User.DHCMGCDutyMentorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
