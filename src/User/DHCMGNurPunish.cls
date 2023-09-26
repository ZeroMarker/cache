Class User.DHCMGNurPunish Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//惩罚

Property PunishDep As %String(TRUNCATE = 1);

Property PunishNur As User.DHCMGPersons;

Property PunishDate As %String(TRUNCATE = 1);

Property PunishContent As %String(TRUNCATE = 1);

Index DateDep On (PunishDate, PunishDep);

Index NUR On PunishNur;

Storage Default
{
<Data name="DHCMGNurPunishDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PunishContent</Value>
</Value>
<Value name="3">
<Value>PunishDate</Value>
</Value>
<Value name="4">
<Value>PunishDep</Value>
</Value>
<Value name="5">
<Value>PunishNur</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurPunishD</DataLocation>
<DefaultData>DHCMGNurPunishDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurPunishD</IdLocation>
<IndexLocation>^User.DHCMGNurPunishI</IndexLocation>
<StreamLocation>^User.DHCMGNurPunishS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
