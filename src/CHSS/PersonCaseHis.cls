Class CHSS.PersonCaseHis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = CaseHisRowId, SqlTableName = PersonCaseHis ]
{

//主任医生审核时间

Property DiagnoseRowId As CHSS.PersonDiagnoseRecord [ Required ];

Property BookRowId As %Integer;

Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

Property cCaseHis As %String(MAXLEN = 2000, TRUNCATE = 1);

Property cWord As %String(MAXLEN = 2000, TRUNCATE = 1);

Property BookDetailDR As %Integer;

Property DeptRowIdDR As %Integer;

Property DoctorId As %Integer;

Property Writedate As %Date;

Property Checkdate As %Date;

Property UpDoctorId As %Integer;

Property UpDoctordate As %Date;

Property DirectDoctorId As %Integer;

Property PatientCode As %String(MAXLEN = 30, TRUNCATE = 1);

Property SpellCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property PatientName As %String(MAXLEN = 50, TRUNCATE = 1);

Property ParentTypeDR As %Integer;

Property PrintNo As %Integer;

Property PatientActionDR As %Integer;

Property CaseHisTipId As %Integer;

Property DirectDoctordate As %Date;

Index PersonRowIdParrefIndex On PersonRowId;

Storage Default
{
<Data name="PersonCaseHisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BookDetailDR</Value>
</Value>
<Value name="3">
<Value>BookRowId</Value>
</Value>
<Value name="4">
<Value>CaseHisTipId</Value>
</Value>
<Value name="5">
<Value>Checkdatetime</Value>
</Value>
<Value name="6">
<Value>DeptRowIdDR</Value>
</Value>
<Value name="7">
<Value>DiagnoseRowId</Value>
</Value>
<Value name="8">
<Value>DirectDoctorId</Value>
</Value>
<Value name="9">
<Value>DirectDoctordatetime</Value>
</Value>
<Value name="10">
<Value>DoctorId</Value>
</Value>
<Value name="11">
<Value>ParentTypeDR</Value>
</Value>
<Value name="12">
<Value>PatientActionDR</Value>
</Value>
<Value name="13">
<Value>PatientCode</Value>
</Value>
<Value name="14">
<Value>PatientName</Value>
</Value>
<Value name="15">
<Value>PersonRowId</Value>
</Value>
<Value name="16">
<Value>PrintNo</Value>
</Value>
<Value name="17">
<Value>SpellCode</Value>
</Value>
<Value name="18">
<Value>UpDoctorId</Value>
</Value>
<Value name="19">
<Value>UpDoctordatetime</Value>
</Value>
<Value name="20">
<Value>Writedatetime</Value>
</Value>
<Value name="21">
<Value>cCaseHis</Value>
</Value>
<Value name="22">
<Value>cWord</Value>
</Value>
<Value name="23">
<Value>Checkdate</Value>
</Value>
<Value name="24">
<Value>DirectDoctordate</Value>
</Value>
<Value name="25">
<Value>UpDoctordate</Value>
</Value>
<Value name="26">
<Value>Writedate</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonCaseHisD</DataLocation>
<DefaultData>PersonCaseHisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonCaseHisD</IdLocation>
<IndexLocation>^CHSS.PersonCaseHisI</IndexLocation>
<StreamLocation>^CHSS.PersonCaseHisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
