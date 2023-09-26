/// Creator:丁亚男
/// CreatDate:2019-12-06
/// Description：疾病字典表 
/// Table：CT.WDT.CDSS.DiseaseDict
Class CT.WDT.CDSS.DiseaseDict Extends (%Persistent, User.Abstract)
{

/// 疾病编码
Property DiseaseCode As %String(MAXLEN = 50) [ Required ];

/// 疾病名称
Property DiseaseName As %String(MAXLEN = "") [ Required ];

/// 疾病英文名称
Property DiseaseEnName As %String(MAXLEN = "");

/// 疾病所属科室编码
Property DiseaseDeptCode As %String(MAXLEN = 50);

/// 疾病所属科室名称
Property DiseaseDeptName As %String(MAXLEN = 50);

/// 疾病别名称
Property DiseaseAliasName As %String(MAXLEN = "");

/// 疾病部位
Property DiseaseBodyPartDR As %String;

/// 公司临床医学知识体系编码
Property MedicalCompanyCode As %String;

/// ICD-9编码
Property ICD9Code As %String(MAXLEN = 50);

/// ICD-9名称
Property ICD9Name As %String(MAXLEN = 50);

/// ICD-10编码
Property ICD10Code As %String(MAXLEN = 50);

/// ICD-10名称
Property ICD10Name As %String(MAXLEN = 50);

/// ICD-10-地方编码
Property ICD10LocalCode As %String(MAXLEN = 50);

/// ICD-10-地方名称
Property ICD10LocaName As %String(MAXLEN = 50);

/// ICD-11编码
Property ICD11Code As %String(MAXLEN = 50);

/// ICD-11名称
Property ICD11Name As %String(MAXLEN = 50);

/// 使用标志（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 罕见病标记
Property RareDiseaseFlag As %String;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String [ InitialExpression = "dhcc" ];

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

/// 知识数量
Property KnowledgeTotal As %Integer;

/// 版本
Property Version As %String;

/// 疾病类型
Property DiseaseType As %String;

Index CodeIndex On DiseaseCode [ Unique ];

Index NameIndex On DiseaseName;

Index RareFlagIndex On (RareDiseaseFlag, DiseaseName);

Index TotalIndex On KnowledgeTotal;

Index BodyPartDRIndex On DiseaseBodyPartDR;

Storage Default
{
<Data name="DiseaseDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseCode</Value>
</Value>
<Value name="3">
<Value>DiseaseName</Value>
</Value>
<Value name="4">
<Value>DiseaseEnName</Value>
</Value>
<Value name="5">
<Value>DiseaseDeptCode</Value>
</Value>
<Value name="6">
<Value>DiseaseDeptName</Value>
</Value>
<Value name="7">
<Value>DiseaseAliasName</Value>
</Value>
<Value name="8">
<Value>DiseaseBodyPartDR</Value>
</Value>
<Value name="9">
<Value>MedicalCompanyCode</Value>
</Value>
<Value name="10">
<Value>ICD9Code</Value>
</Value>
<Value name="11">
<Value>ICD9Name</Value>
</Value>
<Value name="12">
<Value>ICD10Code</Value>
</Value>
<Value name="13">
<Value>ICD10Name</Value>
</Value>
<Value name="14">
<Value>ICD10LocalCode</Value>
</Value>
<Value name="15">
<Value>ICD10LocaName</Value>
</Value>
<Value name="16">
<Value>ICD11Code</Value>
</Value>
<Value name="17">
<Value>ICD11Name</Value>
</Value>
<Value name="18">
<Value>UseFlag</Value>
</Value>
<Value name="19">
<Value>RareDiseaseFlag</Value>
</Value>
<Value name="20">
<Value>CreateDate</Value>
</Value>
<Value name="21">
<Value>CreateUserID</Value>
</Value>
<Value name="22">
<Value>Remarks</Value>
</Value>
<Value name="23">
<Value>QuoteFlag</Value>
</Value>
<Value name="24">
<Value>KnowledgeTotal</Value>
</Value>
<Value name="25">
<Value>Version</Value>
</Value>
<Value name="26">
<Value>DiseaseType</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DiseaseDictD</DataLocation>
<DefaultData>DiseaseDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiseaseDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiseaseDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiseaseDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
