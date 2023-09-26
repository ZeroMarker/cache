/// BDReqAssess
Class dbo.BDReqAssess Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqAssess ]
{

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

Index IndexMaster On AssessNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexCheckUser On (CheckUserDR, CheckDate) [ SqlName = Index_CheckUser, Type = index ];

Index IndexCheckDate On (CheckDate, Status) [ SqlName = Index_CheckDate, Type = index ];

Index IndexLocation On (LocationDR, CheckDate) [ SqlName = Index_Location, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexDeptCheckUser On (DeptCheckUserDR, DeptCheckDate) [ SqlName = Index_DeptCheckUser, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, DeptCheckDate) [ SqlName = Index_WorkGroup, Type = index ];

Index IndexAssessType On (AssessTypeDR, CheckDate) [ SqlName = Index_AssessType, Type = index ];

Index PKBDREQASSESS On RowID [ PrimaryKey, SqlName = PK_BD_REQASSESS, Type = index, Unique ];

ForeignKey FKBDReqAssessABO(ABODR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_BD_ReqAssess_ABO ];

ForeignKey FKBDReqAssessRH(RHDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_BD_ReqAssess_RH ];

ForeignKey FKBDReqAssessAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_ReqAssess_AddUser ];

ForeignKey FKBDReqAssessAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_BD_ReqAssess_AgeUnit ];

ForeignKey FKBDReqAssessCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_ReqAssess_CheckUser ];

ForeignKey FKBDReqAssessDeptCheckUserDR(DeptCheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_ReqAssess_DeptCheckUserDR ];

// ForeignKey FKBDReqAssessEthnicity(EthnicityDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_BD_ReqAssess_Ethnicity ];

ForeignKey FKBDReqAssessLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_ReqAssess_Location ];

ForeignKey FKBDReqAssessSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_BD_ReqAssess_Species ];

ForeignKey FKBDReqAssessReqType(AssessTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BD_ReqReqAssess_AssessTypeDR ];

ForeignKey FKBDReqAssessWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_BD_ReqAssess_Ward ];

ForeignKey FKBDReqAssessWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_ReqAssess_WorkGroup ];

ForeignKey FKBDReqAssessCertType(CertTypeDR) References dbo.BTCertType(PKBTCERTTYPE) [ SqlName = FK_BD_ReqAssess_CertType ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 评估单号  
Property AssessNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 评估单类型  
Property AssessTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 输血方式  
Property TransFusionType As %Library.SmallInt [ SqlColumnNumber = 5 ];

/// 评估日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 评估时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 评估人  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 病案号  
Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

/// 姓名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 13 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 年龄(没单位)  
Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 年龄单位  
Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 年龄(有单位)  
Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// 证件类型  
Property CertTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 证件号  
Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 身份证号  
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 18) [ SqlColumnNumber = 20 ];

/// ABO血型  
Property ABODR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// RH血型  
Property RHDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 稀有血型  
Property RareBloodGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 23 ];

/// 民族  
Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 24 ];

/// 归属地  
Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 25 ];

/// 申请科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 病区  
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 床号  
Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 28 ];

/// 诊断  
Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 29 ];

/// 预计失血量  
Property EstimatedBldLoss As %Library.Float [ SqlColumnNumber = 30 ];

/// 最大可耐受血量  
Property TolerVolumn As %Library.Float [ SqlColumnNumber = 31 ];

/// 输血前临床症状  
Property BeforeSymptom As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 32 ];

/// 其他临床症状  
Property OtherSymptom As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 33 ];

/// 预计输血日期  
Property BookDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 预计输血时间  
Property BookTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

/// 评估内容  
Property AssContent As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 36 ];

/// 评估单状态  
Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 37 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 38 ];

/// 审核日期  
Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 39 ];

/// 审核时间  
Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

/// 审核人  
Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

/// 部门审核日期  
Property DeptCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 42 ];

/// 部门审核时间  
Property DeptCheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 43 ];

/// 部门审核人  
Property DeptCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 44 ];

/// 部门审核说明  
Property DeptChekRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 45 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 46 ];

/// 用血概率
Property PredictUse As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 47 ];

/// 评估结果是否合理  0合理，1不合理
Property IsFit As %Library.Boolean [ SqlColumnNumber = 48 ];

/// 是否需要审批
Property IsApproved As %Library.Boolean [ SqlColumnNumber = 49 ];

/// 输血科审批结果0:通过，1:拒绝
Property DeptCheckResult As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 50 ];

Storage Default
{
<Data name="BDReqAssessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssessNo</Value>
</Value>
<Value name="3">
<Value>AssessTypeDR</Value>
</Value>
<Value name="4">
<Value>TransFusionType</Value>
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
<Value>AdmNo</Value>
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
<Value>AgeDesc</Value>
</Value>
<Value name="17">
<Value>CertTypeDR</Value>
</Value>
<Value name="18">
<Value>CertNo</Value>
</Value>
<Value name="19">
<Value>IDNumber</Value>
</Value>
<Value name="20">
<Value>ABODR</Value>
</Value>
<Value name="21">
<Value>RHDR</Value>
</Value>
<Value name="22">
<Value>RareBloodGroup</Value>
</Value>
<Value name="23">
<Value>Ethnicity</Value>
</Value>
<Value name="24">
<Value>NativePlace</Value>
</Value>
<Value name="25">
<Value>LocationDR</Value>
</Value>
<Value name="26">
<Value>WardDR</Value>
</Value>
<Value name="27">
<Value>BedNo</Value>
</Value>
<Value name="28">
<Value>Diagnosis</Value>
</Value>
<Value name="29">
<Value>EstimatedBldLoss</Value>
</Value>
<Value name="30">
<Value>TolerVolumn</Value>
</Value>
<Value name="31">
<Value>BeforeSymptom</Value>
</Value>
<Value name="32">
<Value>OtherSymptom</Value>
</Value>
<Value name="33">
<Value>BookDate</Value>
</Value>
<Value name="34">
<Value>BookTime</Value>
</Value>
<Value name="35">
<Value>AssContent</Value>
</Value>
<Value name="36">
<Value>Status</Value>
</Value>
<Value name="37">
<Value>Remark</Value>
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
<Value>DeptCheckDate</Value>
</Value>
<Value name="42">
<Value>DeptCheckTime</Value>
</Value>
<Value name="43">
<Value>DeptCheckUserDR</Value>
</Value>
<Value name="44">
<Value>DeptChekRemark</Value>
</Value>
<Value name="45">
<Value>WorkGroupDR</Value>
</Value>
<Value name="46">
<Value>PredictUse</Value>
</Value>
<Value name="47">
<Value>IsFit</Value>
</Value>
<Value name="48">
<Value>IsApproved</Value>
</Value>
<Value name="49">
<Value>DeptCheckResult</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqAssessD</DataLocation>
<DefaultData>BDReqAssessDefaultData</DefaultData>
<IdLocation>^dbo.BDReqAssessD</IdLocation>
<IndexLocation>^dbo.BDReqAssessI</IndexLocation>
<StreamLocation>^dbo.BDReqAssessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
