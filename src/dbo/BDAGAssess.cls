///     
Class dbo.BDAGAssess Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGAssess, StorageStrategy = Default ]
{

/// Foreign Key FKAGAssessAddUser created via DDL
ForeignKey FKAGAssessAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGAssess_AddUser ];

/// Foreign Key FKAGAssessAgeUnit created via DDL
ForeignKey FKAGAssessAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_AGAssess_AgeUnit ];

/// Foreign Key FKAGAssessCheckUser created via DDL
ForeignKey FKAGAssessCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGAssess_CheckUser ];

// ForeignKey FKAGAssessEthnicity(EthnicityDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_AGAssess_Ethnicity ];

/// Foreign Key FKAGAssessEthnicity created via DDL
/// Foreign Key FKAGAssessLocation created via DDL
ForeignKey FKAGAssessLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_AGAssess_Location ];

/// Foreign Key FKAGAssessSpecies created via DDL
ForeignKey FKAGAssessSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_AGAssess_Species ];

/// Foreign Key FKAGAssessType created via DDL
ForeignKey FKAGAssessType(AGAssessTypeDR) References dbo.BBAGAssessType(PKBBAGASSESSTYPE) [ SqlName = FK_AGAssess_Type ];

/// Foreign Key FKAGAssessWard created via DDL
ForeignKey FKAGAssessWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_AGAssess_Ward ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexLocation On (LocationDR, AddDate) [ SqlName = Index_Location, Type = index ];

Index IndexMaster On AssessNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDAGASSESS On RowID [ PrimaryKey, SqlName = PK_BD_AGASSESS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AssessNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property AGAssessTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 16 ];

Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 17 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 20 ];

Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

Property PrepMode As %Library.String(COLLATION = "Exact", MAXLEN = 4) [ SqlColumnNumber = 22 ];

Property AssContent As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 23 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 24 ];

Property IsFit As %Library.Boolean [ SqlColumnNumber = 25 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 26 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 27 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 28 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Storage Default
{
<Data name="BDAGAssessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssessNo</Value>
</Value>
<Value name="3">
<Value>AGAssessTypeDR</Value>
</Value>
<Value name="4">
<Value>AdmNo</Value>
</Value>
<Value name="5">
<Value>RegNo</Value>
</Value>
<Value name="6">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="7">
<Value>SurName</Value>
</Value>
<Value name="8">
<Value>GivenName</Value>
</Value>
<Value name="9">
<Value>SpeciesDR</Value>
</Value>
<Value name="10">
<Value>Age</Value>
</Value>
<Value name="11">
<Value>AgeUnitDR</Value>
</Value>
<Value name="12">
<Value>AgeDesc</Value>
</Value>
<Value name="13">
<Value>IDNumber</Value>
</Value>
<Value name="14">
<Value>Ethnicity</Value>
</Value>
<Value name="15">
<Value>NativePlace</Value>
</Value>
<Value name="16">
<Value>AdmType</Value>
</Value>
<Value name="17">
<Value>LocationDR</Value>
</Value>
<Value name="18">
<Value>WardDR</Value>
</Value>
<Value name="19">
<Value>BedNo</Value>
</Value>
<Value name="20">
<Value>Diagnosis</Value>
</Value>
<Value name="21">
<Value>PrepMode</Value>
</Value>
<Value name="22">
<Value>AssContent</Value>
</Value>
<Value name="23">
<Value>Remark</Value>
</Value>
<Value name="24">
<Value>IsFit</Value>
</Value>
<Value name="25">
<Value>AddDate</Value>
</Value>
<Value name="26">
<Value>AddTime</Value>
</Value>
<Value name="27">
<Value>AddUserDR</Value>
</Value>
<Value name="28">
<Value>CheckDate</Value>
</Value>
<Value name="29">
<Value>CheckTime</Value>
</Value>
<Value name="30">
<Value>CheckUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGAssessD</DataLocation>
<DefaultData>BDAGAssessDefaultData</DefaultData>
<IdLocation>^dbo.BDAGAssessD</IdLocation>
<IndexLocation>^dbo.BDAGAssessI</IndexLocation>
<StreamLocation>^dbo.BDAGAssessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
