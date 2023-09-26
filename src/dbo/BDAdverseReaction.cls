/// 输血不良反应记录单
Class dbo.BDAdverseReaction Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AdverseReaction, StorageStrategy = Default ]
{

/// Foreign Key FKBDADVERABO created via DDL
ForeignKey FKBDADVERABO(ABODR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_BD_ADVER_ABO ];

/// Foreign Key FKBDADVERADDUSER created via DDL
ForeignKey FKBDADVERADDUSER(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_ADVER_ADDUSER ];

/// Foreign Key FKBDADVERADVTYPE created via DDL
ForeignKey FKBDADVERADVTYPE(RecordTypeDR) References dbo.BBAdverseReactionType(PKBBADVERSEREACTIONTYPE) [ SqlName = FK_BD_ADVER_ADVTYPE ];

/// Foreign Key FKBDADVERAGEUNIT created via DDL
ForeignKey FKBDADVERAGEUNIT(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_BD_ADVER_AGEUNIT ];

/// Foreign Key FKBDADVERCHECKUSER created via DDL
ForeignKey FKBDADVERCHECKUSER(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_ADVER_CHECKUSER ];

/// Foreign Key FKBDADVERKEESTBLOOD created via DDL
ForeignKey FKBDADVERKEESTBLOOD(KeestBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_ADVER_KEESTBLOOD ];

/// Foreign Key FKBDADVERLOCATION created via DDL
ForeignKey FKBDADVERLOCATION(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_ADVER_LOCATION ];

/// Foreign Key FKBDADVERORGANBLOOD created via DDL
ForeignKey FKBDADVERORGANBLOOD(OrganBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_ADVER_ORGANBLOOD ];

/// Foreign Key FKBDADVERRH created via DDL
ForeignKey FKBDADVERRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_BD_ADVER_RH ];

/// Foreign Key FKBDADVERSPECIES created via DDL
ForeignKey FKBDADVERSPECIES(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_BD_ADVER_SPECIES ];

/// Foreign Key FKBDADVERWARD created via DDL 
ForeignKey FKBDADVERWARD(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_ADVER_WARD ];

/// Foreign Key FKBDADVERCHECKUSER created via DDL
ForeignKey FKBDADVERDEALUSER(DepartmentDealUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_ADVER_DEALUSER ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexMedicalRecordNo On MedicalRecordNo [ SqlName = Index_MedicalRecordNo, Type = index ];

Index IndexRecordNo On RecordNo [ SqlName = Index_RecordNo, Type = index ];

Index IndexRecordType On (RecordTypeDR, CheckDate) [ SqlName = Index_RecordType, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKBDADVERSEREACTION On RowID [ PrimaryKey, SqlName = PK_BD_ADVERSEREACTION, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 输血不良反应记录单号  
Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 3 ];

/// 单号类型  
Property RecordTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 创建人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 就诊病案号  
Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 别名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 年龄  
Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 年龄单位  
Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 证件类型  
Property CertTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 证件号  
Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 身份证号  
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 18 ];

/// ABO血型  
Property ABODR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// RH血型  
Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 稀有血型  
Property RareBloodGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

/// 民族  
Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 22 ];

/// 籍贯  
Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 23 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 病区  
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 床号  
Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

/// 诊断  
Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 27 ];

/// 特殊药物史  {1:true,0:false}
Property BeforeTransDrug As %Library.Boolean [ SqlColumnNumber = 28 ];

/// 特殊药物列表  
Property BeforeTransDrugNote As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 29 ];

/// 是否有输血史  {1:true,0:false}
Property IsTransHistory As %Library.Boolean [ SqlColumnNumber = 30 ];

/// 最近输血日期  
Property LastTransDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 输血不良反应史  {1:true,0:false}
Property IsUntowardEffect As %Library.Boolean [ SqlColumnNumber = 32 ];

/// 输血不良反应说明  
Property UntowardEffectNote As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 33 ];

/// 是否器官移植  {1:true,0:false}
Property IsOrganExplant As %Library.Boolean [ SqlColumnNumber = 34 ];

/// 器官移植供者ABO血  
Property OrganBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 是否骨髓移植  {1:true,0:false}
Property IsKeestExplant As %Library.Boolean [ SqlColumnNumber = 36 ];

/// 骨髓移植供者ABO血  
Property KeestBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 是否使用特殊药物  {1:true,0:false}
Property IsDrugHistory As %Library.Boolean [ SqlColumnNumber = 38 ];

/// 特殊药物  
Property DrugList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 39 ];

/// 是否有孕产史  {1:true,0:false}
Property IsPregHistory As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 40 ];

/// 孕次  
Property Pregnancies As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

/// 产次  
Property ChildBirths As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 42 ];

/// 意外抗体筛查  {1:true,0:false}
Property UnexpectedScreening As %Library.Boolean [ SqlColumnNumber = 43 ];

/// 发热(℃)  
Property Temperature As %Library.Float [ SqlColumnNumber = 44 ];

/// 脉搏(次/每分)  
Property Pulse As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 45 ];

/// 高压(mmHg)  
Property HighPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 46 ];

/// 低压(mmHg)  
Property LowPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 47 ];

/// 血红蛋白  
Property Hemoglobin As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 48 ];

/// 开始输血日期  
Property StartTransfusionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 49 ];

/// 开始输血时间  
Property StartTransfusionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 50 ];

/// 停止输血日期  
Property StopTransfusionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 51 ];

/// 停止输血时间  
Property StopTransfusionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 52 ];

/// 输血操作者  
Property TransfusionUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

/// 不良反应日期  
Property AdverseReactionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 54 ];

/// 不良反应时间  
Property AdverseReactionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 55 ];

/// 不良反应发现者  
Property AdverseReactionFindUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 56 ];

/// 不良反应表现症状  
Property RectionPerformance As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 57 ];

/// 输血器厂家/批号:  
Property TransfusionMachine As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 58 ];

/// 剩余血量(ml):  
Property LeftVolume As %Library.Float [ SqlColumnNumber = 59 ];

/// 状态  
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 60 ];

/// 就诊类型  
Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 61 ];

/// 不良反应导致结果  
Property ResultIn As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 62 ];

/// 结果发生日期  
Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 63 ];

/// 结果发生时间  
Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 64 ];

/// 结果原因说明  
Property ResultNote As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 65 ];

/// 临床处理情况  
Property ClinicalTreatment As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 66 ];

/// 审核说明  
Property CheckCause As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 67 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 68 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

/// 审核用户  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 70 ];

/// 评价内容  
Property EvaluateText As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 71 ];

/// 备注  
Property Remarks As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 72 ];

/// 输血科处理日期  
Property DepartmentDealDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 73 ];

/// 输血科处理时间  
Property DepartmentDealTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 74 ];

/// 输血科处理人  
Property DepartmentDealUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 75 ];

/// 输血科处理备注  
Property DepartmentDealRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 76 ];

/// 结果严重程序  
Property ResultSeverity As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 77 ];

/// 结果关联性  
Property ResultRelated As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 78 ];

/// 呼吸  
Property Breathing As %Library.Integer(MAXVAL = 10000, MINVAL = 0) [ SqlColumnNumber = 79 ];

/// 年龄描述  
Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 80 ];

Storage Default
{
<Data name="BDAdverseReactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>RecordNo</Value>
</Value>
<Value name="4">
<Value>RecordTypeDR</Value>
</Value>
<Value name="5">
<Value>AdmNo</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
<Value name="9">
<Value>RegNo</Value>
</Value>
<Value name="10">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="11">
<Value>SurName</Value>
</Value>
<Value name="12">
<Value>GivenName</Value>
</Value>
<Value name="13">
<Value>SpeciesDR</Value>
</Value>
<Value name="14">
<Value>Age</Value>
</Value>
<Value name="15">
<Value>AgeUnitDR</Value>
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
<Value>ABODR</Value>
</Value>
<Value name="20">
<Value>RHDR</Value>
</Value>
<Value name="21">
<Value>RareBloodGroup</Value>
</Value>
<Value name="22">
<Value>Ethnicity</Value>
</Value>
<Value name="23">
<Value>NativePlace</Value>
</Value>
<Value name="24">
<Value>LocationDR</Value>
</Value>
<Value name="25">
<Value>WardDR</Value>
</Value>
<Value name="26">
<Value>BedNo</Value>
</Value>
<Value name="27">
<Value>Diagnosis</Value>
</Value>
<Value name="28">
<Value>BeforeTransDrug</Value>
</Value>
<Value name="29">
<Value>BeforeTransDrugNote</Value>
</Value>
<Value name="30">
<Value>IsTransHistory</Value>
</Value>
<Value name="31">
<Value>LastTransDate</Value>
</Value>
<Value name="32">
<Value>IsUntowardEffect</Value>
</Value>
<Value name="33">
<Value>UntowardEffectNote</Value>
</Value>
<Value name="34">
<Value>IsOrganExplant</Value>
</Value>
<Value name="35">
<Value>OrganBloodGroupDR</Value>
</Value>
<Value name="36">
<Value>IsKeestExplant</Value>
</Value>
<Value name="37">
<Value>KeestBloodGroupDR</Value>
</Value>
<Value name="38">
<Value>IsDrugHistory</Value>
</Value>
<Value name="39">
<Value>DrugList</Value>
</Value>
<Value name="40">
<Value>IsPregHistory</Value>
</Value>
<Value name="41">
<Value>Pregnancies</Value>
</Value>
<Value name="42">
<Value>ChildBirths</Value>
</Value>
<Value name="43">
<Value>UnexpectedScreening</Value>
</Value>
<Value name="44">
<Value>Temperature</Value>
</Value>
<Value name="45">
<Value>Pulse</Value>
</Value>
<Value name="46">
<Value>HighPressure</Value>
</Value>
<Value name="47">
<Value>LowPressure</Value>
</Value>
<Value name="48">
<Value>Hemoglobin</Value>
</Value>
<Value name="49">
<Value>StartTransfusionDate</Value>
</Value>
<Value name="50">
<Value>StartTransfusionTime</Value>
</Value>
<Value name="51">
<Value>StopTransfusionDate</Value>
</Value>
<Value name="52">
<Value>StopTransfusionTime</Value>
</Value>
<Value name="53">
<Value>TransfusionUserDR</Value>
</Value>
<Value name="54">
<Value>AdverseReactionDate</Value>
</Value>
<Value name="55">
<Value>AdverseReactionTime</Value>
</Value>
<Value name="56">
<Value>AdverseReactionFindUserDR</Value>
</Value>
<Value name="57">
<Value>RectionPerformance</Value>
</Value>
<Value name="58">
<Value>TransfusionMachine</Value>
</Value>
<Value name="59">
<Value>LeftVolume</Value>
</Value>
<Value name="60">
<Value>Status</Value>
</Value>
<Value name="61">
<Value>AdmType</Value>
</Value>
<Value name="62">
<Value>ResultIn</Value>
</Value>
<Value name="63">
<Value>ResultDate</Value>
</Value>
<Value name="64">
<Value>ResultTime</Value>
</Value>
<Value name="65">
<Value>ResultNote</Value>
</Value>
<Value name="66">
<Value>ClinicalTreatment</Value>
</Value>
<Value name="67">
<Value>CheckCause</Value>
</Value>
<Value name="68">
<Value>CheckDate</Value>
</Value>
<Value name="69">
<Value>CheckTime</Value>
</Value>
<Value name="70">
<Value>CheckUserDR</Value>
</Value>
<Value name="71">
<Value>EvaluateText</Value>
</Value>
<Value name="72">
<Value>Remarks</Value>
</Value>
<Value name="73">
<Value>DepartmentDealDate</Value>
</Value>
<Value name="74">
<Value>DepartmentDealTime</Value>
</Value>
<Value name="75">
<Value>DepartmentDealUserDR</Value>
</Value>
<Value name="76">
<Value>DepartmentDealRemarks</Value>
</Value>
<Value name="77">
<Value>ResultSeverity</Value>
</Value>
<Value name="78">
<Value>ResultRelated</Value>
</Value>
<Value name="79">
<Value>Breathing</Value>
</Value>
<Value name="80">
<Value>AgeDesc</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAdverseReactionD</DataLocation>
<DefaultData>BDAdverseReactionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDAdverseReactionD</IdLocation>
<IndexLocation>^dbo.BDAdverseReactionI</IndexLocation>
<StreamLocation>^dbo.BDAdverseReactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
