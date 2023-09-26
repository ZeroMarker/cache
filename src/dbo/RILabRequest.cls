///     
Class dbo.RILabRequest Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RI_LabRequest ]
{

// Property RowId As %Library.BigInt(MINVAL = 1) [ Identity, Required, SqlColumnNumber = 2 ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberFrom As %Library.String(COLLATION = "EXACT", MAXLEN = 4) [ Required, SqlColumnNumber = 3 ];

Property AdmissionType As %Library.String(COLLATION = "EXACT", MAXLEN = 2) [ Required, SqlColumnNumber = 4 ];

Property RegNo As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ Required, SqlColumnNumber = 5 ];

Property AdmNo As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ Required, SqlColumnNumber = 6 ];

Property MedicalRecordNo As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ SqlColumnNumber = 7 ];

Property AdmDate As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 8 ];

Property AdmTime As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 9 ];

Property CertType As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 10 ];

Property CertNo As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 11 ];

Property IDNumber As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property PaymentType As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Property PaymentName As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Property SurName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ Required, SqlColumnNumber = 15 ];

Property GivenName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 16 ];

Property SpeciesID As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ Required, SqlColumnNumber = 17 ];

Property SpeciesName As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 18 ];

Property BirthDate As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 19 ];

Property BirthTime As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 20 ];

Property Age As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 21 ];

Property AgeUnit As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 22 ];

Property Ethnicity As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 23 ];

Property HospitaID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 24 ];

Property HospitaName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 25 ];

Property SymptomID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 26 ];

Property Symptom As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 27 ];

Property MobileNo As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 28 ];

Property PhoneNo As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 29 ];

Property email As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 30 ];

Property Height As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 31 ];

Property Weight As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 32 ];

Property BloodPressure As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 33 ];

Property ClinicalConditions As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 34 ];

Property Pregnant As %Library.Boolean [ SqlColumnNumber = 35 ];

Property PregnantWeeks As %Library.String(COLLATION = "EXACT", MAXLEN = 5) [ SqlColumnNumber = 36 ];

Property ABO As %Library.String(COLLATION = "EXACT", MAXLEN = 2) [ SqlColumnNumber = 37 ];

Property RH As %Library.String(COLLATION = "EXACT", MAXLEN = 2) [ SqlColumnNumber = 38 ];

Property Address As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 39 ];

Property PostCode As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 40 ];

Property InfectFlag As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 41 ];

Property InfectAlert As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 42 ];

Property PregnantNum As %Library.String(COLLATION = "EXACT", MAXLEN = 2) [ SqlColumnNumber = 43 ];

Property ChildbirthNum As %Library.String(COLLATION = "EXACT", MAXLEN = 2) [ SqlColumnNumber = 44 ];

Index AdmDate On (RegNo, AdmDate) [ SqlName = AdmDate, Type = index ];

Index AdmNo On AdmNo [ SqlName = AdmNo, Type = index ];

// Index PKRILabRequest On RowId [ IdKey, PrimaryKey, SqlName = PK_RI_LabRequest, Unique ];

/// DDL Primary Key Specification
Index PKRILabRequest On RowID [ PrimaryKey, SqlName = PK_RI_LabRequest, Type = index, Unique ];

Index PKRIRequest On (VisitNumberFrom, AdmissionType, AdmNo) [ SqlName = PKRIRequest, Type = index, Unique ];

Index RegNo On (RegNo, AdmNo) [ SqlName = RegNo, Type = index ];

Storage Default
{
<Data name="RILabRequestDefaultData">
<Value name="1">
<Value>VisitNumberFrom</Value>
</Value>
<Value name="2">
<Value>AdmissionType</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>AdmNo</Value>
</Value>
<Value name="5">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="6">
<Value>AdmDate</Value>
</Value>
<Value name="7">
<Value>AdmTime</Value>
</Value>
<Value name="8">
<Value>CertType</Value>
</Value>
<Value name="9">
<Value>CertNo</Value>
</Value>
<Value name="10">
<Value>IDNumber</Value>
</Value>
<Value name="11">
<Value>PaymentType</Value>
</Value>
<Value name="12">
<Value>PaymentName</Value>
</Value>
<Value name="13">
<Value>SurName</Value>
</Value>
<Value name="14">
<Value>GivenName</Value>
</Value>
<Value name="15">
<Value>SpeciesID</Value>
</Value>
<Value name="16">
<Value>SpeciesName</Value>
</Value>
<Value name="17">
<Value>BirthDate</Value>
</Value>
<Value name="18">
<Value>BirthTime</Value>
</Value>
<Value name="19">
<Value>Age</Value>
</Value>
<Value name="20">
<Value>AgeUnit</Value>
</Value>
<Value name="21">
<Value>Ethnicity</Value>
</Value>
<Value name="22">
<Value>HospitaID</Value>
</Value>
<Value name="23">
<Value>HospitaName</Value>
</Value>
<Value name="24">
<Value>SymptomID</Value>
</Value>
<Value name="25">
<Value>Symptom</Value>
</Value>
<Value name="26">
<Value>MobileNo</Value>
</Value>
<Value name="27">
<Value>PhoneNo</Value>
</Value>
<Value name="28">
<Value>email</Value>
</Value>
<Value name="29">
<Value>Height</Value>
</Value>
<Value name="30">
<Value>Weight</Value>
</Value>
<Value name="31">
<Value>BloodPressure</Value>
</Value>
<Value name="32">
<Value>ClinicalConditions</Value>
</Value>
<Value name="33">
<Value>Pregnant</Value>
</Value>
<Value name="34">
<Value>PregnantWeeks</Value>
</Value>
<Value name="35">
<Value>ABO</Value>
</Value>
<Value name="36">
<Value>RH</Value>
</Value>
<Value name="37">
<Value>Address</Value>
</Value>
<Value name="38">
<Value>PostCode</Value>
</Value>
<Value name="39">
<Value>InfectFlag</Value>
</Value>
<Value name="40">
<Value>InfectAlert</Value>
</Value>
<Value name="41">
<Value>PregnantNum</Value>
</Value>
<Value name="42">
<Value>ChildbirthNum</Value>
</Value>
</Data>
<DataLocation>^dbo.RILabRequestD</DataLocation>
<DefaultData>RILabRequestDefaultData</DefaultData>
<IdFunction>sequence</IdFunction>
<IdLocation>^dbo.RILabRequestD</IdLocation>
<IndexLocation>^dbo.RILabRequestI</IndexLocation>
<StreamLocation>^dbo.RILabRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
