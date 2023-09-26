///     
Class dbo.BDMutualAidDonateReg Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_MutualAidDonateReg, StorageStrategy = Default ]
{

/// Foreign Key FKBDMutualAidDonationABO created via DDL
ForeignKey FKBDMutualAidDonationABO(ABODR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FKBDMutualAidDonationABO ];

/// Foreign Key FKBDMutualAidDonationAddUser created via DDL
ForeignKey FKBDMutualAidDonationAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FKBDMutualAidDonationAddUser ];

/// Foreign Key FKBDMutualAidDonationDonBloodGroup created via DDL
ForeignKey FKBDMutualAidDonationDonBloodGroup(DonorBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FKBDMutualAidDonationDonBloodGroup ];

/// Foreign Key FKBDMutualAidDonationLocation created via DDL
ForeignKey FKBDMutualAidDonationLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FKBDMutualAidDonationLocation ];

/// Foreign Key FKBDMutualAidDonationRH created via DDL
ForeignKey FKBDMutualAidDonationRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FKBDMutualAidDonationRH ];

/// Foreign Key FKBDMutualAidDonationSpecies created via DDL
ForeignKey FKBDMutualAidDonationSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FKBDMutualAidDonationSpecies ];

/// Foreign Key FKBDMutualAidDonationWard created via DDL
ForeignKey FKBDMutualAidDonationWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FKBDMutualAidDonationWard ];

/// Foreign Key FKBDMutualAidDonationWorkGroup created via DDL
ForeignKey FKBDMutualAidDonationWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FKBDMutualAidDonationWorkGroup ];

Index IndexAddDate On (AddDate, WorkGroupDR) [ SqlName = Index_AddDate, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexMaster On DonateNo [ SqlName = Index_Master, Type = index ];

Index IndexMedicalRecordNo On MedicalRecordNo [ SqlName = Index_MedicalRecordNo, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDMutualAidDonation On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property DonateNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 8 ];

Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property ABODR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Age As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 17 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 20 ];

Property DonorName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 21 ];

Property DonorRelationShip As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 22 ];

Property DonorBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property DonorPackVolumn As %Library.Float [ Required, SqlColumnNumber = 24 ];

Property DonorPackID As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 25 ];

Property BookDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Property BookTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 28 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 30 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

Storage Default
{
<Data name="BDMutualAidDonateRegDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DonateNo</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>AdmNo</Value>
</Value>
<Value name="7">
<Value>RegNo</Value>
</Value>
<Value name="8">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="9">
<Value>SurName</Value>
</Value>
<Value name="10">
<Value>GivenName</Value>
</Value>
<Value name="11">
<Value>SpeciesDR</Value>
</Value>
<Value name="12">
<Value>ABODR</Value>
</Value>
<Value name="13">
<Value>RHDR</Value>
</Value>
<Value name="14">
<Value>Age</Value>
</Value>
<Value name="15">
<Value>AgeDesc</Value>
</Value>
<Value name="16">
<Value>LocationDR</Value>
</Value>
<Value name="17">
<Value>WardDR</Value>
</Value>
<Value name="18">
<Value>BedNo</Value>
</Value>
<Value name="19">
<Value>Diagnosis</Value>
</Value>
<Value name="20">
<Value>DonorName</Value>
</Value>
<Value name="21">
<Value>DonorRelationShip</Value>
</Value>
<Value name="22">
<Value>DonorBloodGroupDR</Value>
</Value>
<Value name="23">
<Value>DonorPackVolumn</Value>
</Value>
<Value name="24">
<Value>DonorPackID</Value>
</Value>
<Value name="25">
<Value>BookDate</Value>
</Value>
<Value name="26">
<Value>BookTime</Value>
</Value>
<Value name="27">
<Value>WorkGroupDR</Value>
</Value>
<Value name="28">
<Value>Status</Value>
</Value>
<Value name="29">
<Value>Remark</Value>
</Value>
<Value name="30">
<Value>CheckDate</Value>
</Value>
<Value name="31">
<Value>CheckTime</Value>
</Value>
<Value name="32">
<Value>CheckUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDMutualAidDonateRegD</DataLocation>
<DefaultData>BDMutualAidDonateRegDefaultData</DefaultData>
<IdLocation>^dbo.BDMutualAidDonateRegD</IdLocation>
<IndexLocation>^dbo.BDMutualAidDonateRegI</IndexLocation>
<StreamLocation>^dbo.BDMutualAidDonateRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
