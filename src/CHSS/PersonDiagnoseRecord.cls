Class CHSS.PersonDiagnoseRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DiagnoseRowId, SqlTableName = PersonDiagnoseRecord ]
{

//就诊医院名称

Property PatientRowId As CHSS.PatientActivate [ Required ];

Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ Required ];

Property ClinicFlag As %Integer;

Property YearsUnit As %Integer;

Property PatientTypeID As %Integer;

Property DoctorID As %String(MAXLEN = 50, TRUNCATE = 1);

Property CureDoctorId As %String(MAXLEN = 50, TRUNCATE = 1);

Property GetDoctorID As %String(MAXLEN = 50, TRUNCATE = 1);

Property DiagnoseDate As %Date;

Property PatientCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property PatientName As %String(MAXLEN = 50, TRUNCATE = 1);

Property SpellCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property SexDR As %Integer;

Property CaseCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property CardCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property DiagnoseCardCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property RegisterDate As %Date;

Property Keenness As %String(MAXLEN = 100, TRUNCATE = 1);

Property PrintFlag As %String(MAXLEN = 6, TRUNCATE = 1);

Property PrintDate As %Date;

Property PrintNum As %Integer;

Property NearUseDate As %Date;

Property ValidFlag As %String(MAXLEN = 6, TRUNCATE = 1);

Property DiagnoseFlag As %Integer;

Property DiagResult As %String(MAXLEN = 100, TRUNCATE = 1);

Property ICDCode As %String(MAXLEN = 50, TRUNCATE = 1);

Property bRequestInHosFlag As %Integer;

Property bHospitalFlag As %Integer;

Property DiganoseOPId As %String(MAXLEN = 50, TRUNCATE = 1);

Property OutDate As %Date;

Property OutFlag As %Integer;

Property Nurse As %String(MAXLEN = 50, TRUNCATE = 1);

Property bCheckDeptFlag As %Integer;

Property CheckDeptDate As %Date;

Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1);

Property HospitalName As %String(MAXLEN = 80, TRUNCATE = 1);

Index PersonRowIdParrefIndex On PersonRowIdParref;

Storage Default
{
<Data name="PersonDiagnoseRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CardCode</Value>
</Value>
<Value name="3">
<Value>CaseCode</Value>
</Value>
<Value name="4">
<Value>CheckDeptDate</Value>
</Value>
<Value name="5">
<Value>ClinicFlag</Value>
</Value>
<Value name="6">
<Value>CommunityCode</Value>
</Value>
<Value name="7">
<Value>CureDoctorId</Value>
</Value>
<Value name="8">
<Value>DiagResult</Value>
</Value>
<Value name="9">
<Value>DiagnoseCardCode</Value>
</Value>
<Value name="10">
<Value>DiagnoseDate</Value>
</Value>
<Value name="11">
<Value>DiagnoseFlag</Value>
</Value>
<Value name="12">
<Value>DiagnoseRowId</Value>
</Value>
<Value name="13">
<Value>DiganoseOPId</Value>
</Value>
<Value name="14">
<Value>DoctorID</Value>
</Value>
<Value name="15">
<Value>GetDoctorID</Value>
</Value>
<Value name="16">
<Value>HospitalName</Value>
</Value>
<Value name="17">
<Value>ICDCode</Value>
</Value>
<Value name="18">
<Value>Keenness</Value>
</Value>
<Value name="19">
<Value>NearUseDate</Value>
</Value>
<Value name="20">
<Value>Nurse</Value>
</Value>
<Value name="21">
<Value>OutDate</Value>
</Value>
<Value name="22">
<Value>OutFlag</Value>
</Value>
<Value name="23">
<Value>PatientCode</Value>
</Value>
<Value name="24">
<Value>PatientName</Value>
</Value>
<Value name="25">
<Value>PatientRowId</Value>
</Value>
<Value name="26">
<Value>PatientTypeID</Value>
</Value>
<Value name="27">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="28">
<Value>PrintDate</Value>
</Value>
<Value name="29">
<Value>PrintFlag</Value>
</Value>
<Value name="30">
<Value>PrintNum</Value>
</Value>
<Value name="31">
<Value>RegisterDate</Value>
</Value>
<Value name="32">
<Value>SexDR</Value>
</Value>
<Value name="33">
<Value>SpellCode</Value>
</Value>
<Value name="34">
<Value>ValidFlag</Value>
</Value>
<Value name="35">
<Value>YearsUnit</Value>
</Value>
<Value name="36">
<Value>bCheckDeptFlag</Value>
</Value>
<Value name="37">
<Value>bHospitalFlag</Value>
</Value>
<Value name="38">
<Value>bRequestInHosFlag</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonDiagnoseRecordD</DataLocation>
<DefaultData>PersonDiagnoseRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonDiagnoseRecordD</IdLocation>
<IndexLocation>^CHSS.PersonDiagnoseRecordI</IndexLocation>
<StreamLocation>^CHSS.PersonDiagnoseRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
