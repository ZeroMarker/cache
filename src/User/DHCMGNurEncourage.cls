Class User.DHCMGNurEncourage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//奖励

Property EncourageDep As %String(TRUNCATE = 1);

Property EncourageNur As User.DHCMGPersons;

Property EncourageDate As %String(TRUNCATE = 1);

Property EncourageContent As %String(TRUNCATE = 1);

Index DateDep On (EncourageDate, EncourageDep);

Index NUR On EncourageNur;

Storage Default
{
<Data name="DHCMGNurEncourageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EncourageContent</Value>
</Value>
<Value name="3">
<Value>EncourageDate</Value>
</Value>
<Value name="4">
<Value>EncourageDep</Value>
</Value>
<Value name="5">
<Value>EncourageNur</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurEncourageD</DataLocation>
<DefaultData>DHCMGNurEncourageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurEncourageD</IdLocation>
<IndexLocation>^User.DHCMGNurEncourageI</IndexLocation>
<StreamLocation>^User.DHCMGNurEncourageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
