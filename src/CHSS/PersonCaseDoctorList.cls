Class CHSS.PersonCaseDoctorList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DoctorList, SqlTableName = PersonCaseDoctorList ]
{

//备注

Property CaseHisRowId As CHSS.PersonCaseHis [ Required ];

Property DeptId As %Integer;

Property DoctorId As %String(MAXLEN = 50, TRUNCATE = 1);

Property cRemark As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="PersonCaseDoctorListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CaseHisRowId</Value>
</Value>
<Value name="3">
<Value>DeptId</Value>
</Value>
<Value name="4">
<Value>DoctorId</Value>
</Value>
<Value name="5">
<Value>cRemark</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonCaseDoctorListD</DataLocation>
<DefaultData>PersonCaseDoctorListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonCaseDoctorListD</IdLocation>
<IndexLocation>^CHSS.PersonCaseDoctorListI</IndexLocation>
<StreamLocation>^CHSS.PersonCaseDoctorListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
