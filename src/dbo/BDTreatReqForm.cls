Class dbo.BDTreatReqForm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TreatReqForm, StorageStrategy = Default ]
{

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexAgreeFormNo On AgreeFormNo [ SqlName = Index_AgreeFormNo, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexMedicalRecordNo On MedicalRecordNo [ SqlName = Index_MedicalRecordNo, Type = index ];

Index IndexReceiveDate On ReceiveDate [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexReceiveUserDR On (ReceiveUserDR, ReceiveDate) [ SqlName = Index_ReceiveUserDR, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexReqFormNo On ReqFormNo [ SqlName = Index_TRReqFormNo, Type = index, Unique ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexWorkGroupDR On (WorkGroupDR, ReceiveDate) [ SqlName = Index_WorkGroupDR, Type = index ];

/// DDL Primary Key Specification
Index PKBDTRREQFORM On RowID [ PrimaryKey, SqlName = PK_BD_TRREQFORM, Type = index, Unique ];

/// Foreign Key FKBDReqABO created via DDL
ForeignKey FKBDReqABO(ABODR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_BD_TRReq_ABO ];

/// Foreign Key FKBDReqAddUser created via DDL
ForeignKey FKBDReqAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRReq_AddUser ];

/// Foreign Key FKBDReqAgeUnit created via DDL
ForeignKey FKBDReqAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_BD_TRReq_AgeUnit ];

/// Foreign Key FKBDReqCertType created via DDL
ForeignKey FKBDReqCertType(CertTypeDR) References dbo.BTCertType(PKBTCERTTYPE) [ SqlName = FK_BD_TRReq_CertType ];

/// Foreign Key FKBDReqCheckUser created via DDL
ForeignKey FKBDReqCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRReq_CheckUser ];

/// Foreign Key FKBDReqEthnicity created via DDL
/// Foreign Key FKBDReqKeestBloodGroup created via DDL
ForeignKey FKBDReqKeestBloodGroup(KeestBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_TRReq_KeestBloodGroup ];

/// Foreign Key FKBDReqLocation created via DDL
ForeignKey FKBDReqLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_TRReq_Location ];

/// Foreign Key FKBDReqOrganBloodGroup created via DDL
ForeignKey FKBDReqOrganBloodGroup(OrganBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_TRReq_OrganBloodGroup ];

/// Foreign Key FKBDReqRH created via DDL
ForeignKey FKBDReqRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_BD_TRReq_RH ];

/// Foreign Key FKBDReqReceiveUser created via DDL
ForeignKey FKBDReqReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRReq_ReceiveUser ];

/// Foreign Key FKBDReqSpecies created via DDL
ForeignKey FKBDReqSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_BD_TRReq_Species ];

/// Foreign Key FKBDReqWard created via DDL
ForeignKey FKBDReqWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_TRReq_Ward ];

/// Foreign Key FKBDReqWorkGroup created via DDL
ForeignKey FKBDReqWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_TRReq_WorkGroup ];

/// Foreign Key FKBDReqAddUser created via DDL
ForeignKey FKBDReqCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRReq_CancelUser ];

/// Foreign Key FKBDRefuseUser created via DDL
ForeignKey FKBDReqRefuseUser(RefuseUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRReq_RefuseUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

Property CertTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 18) [ SqlColumnNumber = 18 ];

Property ABODR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property RareBloodGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 22 ];

Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 27 ];

Property IsOrganExplant As %Library.Boolean [ SqlColumnNumber = 28 ];

Property OrganBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

Property IsKeestExplant As %Library.Boolean [ SqlColumnNumber = 30 ];

Property KeestBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property IsDrugHistory As %Library.Boolean [ SqlColumnNumber = 32 ];

Property DrugList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 33 ];

Property IsPregHistory As %Library.Boolean [ SqlColumnNumber = 34 ];

Property Pregnancies As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

Property ChildBirths As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

Property AssHeart As %Library.SmallInt [ SqlColumnNumber = 37 ];

Property AssLiver As %Library.SmallInt [ SqlColumnNumber = 38 ];

Property AssKidney As %Library.SmallInt [ SqlColumnNumber = 39 ];

Property AssLung As %Library.SmallInt [ SqlColumnNumber = 40 ];

Property AssHypertensive As %Library.SmallInt [ SqlColumnNumber = 41 ];

Property AgreeFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 42 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 43 ];

/// 10 创建 25 审核 15 作废 35 接收 
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 44 ];

Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 45 ];

Property CheckCause As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 46 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 47 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 48 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 49 ];

Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 51 ];

Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 52 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

Property Weight As %Library.Float [ SqlColumnNumber = 54 ];

Property Height As %Library.Float [ SqlColumnNumber = 55 ];

Property BldPressure As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 56 ];

Property Pulse As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 57 ];

Property BodyTemp As %Library.Float [ SqlColumnNumber = 58 ];

Property IsTransHistory As %Library.Boolean [ SqlColumnNumber = 59 ];

Property LastTransDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 60 ];

Property IsUntowardEffect As %Library.Boolean [ SqlColumnNumber = 61 ];

Property UntowardEffectNote As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 62 ];

Property CancelReceiveRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 63 ];

Property RefuseReceiveRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 64 ];

Property RefuseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 65 ];

Property RefuseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 66 ];

Property RefuseUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 67 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 68 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 70 ];

Storage Default
{
<Data name="BDTreatReqFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormNo</Value>
</Value>
<Value name="3">
<Value>AdmNo</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
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
<Value>Age</Value>
</Value>
<Value name="13">
<Value>AgeUnitDR</Value>
</Value>
<Value name="14">
<Value>AgeDesc</Value>
</Value>
<Value name="15">
<Value>CertTypeDR</Value>
</Value>
<Value name="16">
<Value>CertNo</Value>
</Value>
<Value name="17">
<Value>IDNumber</Value>
</Value>
<Value name="18">
<Value>ABODR</Value>
</Value>
<Value name="19">
<Value>RHDR</Value>
</Value>
<Value name="20">
<Value>RareBloodGroup</Value>
</Value>
<Value name="21">
<Value>Ethnicity</Value>
</Value>
<Value name="22">
<Value>NativePlace</Value>
</Value>
<Value name="23">
<Value>LocationDR</Value>
</Value>
<Value name="24">
<Value>WardDR</Value>
</Value>
<Value name="25">
<Value>BedNo</Value>
</Value>
<Value name="26">
<Value>Diagnosis</Value>
</Value>
<Value name="27">
<Value>IsOrganExplant</Value>
</Value>
<Value name="28">
<Value>OrganBloodGroupDR</Value>
</Value>
<Value name="29">
<Value>IsKeestExplant</Value>
</Value>
<Value name="30">
<Value>KeestBloodGroupDR</Value>
</Value>
<Value name="31">
<Value>IsDrugHistory</Value>
</Value>
<Value name="32">
<Value>DrugList</Value>
</Value>
<Value name="33">
<Value>IsPregHistory</Value>
</Value>
<Value name="34">
<Value>Pregnancies</Value>
</Value>
<Value name="35">
<Value>ChildBirths</Value>
</Value>
<Value name="36">
<Value>AssHeart</Value>
</Value>
<Value name="37">
<Value>AssLiver</Value>
</Value>
<Value name="38">
<Value>AssKidney</Value>
</Value>
<Value name="39">
<Value>AssLung</Value>
</Value>
<Value name="40">
<Value>AssHypertensive</Value>
</Value>
<Value name="41">
<Value>AgreeFormNo</Value>
</Value>
<Value name="42">
<Value>Remark</Value>
</Value>
<Value name="43">
<Value>Status</Value>
</Value>
<Value name="44">
<Value>AdmType</Value>
</Value>
<Value name="45">
<Value>CheckCause</Value>
</Value>
<Value name="46">
<Value>CheckDate</Value>
</Value>
<Value name="47">
<Value>CheckTime</Value>
</Value>
<Value name="48">
<Value>CheckUserDR</Value>
</Value>
<Value name="49">
<Value>ReceiveDate</Value>
</Value>
<Value name="50">
<Value>ReceiveTime</Value>
</Value>
<Value name="51">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="52">
<Value>WorkGroupDR</Value>
</Value>
<Value name="53">
<Value>Weight</Value>
</Value>
<Value name="54">
<Value>Height</Value>
</Value>
<Value name="55">
<Value>BldPressure</Value>
</Value>
<Value name="56">
<Value>Pulse</Value>
</Value>
<Value name="57">
<Value>BodyTemp</Value>
</Value>
<Value name="58">
<Value>IsTransHistory</Value>
</Value>
<Value name="59">
<Value>LastTransDate</Value>
</Value>
<Value name="60">
<Value>IsUntowardEffect</Value>
</Value>
<Value name="61">
<Value>UntowardEffectNote</Value>
</Value>
<Value name="62">
<Value>CancelReceiveRemark</Value>
</Value>
<Value name="63">
<Value>RefuseReceiveRemark</Value>
</Value>
<Value name="64">
<Value>RefuseDate</Value>
</Value>
<Value name="65">
<Value>RefuseTime</Value>
</Value>
<Value name="66">
<Value>RefuseUserDR</Value>
</Value>
<Value name="67">
<Value>CancelDate</Value>
</Value>
<Value name="68">
<Value>CancleTime</Value>
</Value>
<Value name="69">
<Value>CancelUserDR</Value>
</Value>
<Value name="70">
<Value>CancelTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTreatReqFormD</DataLocation>
<DefaultData>BDTreatReqFormDefaultData</DefaultData>
<IdLocation>^dbo.BDTreatReqFormD</IdLocation>
<IndexLocation>^dbo.BDTreatReqFormI</IndexLocation>
<StreamLocation>^dbo.BDTreatReqFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
