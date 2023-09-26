///     
Class dbo.BDAutologousAss Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AutologousAss, StorageStrategy = Default ]
{

/// Foreign Key FKAutologousAssAddUser created via DDL
ForeignKey FKAutologousAssAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FKAutologousAssAddUser ];

/// Foreign Key FKAutologousAssAgeUnit created via DDL
ForeignKey FKAutologousAssAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FKAutologousAssAgeUnit ];

/// Foreign Key FKAutologousAssCertType created via DDL
ForeignKey FKAutologousAssCertType(CertTypeDR) References dbo.BTCertType(PKBTCERTTYPE) [ SqlName = FKAutologousAssCertType ];

/// Foreign Key FKAutologousAssLocation created via DDL
ForeignKey FKAutologousAssLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FKAutologousAssLocation ];

/// Foreign Key FKAutologousAssSpecies created via DDL
ForeignKey FKAutologousAssSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FKAutologousAssSpecies ];

/// Foreign Key FKAutologousAssWard created via DDL
ForeignKey FKAutologousAssWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FKAutologousAssWard ];

/// Foreign Key FKAutologousAssAddUser created via DDL
ForeignKey FKAutologousAssCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FKAutologousAssCheckUser ];

Index IndexAdmNo On (AdmNo, AutologousAssType) [ SqlName = Index_AdmNo, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexMaster On AutologousAssNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexRegNo On (RegNo, AutologousAssType) [ SqlName = Index_RegNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDAutologousAss On RowID [ PrimaryKey, SqlName = PK_BD_AutologousAss, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property AutologousAssNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property AutologousAssType As %Library.SmallInt [ Required, SqlColumnNumber = 4 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 9 ];

Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

Property CertTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 18) [ SqlColumnNumber = 19 ];

Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 18) [ SqlColumnNumber = 20 ];

Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 21 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 24 ];

Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 25 ];

Property IsMatchAntoreInfusion As %Library.Boolean [ SqlColumnNumber = 26 ];

Property AntoreInfusionMethod As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 27 ];

Property Asscontent As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 28 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 29 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Storage Default
{
<Data name="BDAutologousAssDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AutologousAssNo</Value>
</Value>
<Value name="3">
<Value>AutologousAssType</Value>
</Value>
<Value name="4">
<Value>AdmNo</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>RegNo</Value>
</Value>
<Value name="9">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="10">
<Value>SurName</Value>
</Value>
<Value name="11">
<Value>GivenName</Value>
</Value>
<Value name="12">
<Value>SpeciesDR</Value>
</Value>
<Value name="13">
<Value>Age</Value>
</Value>
<Value name="14">
<Value>AgeUnitDR</Value>
</Value>
<Value name="15">
<Value>AgeDesc</Value>
</Value>
<Value name="16">
<Value>CertTypeDR</Value>
</Value>
<Value name="17">
<Value>CertNo</Value>
</Value>
<Value name="18">
<Value>IDNumber</Value>
</Value>
<Value name="19">
<Value>Ethnicity</Value>
</Value>
<Value name="20">
<Value>NativePlace</Value>
</Value>
<Value name="21">
<Value>LocationDR</Value>
</Value>
<Value name="22">
<Value>WardDR</Value>
</Value>
<Value name="23">
<Value>BedNo</Value>
</Value>
<Value name="24">
<Value>Diagnosis</Value>
</Value>
<Value name="25">
<Value>IsMatchAntoreInfusion</Value>
</Value>
<Value name="26">
<Value>AntoreInfusionMethod</Value>
</Value>
<Value name="27">
<Value>Asscontent</Value>
</Value>
<Value name="28">
<Value>Remark</Value>
</Value>
<Value name="29">
<Value>CheckDate</Value>
</Value>
<Value name="30">
<Value>CheckTime</Value>
</Value>
<Value name="31">
<Value>CheckUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAutologousAssD</DataLocation>
<DefaultData>BDAutologousAssDefaultData</DefaultData>
<IdLocation>^dbo.BDAutologousAssD</IdLocation>
<IndexLocation>^dbo.BDAutologousAssI</IndexLocation>
<StreamLocation>^dbo.BDAutologousAssS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
