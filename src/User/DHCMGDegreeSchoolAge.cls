Class User.DHCMGDegreeSchoolAge Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_Degree_SchoolAge ]
{

// 学历学位

Property PersonDr As User.DHCMGPersons;

Property DegSchSchool As User.DHCMGCCode;

Property DegSchDegree As User.DHCMGCCode;

Property DegSchStDate As %Library.Date(FORMAT = 1);

Property DegSchEdDate As %Library.Date(FORMAT = 1);

Property DegSchCurrent As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

Index Person On PersonDr;

Storage Default
{
<Data name="DHCMGDegreeSchoolAgeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DegSchCurrent</Value>
</Value>
<Value name="3">
<Value>DegSchDegree</Value>
</Value>
<Value name="4">
<Value>DegSchEdDate</Value>
</Value>
<Value name="5">
<Value>DegSchSchool</Value>
</Value>
<Value name="6">
<Value>DegSchStDate</Value>
</Value>
<Value name="7">
<Value>PersonDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGDegreeSchoolAgeD</DataLocation>
<DefaultData>DHCMGDegreeSchoolAgeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGDegreeSchoolAgeD</IdLocation>
<IndexLocation>^User.DHCMGDegreeSchoolAgeI</IndexLocation>
<StreamLocation>^User.DHCMGDegreeSchoolAgeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
