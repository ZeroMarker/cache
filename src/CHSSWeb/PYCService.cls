Class CHSSWeb.PYCService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod PersonCheckList(communityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
}

ClassMethod Insert(PersonCode As %String, CommunityCode As %String, PersonName As %String, SexDR As %Integer, Birth As %Date, SpellCode As %String, CardNumber As %String, IDCard As %String, BirthPlace As %String, DateOfWork As %Date, WorkPlace As %String, DateOFRetire As %Date, DeformityCode As %String, RelationHourseHoldDR As %Integer, DoctorRegister As %Integer, NurseRegister As %Integer, OperatorInput As %Integer, NationalityDR As %Integer, FamilyRowId As %Integer, HouseHoldTypeDR As %Integer, DocimialTypeDR As %Integer, MedicalInsuranceTypeDR As %Integer, PointHospitalRowIdDR As %Integer, CommitteeDR As %Integer, PoliceRowIdDR As %Integer, StreetRowIdDR As %Integer, DeformityType As %Integer, StaffOfUpdate As %Integer, DateOfUpdate As %Date, NationDR As %Integer, BloodTypeDR As %Integer, MarriageDR As %Integer, EducationDR As %Integer, ProfessionDR As %Integer) As %String
{
}

ClassMethod Update1(PersonRowId As %Integer, PersonName As %String, SexDR As %Integer, PoliceRowIdDR As %Integer) As %String
{
}

ClassMethod Update(PersonRowId As %Integer, PersonName As %String, SexDR As %Integer, Birth As %Date, SpellCode As %String, CardNumber As %String, IDCard As %String, BirthPlace As %String, DateOfWork As %Date, WorkPlace As %String, DateOFRetire As %Date, DeformityCode As %String, RelationHourseHoldDR As %Integer, DoctorRegister As %Integer, NurseRegister As %Integer, OperatorInput As %Integer, NationalityDR As %Integer, FamilyRowId As %Integer, HouseHoldTypeDR As %Integer, DocimialTypeDR As %Integer, MedicalInsuranceTypeDR As %Integer, PointHospitalRowIdDR As %Integer, CommitteeDR As %Integer, PoliceRowIdDR As %Integer, StreetRowIdDR As %Integer, DeformityType As %Integer, StaffOfUpdate As %Integer, DateOfUpdate As %Date, NationDR As %Integer, BloodTypeDR As %Integer, MarriageDR As %Integer, EducationDR As %Integer, ProfessionDR As %Integer) As %String
{
}

Storage Default
{
<Data name="PYCServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PYCServiceD</DataLocation>
<DefaultData>PYCServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PYCServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PYCServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PYCServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
