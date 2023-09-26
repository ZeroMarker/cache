///     
Class dbo.BDAGCollForm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGCollForm, StorageStrategy = Default ]
{

/// Foreign Key FKAGCollFormAGAssess created via DDL
ForeignKey FKAGCollFormAGAssess(AGAssessDR) References dbo.BDAGAssess(PKBDAGASSESS) [ SqlName = FK_AGCollForm_AGAssess ];

/// Foreign Key FKAGCollFormAddUser created via DDL
ForeignKey FKAGCollFormAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollForm_AddUser ];

/// Foreign Key FKAGCollFormAgeUnit created via DDL
ForeignKey FKAGCollFormAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_AGCollForm_AgeUnit ];

/// Foreign Key FKAGCollFormBookCollUser created via DDL
ForeignKey FKAGCollFormBookCollUser(BookCollUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollForm_BookCollUser ];

/// Foreign Key FKAGCollFormCheckUser created via DDL
ForeignKey FKAGCollFormCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollForm_CheckUser ];

/// Foreign Key FKAGCollFormCollectLocation created via DDL
ForeignKey FKAGCollFormCollectLocation(CollectLocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_AGCollForm_CollectLocation ];

/// Foreign Key FKAGCollFormCollectPlace created via DDL
ForeignKey FKAGCollFormCollectPlace(CollectPlaceDR) References dbo.BBAGCollectPlace(PKBBAGCOLLECTPLACE) [ SqlName = FK_AGCollForm_CollectPlace ];

/// Foreign Key FKAGCollFormCollectWard created via DDL
ForeignKey FKAGCollFormCollectWard(CollectWardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_AGCollForm_CollectWard ];

// ForeignKey FKAGCollFormEthnicity(EthnicityDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_AGCollForm_Ethnicity ];

/// Foreign Key FKAGCollFormEthnicity created via DDL
/// Foreign Key FKAGCollFormLocation created via DDL
ForeignKey FKAGCollFormLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_AGCollForm_Location ];

/// Foreign Key FKAGCollFormRecevieUser created via DDL
ForeignKey FKAGCollFormRecevieUser(RecevieUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollForm_RecevieUser ];

/// Foreign Key FKAGCollFormSpecies created via DDL
ForeignKey FKAGCollFormSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_AGCollForm_Species ];

/// Foreign Key FKAGCollFormWard created via DDL
ForeignKey FKAGCollFormWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_AGCollForm_Ward ];

/// Foreign Key FKAGCollFormWorkGroup created via DDL
ForeignKey FKAGCollFormWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_AGCollForm_WorkGroup ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexBookCollectPlace On (BookCollDate, CollectPlaceDR) [ SqlName = Index_BookCollectPlace, Type = index ];

Index IndexBookLocation On (BookDate, LocationDR) [ SqlName = Index_BookLocation, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexLocation On (LocationDR, AddDate) [ SqlName = Index_Location, Type = index ];

Index IndexMaster On CollectFormNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, RecevieDate) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKBDAGCOLLFORM On RowID [ PrimaryKey, SqlName = PK_BD_AGCOLLFORM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property CollectFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property AGAssessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

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

Property Height As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 22 ];

Property Weight As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 23 ];

Property Pressure As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 24 ];

Property Pulse As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 25 ];

Property BodyTemp As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 26 ];

Property HealthStatus As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 27 ];

Property IsTaboo As %Library.Boolean [ SqlColumnNumber = 28 ];

Property BookDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

Property BookTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property LossVolumn As %Library.Float [ SqlColumnNumber = 31 ];

Property CollMode As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 32 ];

Property AGType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 33 ];

Property PhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 34 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 35 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 36 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 37 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 38 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 39 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

Property AssResult As %Library.Boolean [ SqlColumnNumber = 42 ];

Property AssOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 43 ];

Property BookCollDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 44 ];

Property BookCollTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 45 ];

Property BookCollUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 46 ];

Property CollectPlaceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 47 ];

Property RecevieDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 48 ];

Property RecevieTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 49 ];

Property RecevieUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 51 ];

Property CollectLocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 52 ];

Property CollectWardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

Property CollectBedNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 54 ];

Property CollectRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 55 ];

Property Status As %Library.TinyInt [ SqlColumnNumber = 56 ];

Storage Default
{
<Data name="BDAGCollFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CollectFormNo</Value>
</Value>
<Value name="3">
<Value>AGAssessDR</Value>
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
<Value>Height</Value>
</Value>
<Value name="22">
<Value>Weight</Value>
</Value>
<Value name="23">
<Value>Pressure</Value>
</Value>
<Value name="24">
<Value>Pulse</Value>
</Value>
<Value name="25">
<Value>BodyTemp</Value>
</Value>
<Value name="26">
<Value>HealthStatus</Value>
</Value>
<Value name="27">
<Value>IsTaboo</Value>
</Value>
<Value name="28">
<Value>BookDate</Value>
</Value>
<Value name="29">
<Value>BookTime</Value>
</Value>
<Value name="30">
<Value>LossVolumn</Value>
</Value>
<Value name="31">
<Value>CollMode</Value>
</Value>
<Value name="32">
<Value>AGType</Value>
</Value>
<Value name="33">
<Value>PhoneNo</Value>
</Value>
<Value name="34">
<Value>Remark</Value>
</Value>
<Value name="35">
<Value>AddDate</Value>
</Value>
<Value name="36">
<Value>AddTime</Value>
</Value>
<Value name="37">
<Value>AddUserDR</Value>
</Value>
<Value name="38">
<Value>CheckDate</Value>
</Value>
<Value name="39">
<Value>CheckTime</Value>
</Value>
<Value name="40">
<Value>CheckUserDR</Value>
</Value>
<Value name="41">
<Value>AssResult</Value>
</Value>
<Value name="42">
<Value>AssOpinion</Value>
</Value>
<Value name="43">
<Value>BookCollDate</Value>
</Value>
<Value name="44">
<Value>BookCollTime</Value>
</Value>
<Value name="45">
<Value>BookCollUserDR</Value>
</Value>
<Value name="46">
<Value>CollectPlaceDR</Value>
</Value>
<Value name="47">
<Value>RecevieDate</Value>
</Value>
<Value name="48">
<Value>RecevieTime</Value>
</Value>
<Value name="49">
<Value>RecevieUserDR</Value>
</Value>
<Value name="50">
<Value>WorkGroupDR</Value>
</Value>
<Value name="51">
<Value>CollectLocationDR</Value>
</Value>
<Value name="52">
<Value>CollectWardDR</Value>
</Value>
<Value name="53">
<Value>CollectBedNo</Value>
</Value>
<Value name="54">
<Value>CollectRemark</Value>
</Value>
<Value name="55">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGCollFormD</DataLocation>
<DefaultData>BDAGCollFormDefaultData</DefaultData>
<IdLocation>^dbo.BDAGCollFormD</IdLocation>
<IndexLocation>^dbo.BDAGCollFormI</IndexLocation>
<StreamLocation>^dbo.BDAGCollFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
