/// SH奖金医生组BonusSubDoctorGroup
Class dhc.bonus.subs.BonusSubDoctorGroup Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubDoctorGroupID ]
{

Property DoctorGroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property DoctorGroupName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusSubDoctorGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DoctorGroupCode</Value>
</Value>
<Value name="3">
<Value>DoctorGroupName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubDoctorGroupD</DataLocation>
<DefaultData>BonusSubDoctorGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubDoctorGroupDD</IdLocation>
<IndexLocation>^dhcbsSubDoctorGroupDI</IndexLocation>
<StreamLocation>^dhcbsSubDoctorGroupDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
