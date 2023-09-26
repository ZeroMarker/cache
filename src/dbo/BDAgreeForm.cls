/// 输血知情同意书
Class dbo.BDAgreeForm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AgreeForm, StorageStrategy = Default ]
{

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexAgreeFormNo On AgreeFormNo [ SqlName = Index_AgreeFormNo, Type = index, Unique ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexMedicalRecordNo On MedicalRecordNo [ SqlName = Index_MedicalRecordNo, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKBDAGREEFORM On RowID [ PrimaryKey, SqlName = PK_BD_AGREEFORM, Type = index, Unique ];

/// Foreign Key FKBDAgreeFAddUser created via DDL
ForeignKey FKBDAgreeFAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AgreeF_AddUser ];

/// Foreign Key FKBDAgreeFAgeUnit created via DDL
ForeignKey FKBDAgreeFAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_BD_AgreeF_AgeUnit ];

/// Foreign Key FKBDAgreeFCheckUser created via DDL
ForeignKey FKBDAgreeFCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_AgreeF_CheckUser ];

/// Foreign Key FKBDAgreeFEthnicity created via DDL
/// ForeignKey FKBDAgreeFEthnicity(EthnicityDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_BD_AgreeF_Ethnicity ];
/// Foreign Key FKBDAgreeFLocation created via DDL
ForeignKey FKBDAgreeFLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_AgreeF_Location ];

/// Foreign Key FKBDAgreeFPurpose created via DDL
/// ForeignKey FKBDAgreeFPurpose(PurposeDR) References dbo.BBPurpose(PKBBPURPOSE) [ SqlName = FK_BD_AgreeF_Purpose ];
/// Foreign Key FKBDAgreeFSpecies created via DDL
ForeignKey FKBDAgreeFSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_BD_AgreeF_Species ];

/// Foreign Key FKBDAgreeFWard created via DDL
ForeignKey FKBDAgreeFWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_AgreeF_Ward ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 同意书单号  
Property AgreeFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 4 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

/// 病案号  
Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

/// 别名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 年龄  
Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 年龄单位  
Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 身份证号  
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 民族  
Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// 申请科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 病区  
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 床号  
Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 临床诊断  
Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 20 ];

/// 是否有输血史  {1:true,0:false}
Property IsTransHistory As %Library.Boolean [ SqlColumnNumber = 21 ];

/// 最近输血日期  
Property LastTransDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 输血不良反应史  {1:true,0:false}
Property IsUntowardEffect As %Library.Boolean [ SqlColumnNumber = 23 ];

/// 输血不良反应说明  
Property UntowardEffectNote As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 24 ];

/// 是否有孕产史  {1:true,0:false}
Property IsPregHistory As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 25 ];

/// 孕次  
Property Pregnancies As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 产次  
Property ChildBirths As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 输血目的  
Property PurposeList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 28 ];

/// 输血产品  
Property ReqProductList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 29 ];

/// 输血方式  
Property TransfusionMode As %Library.SmallInt [ SqlColumnNumber = 30 ];

/// 告知内容  
Property NotifyContent As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 31 ];

/// 告知风险  
Property NotifyRisk As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 32 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 33 ];

/// 状态  
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 34 ];

/// 审核说明  
Property CheckCause As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 35 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 审核用户  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

/// 受血者签名  
Property PatientSignName As %Library.String(COLLATION = "Exact", MAXLEN = 8000) [ SqlColumnNumber = 39 ];

/// 受血者签字时间  
Property PatientSignTime As %Library.String(COLLATION = "Exact", MAXLEN = 8000) [ SqlColumnNumber = 40 ];

/// 有效范围  
Property EffectRange As %Library.SmallInt [ Required, SqlColumnNumber = 41 ];

/// 是否器官移植  {1:true,0:false}
Property IsOrganExplant As %Library.Boolean [ SqlColumnNumber = 42 ];

/// 器官移植供者ABO血  
Property OrganBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 43 ];

/// 是否骨髓移植  {1:true,0:false}
Property IsKeestExplant As %Library.Boolean [ SqlColumnNumber = 44 ];

/// 骨髓移植供者ABO血  
Property KeestBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 45 ];

/// 是否使用特殊药物  {1:true,0:false}
Property IsDrugHistory As %Library.Boolean [ SqlColumnNumber = 46 ];

/// 特殊药物  
Property DrugList As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 47 ];

/// 年龄描述  
Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 48 ];

/// 就诊类型  
Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 49 ];

Storage Default
{
<Data name="BDAgreeFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AgreeFormNo</Value>
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
<Value>IDNumber</Value>
</Value>
<Value name="15">
<Value>Ethnicity</Value>
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
<Value>IsTransHistory</Value>
</Value>
<Value name="21">
<Value>LastTransDate</Value>
</Value>
<Value name="22">
<Value>IsUntowardEffect</Value>
</Value>
<Value name="23">
<Value>UntowardEffectNote</Value>
</Value>
<Value name="24">
<Value>IsPregHistory</Value>
</Value>
<Value name="25">
<Value>Pregnancies</Value>
</Value>
<Value name="26">
<Value>ChildBirths</Value>
</Value>
<Value name="27">
<Value>PurposeList</Value>
</Value>
<Value name="28">
<Value>ReqProductList</Value>
</Value>
<Value name="29">
<Value>TransfusionMode</Value>
</Value>
<Value name="30">
<Value>NotifyContent</Value>
</Value>
<Value name="31">
<Value>NotifyRisk</Value>
</Value>
<Value name="32">
<Value>Remark</Value>
</Value>
<Value name="33">
<Value>Status</Value>
</Value>
<Value name="34">
<Value>CheckCause</Value>
</Value>
<Value name="35">
<Value>CheckDate</Value>
</Value>
<Value name="36">
<Value>CheckTime</Value>
</Value>
<Value name="37">
<Value>CheckUserDR</Value>
</Value>
<Value name="38">
<Value>PatientSignName</Value>
</Value>
<Value name="39">
<Value>PatientSignTime</Value>
</Value>
<Value name="40">
<Value>EffectRange</Value>
</Value>
<Value name="41">
<Value>IsOrganExplant</Value>
</Value>
<Value name="42">
<Value>OrganBloodGroupDR</Value>
</Value>
<Value name="43">
<Value>IsKeestExplant</Value>
</Value>
<Value name="44">
<Value>KeestBloodGroupDR</Value>
</Value>
<Value name="45">
<Value>IsDrugHistory</Value>
</Value>
<Value name="46">
<Value>DrugList</Value>
</Value>
<Value name="47">
<Value>AgeDesc</Value>
</Value>
<Value name="48">
<Value>AdmType</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAgreeFormD</DataLocation>
<DefaultData>BDAgreeFormDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDAgreeFormD</IdLocation>
<IndexLocation>^dbo.BDAgreeFormI</IndexLocation>
<StreamLocation>^dbo.BDAgreeFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
