///     
Class dbo.BDReaction Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_Reaction, StorageStrategy = Default ]
{

Index IndexRecordNo On ReactionNo [ SqlName = Index_RecordNo, Type = index, Unique ];

Index IndexDocCheckDate On DocCheckDate [ SqlName = Index_DocCheckDate, Type = index ];

Index IndexDeptCheckDate On (WorkGroupDR, DeptCheckDate) [ SqlName = Index_DeptCheckDate, Type = index ];

Index IndexRecordType On (RecordTypeDR, ConfirmDate) [ SqlName = Index_RecordType, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexLocation On LocationDR [ SqlName = Index_Location, Type = index ];

Index IndexWard On DocCheckDate [ SqlName = Index_Ward, Type = index ];

Index IndexNurSaveDate On NurSaveDate [ SqlName = Index_NurSaveDate, Type = index ];

Index IndexNurCheckDate On NurCheckDate [ SqlName = Index_NurCheckDate, Type = index ];

Index IndexDocSaveDate On DocSaveDate [ SqlName = Index_DocSaveDate, Type = index ];

Index IndexDeptReceiveDate On (WorkGroupDR, DeptReceiveDate) [ SqlName = Index_DeptReceiveDate, Type = index ];

Index IndexMedicalCheckDate On MedicalCheckDate [ SqlName = Index_MedicalCheckDate, Type = index ];

Index IndexDeptEvaluteDate On DeptEvaluteDate [ SqlName = Index_DeptEvaluteDate, Type = index ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index PKBDREACTION On RowID [ PrimaryKey, SqlName = PK_BD_REACTION, Type = index, Unique ];

ForeignKey FKBDReactionSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_BD_Reaction_Species ];

ForeignKey FKBDReactionLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_Reaction_Location ];

ForeignKey FKBDReactionWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_Reaction_Ward ];

ForeignKey FKBDReactionNurSaveUser(NurSaveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_NurSaveUser ];

ForeignKey FKBDReactionNurCheckUser(NurCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_NurCheckUser ];

ForeignKey FKBDReactionPreRecType(PreRecordTypeDR) References dbo.BBReactionType(PKBBRECTIONTYPE) [ SqlName = FK_BD_Reaction_PreRecType ];

ForeignKey FKBDReactionDocSaveUser(DocSaveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_DocSaveUser ];

ForeignKey FKBDReactionDocCheckUser(DocCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_DocCheckUser ];

ForeignKey FKBDReactionPathologicClass(PathologicClassDR) References dbo.BBPathologicClass(PKBBPATHOLOGICCLASS) [ SqlName = FK_BD_Reaction_PathologicClass ];

ForeignKey FKBDReactionWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_Reaction_WorkGroup ];

ForeignKey FKBDReactionABO(ABODR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_BD_Reaction_ABO ];

ForeignKey FKBDReactionRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_BD_Reaction_RH ];

ForeignKey FKBDReactionDeptCheckUser(DeptCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_DeptCheckUser ];

ForeignKey FKBDReactionRecordType(RecordTypeDR) References dbo.BBReactionType(PKBBRECTIONTYPE) [ SqlName = FK_BD_Reaction_RecordType ];

ForeignKey FKBDReactionConfirmUser(ConfirmUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_ConfirmUser ];

ForeignKey FKBDReactionMedicalCheckUser(MedicalCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_MedicalCheckUser ];

ForeignKey FKBDReactionDeptEvaluteUser(DeptEvaluteUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Reaction_DeptEvaluteUser ];

ForeignKey FKBDReactionAdEventType(AdEventTypeDR) References dbo.BBAdEventType(PKBBADEVENTTYPE) [ SqlName = FK_BD_Reaction_AdEventType ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReactionNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 6 ];

Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 9 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

Property IsTransHistory As %Library.Boolean [ SqlColumnNumber = 14 ];

Property LastTransDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property IsUntowardEffect As %Library.Boolean [ SqlColumnNumber = 16 ];

Property UntowardEffectNote As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 17 ];

Property IsPregHistory As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 18 ];

Property Pregnancies As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property ChildBirths As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property StartTransfusionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 21 ];

Property StartTransfusionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 22 ];

Property StopTransfusionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 23 ];

Property StopTransfusionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 24 ];

Property ReactionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 25 ];

Property ReactionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 26 ];

Property BodyTemp As %Library.Float [ SqlColumnNumber = 27 ];

Property Pulse As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

Property SystolicPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

Property DiastolicPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property Breathing As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property Hemoglobin As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 32 ];

Property IsSalvage As %Library.Boolean [ SqlColumnNumber = 33 ];

Property IsAnest As %Library.Boolean [ SqlColumnNumber = 34 ];

Property NurSaveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 35 ];

Property NurSaveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 36 ];

Property NurSaveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 37 ];

Property NurCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

Property NurCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 39 ];

Property NurCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

Property CheckCause As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 41 ];

Property ClinicalTreatment As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 42 ];

Property PerformanceRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 43 ];

Property SeriousLevel As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 44 ];

Property PreRecordTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 45 ];

Property ResultRelated As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 46 ];

Property FamilyRelated As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 47 ];

Property ResultIn As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 48 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 49 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

Property ResultNote As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 51 ];

Property Remarks As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 52 ];

Property DocSaveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

Property DocSaveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 54 ];

Property DocSaveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 55 ];

Property DocCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 56 ];

Property DocCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 57 ];

Property DocCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 58 ];

Property SampleNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 59 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 60 ];

Property DeptReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 61 ];

Property DeptReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 62 ];

Property DeptReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 63 ];

Property ABODR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 64 ];

Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 65 ];

Property BloodPhenotype As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 66 ];

Property AntibodyScreenRes As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 67 ];

Property AntiglobulinTest As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 68 ];

Property PathologicClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

Property DeptCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 70 ];

Property DeptCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 71 ];

Property DeptCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 72 ];

Property DeptRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 73 ];

Property RecordTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 74 ];

Property ConfirmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 75 ];

Property ConfirmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 76 ];

Property ConfirmUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 77 ];

Property MedicalCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 78 ];

Property MedicalCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 79 ];

Property MedicalCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 80 ];

Property MedicalRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 81 ];

Property IsReport As %Library.Boolean [ SqlColumnNumber = 82 ];

Property DeptEvaluteDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 83 ];

Property DeptEvaluteTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 84 ];

Property DeptEvaluteUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 85 ];

Property DeptEvaluteRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 86 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 87 ];

Property IsAdEvent As %Library.Boolean [ SqlColumnNumber = 88 ];

Property AdEventTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 89 ];

Storage Default
{
<Data name="BDReactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReactionNo</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="5">
<Value>SurName</Value>
</Value>
<Value name="6">
<Value>GivenName</Value>
</Value>
<Value name="7">
<Value>SpeciesDR</Value>
</Value>
<Value name="8">
<Value>AgeDesc</Value>
</Value>
<Value name="9">
<Value>LocationDR</Value>
</Value>
<Value name="10">
<Value>WardDR</Value>
</Value>
<Value name="11">
<Value>BedNo</Value>
</Value>
<Value name="12">
<Value>Diagnosis</Value>
</Value>
<Value name="13">
<Value>IsTransHistory</Value>
</Value>
<Value name="14">
<Value>LastTransDate</Value>
</Value>
<Value name="15">
<Value>IsUntowardEffect</Value>
</Value>
<Value name="16">
<Value>UntowardEffectNote</Value>
</Value>
<Value name="17">
<Value>IsPregHistory</Value>
</Value>
<Value name="18">
<Value>Pregnancies</Value>
</Value>
<Value name="19">
<Value>ChildBirths</Value>
</Value>
<Value name="20">
<Value>StartTransfusionDate</Value>
</Value>
<Value name="21">
<Value>StartTransfusionTime</Value>
</Value>
<Value name="22">
<Value>StopTransfusionDate</Value>
</Value>
<Value name="23">
<Value>StopTransfusionTime</Value>
</Value>
<Value name="24">
<Value>ReactionDate</Value>
</Value>
<Value name="25">
<Value>ReactionTime</Value>
</Value>
<Value name="26">
<Value>BodyTemp</Value>
</Value>
<Value name="27">
<Value>Pulse</Value>
</Value>
<Value name="28">
<Value>SystolicPressure</Value>
</Value>
<Value name="29">
<Value>DiastolicPressure</Value>
</Value>
<Value name="30">
<Value>Breathing</Value>
</Value>
<Value name="31">
<Value>Hemoglobin</Value>
</Value>
<Value name="32">
<Value>IsSalvage</Value>
</Value>
<Value name="33">
<Value>IsAnest</Value>
</Value>
<Value name="34">
<Value>NurSaveDate</Value>
</Value>
<Value name="35">
<Value>NurSaveTime</Value>
</Value>
<Value name="36">
<Value>NurSaveUserDR</Value>
</Value>
<Value name="37">
<Value>NurCheckDate</Value>
</Value>
<Value name="38">
<Value>NurCheckTime</Value>
</Value>
<Value name="39">
<Value>NurCheckUserDR</Value>
</Value>
<Value name="40">
<Value>CheckCause</Value>
</Value>
<Value name="41">
<Value>ClinicalTreatment</Value>
</Value>
<Value name="42">
<Value>PerformanceRemark</Value>
</Value>
<Value name="43">
<Value>SeriousLevel</Value>
</Value>
<Value name="44">
<Value>PreRecordTypeDR</Value>
</Value>
<Value name="45">
<Value>ResultRelated</Value>
</Value>
<Value name="46">
<Value>FamilyRelated</Value>
</Value>
<Value name="47">
<Value>ResultIn</Value>
</Value>
<Value name="48">
<Value>ResultDate</Value>
</Value>
<Value name="49">
<Value>ResultTime</Value>
</Value>
<Value name="50">
<Value>ResultNote</Value>
</Value>
<Value name="51">
<Value>Remarks</Value>
</Value>
<Value name="52">
<Value>DocSaveDate</Value>
</Value>
<Value name="53">
<Value>DocSaveTime</Value>
</Value>
<Value name="54">
<Value>DocSaveUserDR</Value>
</Value>
<Value name="55">
<Value>DocCheckDate</Value>
</Value>
<Value name="56">
<Value>DocCheckTime</Value>
</Value>
<Value name="57">
<Value>DocCheckUserDR</Value>
</Value>
<Value name="58">
<Value>SampleNo</Value>
</Value>
<Value name="59">
<Value>WorkGroupDR</Value>
</Value>
<Value name="60">
<Value>DeptReceiveDate</Value>
</Value>
<Value name="61">
<Value>DeptReceiveTime</Value>
</Value>
<Value name="62">
<Value>DeptReceiveUserDR</Value>
</Value>
<Value name="63">
<Value>ABODR</Value>
</Value>
<Value name="64">
<Value>RHDR</Value>
</Value>
<Value name="65">
<Value>BloodPhenotype</Value>
</Value>
<Value name="66">
<Value>AntibodyScreenRes</Value>
</Value>
<Value name="67">
<Value>AntiglobulinTest</Value>
</Value>
<Value name="68">
<Value>PathologicClassDR</Value>
</Value>
<Value name="69">
<Value>DeptCheckDate</Value>
</Value>
<Value name="70">
<Value>DeptCheckTime</Value>
</Value>
<Value name="71">
<Value>DeptCheckUserDR</Value>
</Value>
<Value name="72">
<Value>DeptRemarks</Value>
</Value>
<Value name="73">
<Value>RecordTypeDR</Value>
</Value>
<Value name="74">
<Value>ConfirmDate</Value>
</Value>
<Value name="75">
<Value>ConfirmTime</Value>
</Value>
<Value name="76">
<Value>ConfirmUserDR</Value>
</Value>
<Value name="77">
<Value>MedicalCheckDate</Value>
</Value>
<Value name="78">
<Value>MedicalCheckTime</Value>
</Value>
<Value name="79">
<Value>MedicalCheckUserDR</Value>
</Value>
<Value name="80">
<Value>MedicalRemark</Value>
</Value>
<Value name="81">
<Value>IsReport</Value>
</Value>
<Value name="82">
<Value>DeptEvaluteDate</Value>
</Value>
<Value name="83">
<Value>DeptEvaluteTime</Value>
</Value>
<Value name="84">
<Value>DeptEvaluteUserDR</Value>
</Value>
<Value name="85">
<Value>DeptEvaluteRemark</Value>
</Value>
<Value name="86">
<Value>Status</Value>
</Value>
<Value name="87">
<Value>IsAdEvent</Value>
</Value>
<Value name="88">
<Value>AdEventTypeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReactionD</DataLocation>
<DefaultData>BDReactionDefaultData</DefaultData>
<IdLocation>^dbo.BDReactionD</IdLocation>
<IndexLocation>^dbo.BDReactionI</IndexLocation>
<StreamLocation>^dbo.BDReactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
