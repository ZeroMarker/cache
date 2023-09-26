/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 药物临床试验严重不良事件报告表
Class User.DHCDocPilotSAE Extends (%Persistent, User.Abstract)
{

Relationship ChildPat As User.DHCDocPilotSAEPat [ Cardinality = children, Inverse = PParRef ];

Relationship ChildStatus As User.DHCDocPilotSAEStatus [ Cardinality = children, Inverse = SParRef ];

/// 报告类型【首次报告(F) 随访报告(V) 总结报告(S)】
Property AEReportType As %String [ Required, SqlColumnNumber = 2, SqlFieldName = AE_ReportType ];

/// 报告日期
Property AEReportDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = AE_ReportDate ];

/// 报告时间
Property AEReportTime As %Time [ SqlColumnNumber = 4, SqlFieldName = AE_ReportTime ];

/// 医疗机构及专业名称
Property AEMajorName As %String [ SqlColumnNumber = 5, SqlFieldName = AE_MajorName ];

/// 医疗机构及专业名称电话
Property AEMajorTel As %String [ SqlColumnNumber = 6, SqlFieldName = AE_MajorTel ];

/// 申报单位名称
Property AEFilCompanyName As %String [ SqlColumnNumber = 7, SqlFieldName = AE_FilCompanyName ];

/// 申报单位电话
Property AEFilCompanyTel As %String [ SqlColumnNumber = 8, SqlFieldName = AE_FilCompanyTel ];

/// 试验用药品中文名称
Property AEDrugNameZN As %String [ SqlColumnNumber = 9, SqlFieldName = AE_DrugNameZN ];

/// 试验用药品英文名称
Property AEDrugNameEN As %String [ SqlColumnNumber = 10, SqlFieldName = AE_DrugNameEN ];

/// 药品分类【1中药 2化学药 3治疗用生物制品 4预防用生物制品 5其它】
Property AEDrugCategory As %String [ SqlColumnNumber = 11, SqlFieldName = AE_DrugCategory ];

/// 药品分类其他描述
Property AEDrugCategoryOther As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = AE_DrugCategoryOther ];

/// 药品注册分类
Property AERegisterCategory As %String [ SqlColumnNumber = 13, SqlFieldName = AE_RegisterCategory ];

/// 药品剂型
Property AEDrugForm As %String [ SqlColumnNumber = 14, SqlFieldName = AE_DrugForm ];

/// 临床研究期别(Ⅰ期(1) Ⅱ期(2) Ⅲ期(3) Ⅳ期(4))
Property AEStage As %String [ SqlColumnNumber = 15, SqlFieldName = AE_Stage ];

/// 临床研究分类【生物等效性试验(1) 临床验证(2)】
Property AEStudyCategory As %String [ SqlColumnNumber = 16, SqlFieldName = AES_tudyCategory ];

/// 临床试验适应症
Property AEIndication As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = AE_Indication ];

/// 患者姓名拼音缩写
Property AEPatientSpell As %String [ SqlColumnNumber = 18, SqlFieldName = AE_PatientSpell ];

/// 出生日期
Property AEBirthday As %Date [ SqlColumnNumber = 19, SqlFieldName = AE_Birthday ];

/// 性别【1男 2女】
Property AESex As %String [ SqlColumnNumber = 20, SqlFieldName = AE_Sex ];

/// 身高(CM)
Property AEHeight As %String [ SqlColumnNumber = 21, SqlFieldName = AE_Height ];

/// 体重(KG)
Property AEWeight As %String [ SqlColumnNumber = 22, SqlFieldName = AE_Weight ];

/// 有无合并疾病及治疗(1有，0无)
Property AEHasTreat As %String [ SqlColumnNumber = 23, SqlFieldName = AE_HasTreat ];

/// SAE的医学术语(诊断)
Property AEDiagnosis As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = AE_Diagnosis ];

/// SAE情况（多选）【1死亡 2导致住院 3延长住院时间 4伤残 5功能障碍 6导致先天畸形 7危及生命 8其它】
Property AESituation As %String [ SqlColumnNumber = 25, SqlFieldName = AE_Situation ];

/// 死亡日期
Property AEDeadDate As %Date [ SqlColumnNumber = 26, SqlFieldName = AE_DeadDate ];

/// SAE情况其它描述
Property AESituationOther As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = AE_SituationOther ];

/// SAE发生日期
Property AEHappenDate As %Date [ SqlColumnNumber = 28, SqlFieldName = AE_HappenDate ];

/// 研究者获知SAE日期
Property AEKnowDate As %Date [ SqlColumnNumber = 29, SqlFieldName = AE_KnowDate ];

/// 对试验用药采取的措施【1继续用药 2减小剂量 3药物暂停后又恢复 4停用药物】
Property AEMeasures As %String [ SqlColumnNumber = 30, SqlFieldName = AE_Measures ];

/// SAE转归【1症状消失 2症状持续】
Property AETurnOver As %String [ SqlColumnNumber = 31, SqlFieldName = AE_TurnOver ];

/// 有无后遗症（1有，0无）
Property AEHasSequela As %String [ SqlColumnNumber = 32, SqlFieldName = AE_HasSequela ];

/// SAE与试验药的关系【1肯定有关 2可能有关 3可能无关 4肯定无关 5无法判定】
Property AERelation As %String [ SqlColumnNumber = 33, SqlFieldName = AE_Relation ];

/// 国内SAE报道情况(1有 0无 2不详)
Property AEReportZN As %String [ SqlColumnNumber = 34, SqlFieldName = AE_ReportZN ];

/// 国外SAE报道情况(1有 0无 2不详)
Property AEReportEN As %String [ SqlColumnNumber = 35, SqlFieldName = AEReportEN ];

/// SAE发生及处理的详细情况
Property AEDetail As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = AE_Detail ];

/// 报告人
Property AEUser As User.SSUser [ Required, SqlColumnNumber = 37, SqlFieldName = AEUser ];

/// 报告人职务
Property AEUserPost As %String [ SqlColumnNumber = 38, SqlFieldName = AE_UserPost ];

/// 新药临床研究批准文号
Property AEISO As %String [ SqlColumnNumber = 39, SqlFieldName = AE_ISO ];

/// 编号
Property AECode As %String [ SqlColumnNumber = 40, SqlFieldName = AE_Code ];

/// 添加日期
Property AEAddDate As %Date [ SqlColumnNumber = 41, SqlFieldName = AE_AddDate ];

/// 添加时间
Property AEAddTime As %Time [ SqlColumnNumber = 42, SqlFieldName = AE_AddTime ];

/// 状态【N:新建 A:申请，R:拒绝，U:同意】
Property AEStatus As %String [ SqlColumnNumber = 43, SqlFieldName = AE_Status ];

/// 审核日期
Property AEAuditDate As %Date [ SqlColumnNumber = 44, SqlFieldName = AE_AuditDate ];

/// 审核时间
Property AEAuditTime As %Time [ SqlColumnNumber = 45, SqlFieldName = AE_AuditTime ];

/// 审核人
Property AEAuditUser As User.SSUser [ SqlColumnNumber = 46, SqlFieldName = AE_AuditUser ];

/// 填写科室
Property AEAddLoc As User.CTLoc [ SqlColumnNumber = 47, SqlFieldName = AE_AddLoc ];

/// 备注
Property AENote As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = AE_Note ];

/// 审核人安全组
Property AEAuditGroup As User.SSGroup [ SqlColumnNumber = 49, SqlFieldName = AE_AuditGroup ];

/// 报告单位名称
Property AEReportCompany As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = AE_ReportCompany ];

Index ReportType On AEReportType As Exact;

Index AddUser On AEUser As Exact;

Index ReportDate On AEReportDate As Exact;

Index AddDate On AEAddDate As Exact;

Index AuditUser On AEAuditUser As Exact;

Index AuditDate On AEAuditDate As Exact;

Storage Default
{
<Data name="DHCDocPilotSAEDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AEReportType</Value>
</Value>
<Value name="3">
<Value>AEReportDate</Value>
</Value>
<Value name="4">
<Value>AEReportTime</Value>
</Value>
<Value name="5">
<Value>AEMajorName</Value>
</Value>
<Value name="6">
<Value>AEMajorTel</Value>
</Value>
<Value name="7">
<Value>AEFilCompanyName</Value>
</Value>
<Value name="8">
<Value>AEFilCompanyTel</Value>
</Value>
<Value name="9">
<Value>AEDrugNameZN</Value>
</Value>
<Value name="10">
<Value>AEDrugNameEN</Value>
</Value>
<Value name="11">
<Value>AEDrugCategory</Value>
</Value>
<Value name="12">
<Value>AEDrugCategoryOther</Value>
</Value>
<Value name="13">
<Value>AERegisterCategory</Value>
</Value>
<Value name="14">
<Value>AEDrugForm</Value>
</Value>
<Value name="15">
<Value>AEStage</Value>
</Value>
<Value name="16">
<Value>AEStudyCategory</Value>
</Value>
<Value name="17">
<Value>AEIndication</Value>
</Value>
<Value name="18">
<Value>AEPatientSpell</Value>
</Value>
<Value name="19">
<Value>AEBirthday</Value>
</Value>
<Value name="20">
<Value>AESex</Value>
</Value>
<Value name="21">
<Value>AEHeight</Value>
</Value>
<Value name="22">
<Value>AEWeight</Value>
</Value>
<Value name="23">
<Value>AEHasTreat</Value>
</Value>
<Value name="24">
<Value>AEDiagnosis</Value>
</Value>
<Value name="25">
<Value>AESituation</Value>
</Value>
<Value name="26">
<Value>AEDeadDate</Value>
</Value>
<Value name="27">
<Value>AESituationOther</Value>
</Value>
<Value name="28">
<Value>AEHappenDate</Value>
</Value>
<Value name="29">
<Value>AEKnowDate</Value>
</Value>
<Value name="30">
<Value>AEMeasures</Value>
</Value>
<Value name="31">
<Value>AETurnOver</Value>
</Value>
<Value name="32">
<Value>AEHasSequela</Value>
</Value>
<Value name="33">
<Value>AERelation</Value>
</Value>
<Value name="34">
<Value>AEReportZN</Value>
</Value>
<Value name="35">
<Value>AEReportEN</Value>
</Value>
<Value name="36">
<Value>AEDetail</Value>
</Value>
<Value name="37">
<Value>AEUser</Value>
</Value>
<Value name="38">
<Value>AEUserPost</Value>
</Value>
<Value name="39">
<Value>AEISO</Value>
</Value>
<Value name="40">
<Value>AECode</Value>
</Value>
<Value name="41">
<Value>AEAddDate</Value>
</Value>
<Value name="42">
<Value>AEAddTime</Value>
</Value>
<Value name="43">
<Value>AEStatus</Value>
</Value>
<Value name="44">
<Value>AEAuditDate</Value>
</Value>
<Value name="45">
<Value>AEAuditTime</Value>
</Value>
<Value name="46">
<Value>AEAuditUser</Value>
</Value>
<Value name="47">
<Value>AEAddLoc</Value>
</Value>
<Value name="48">
<Value>AENote</Value>
</Value>
<Value name="49">
<Value>AEAuditGroup</Value>
</Value>
<Value name="50">
<Value>AEReportCompany</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPilotSAED</DataLocation>
<DefaultData>DHCDocPilotSAEDefaultData</DefaultData>
<IdLocation>^User.DHCDocPilotSAED</IdLocation>
<IndexLocation>^User.DHCDocPilotSAEI</IndexLocation>
<StreamLocation>^User.DHCDocPilotSAES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
