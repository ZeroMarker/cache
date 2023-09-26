Class User.DHCMGCDutyProfPos Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DutyDr As User.DHCMGCDuty;

Property DutyProfPos As %String(TRUNCATE = 1);

Index Duty On DutyDr;

Storage Default
{
<Data name="DHCMGCDutyProfPosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DutyDr</Value>
</Value>
<Value name="3">
<Value>DutyProfPos</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCDutyProfPosD</DataLocation>
<DefaultData>DHCMGCDutyProfPosDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCDutyProfPosD</IdLocation>
<IndexLocation>^User.DHCMGCDutyProfPosI</IndexLocation>
<StreamLocation>^User.DHCMGCDutyProfPosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
