/// SH医生组映射BonusSubDoctorGroupMap
Class dhc.bonus.subs.BonusSubDoctorGroupMap Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubDoctorGroupMapID ]
{

Property BonusSubDoctorGroupID As dhc.bonus.subs.BonusSubDoctorGroup [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Index Parent On (BonusSubDoctorGroupID, BonusUnitID);

Storage Default
{
<Data name="BonusSubDoctorGroupMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSubDoctorGroupID</Value>
</Value>
<Value name="3">
<Value>BonusUnitID</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubDoctorGroupMapD</DataLocation>
<DefaultData>BonusSubDoctorGroupMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubDoctorGroupMapD</IdLocation>
<IndexLocation>^dhcbsSubDoctorGroupMapI</IndexLocation>
<StreamLocation>^dhcbsSubDoctorGroupMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
