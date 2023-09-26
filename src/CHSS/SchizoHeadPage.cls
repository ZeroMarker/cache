Class CHSS.SchizoHeadPage Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = MainPageRowId, SqlTableName = SchizoHeadPage ]
{

//最近一次治疗效果

Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

Property LockInfoRowIDDR As CHSS.DictLockInfo;

Property HeadPageCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property Intime As %Date(FORMAT = 1);

Property Doctor As User.SSUser;

Property StaffInput As User.SSUser;

Property DateOfInput As %Date(FORMAT = 1);

Property DateOfUpdate As %Date(FORMAT = 1);

Property GuardianName As %String(MAXLEN = 50, TRUNCATE = 1);

Property Relation As %String(MAXLEN = 50, TRUNCATE = 1);

Property GuardianAdd As %String(MAXLEN = 50, TRUNCATE = 1);

Property GuardianPhone As %String(MAXLEN = 100, TRUNCATE = 1);

Property CommitteePhone As %String(MAXLEN = 50, TRUNCATE = 1);

Property DateOfFirstOnset As %Date(FORMAT = 1);

Property PrimarySymptom As %String(MAXLEN = 100, TRUNCATE = 1);

Property OutPatientDR As CHSS.DictOutPatientTreat;

Property InHospitalNum As %Numeric;

Property Diagnose As %String(MAXLEN = 100, TRUNCATE = 1);

Property DiagnoseHospital As %String(MAXLEN = 100, TRUNCATE = 1);

Property DateOfDiagnose As %Date(FORMAT = 1);

Property LastTreatEffect As CHSS.DictLastTreatEffection;

Index PersonRowIdIndex On PersonRowId [ Unique ];

Storage Default
{
<Data name="SchizoHeadPageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommitteePhone</Value>
</Value>
<Value name="3">
<Value>DateOfDiagnose</Value>
</Value>
<Value name="4">
<Value>DateOfFirstOnset</Value>
</Value>
<Value name="5">
<Value>DateOfInput</Value>
</Value>
<Value name="6">
<Value>DateOfUpdate</Value>
</Value>
<Value name="7">
<Value>Diagnose</Value>
</Value>
<Value name="8">
<Value>DiagnoseHospital</Value>
</Value>
<Value name="9">
<Value>Doctor</Value>
</Value>
<Value name="10">
<Value>GuardianAdd</Value>
</Value>
<Value name="11">
<Value>GuardianName</Value>
</Value>
<Value name="12">
<Value>GuardianPhone</Value>
</Value>
<Value name="13">
<Value>HeadPageCode</Value>
</Value>
<Value name="14">
<Value>InHospitalNum</Value>
</Value>
<Value name="15">
<Value>Intime</Value>
</Value>
<Value name="16">
<Value>LastTreatEffect</Value>
</Value>
<Value name="17">
<Value>LockInfoRowIDDR</Value>
</Value>
<Value name="18">
<Value>OutPatientDR</Value>
</Value>
<Value name="19">
<Value>PersonRowId</Value>
</Value>
<Value name="20">
<Value>PrimarySymptom</Value>
</Value>
<Value name="21">
<Value>Relation</Value>
</Value>
<Value name="22">
<Value>StaffInput</Value>
</Value>
</Data>
<DataLocation>^CHSS.SchizoHeadPageD</DataLocation>
<DefaultData>SchizoHeadPageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.SchizoHeadPageD</IdLocation>
<IndexLocation>^CHSS.SchizoHeadPageI</IndexLocation>
<StreamLocation>^CHSS.SchizoHeadPageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
