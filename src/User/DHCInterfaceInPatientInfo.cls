Class User.DHCInterfaceInPatientInfo Extends (%RegisteredObject, %XML.Adaptor, User.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property AdmissionDateTime As %String(TRUNCATE = 1);

Property BedNO As %String(TRUNCATE = 1);

Property ClinDiag As %String(TRUNCATE = 1);

Property DeptCode As %String(TRUNCATE = 1);

Property DoctorInCharge As %String(TRUNCATE = 1);

Property Memo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property VisitID As %String(TRUNCATE = 1);

Property WardCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCInterfaceInPatientInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmissionDateTime</Value>
</Value>
<Value name="3">
<Value>BedNO</Value>
</Value>
<Value name="4">
<Value>ClinDiag</Value>
</Value>
<Value name="5">
<Value>DeptCode</Value>
</Value>
<Value name="6">
<Value>DoctorInCharge</Value>
</Value>
<Value name="7">
<Value>Memo</Value>
</Value>
<Value name="8">
<Value>PatientID</Value>
</Value>
<Value name="9">
<Value>VisitID</Value>
</Value>
<Value name="10">
<Value>WardCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCInterface978D</DataLocation>
<DefaultData>DHCInterfaceInPatientInfoDefaultData</DefaultData>
<IdLocation>^User.DHCInterface978D</IdLocation>
<IndexLocation>^User.DHCInterface978I</IndexLocation>
<StreamLocation>^User.DHCInterface978S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
