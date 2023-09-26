/// Creator:丁亚男
/// CreatDate:2020-06-12
/// Description：输血品字典表 
/// Table：CT.WDT.CDSS.BloodProductDict
Class CT.WDT.CDSS.BloodProductDict Extends (%Persistent, User.Abstract)
{

/// 公司临床医学知识体系编码
Property BPNationCode As %String;

/// 输血品编码（公司编码）
Property BPCode As %String [ Required ];

/// 输血品名称
Property BPName As %String [ Required ];

/// 输血品概述
Property BPOverview As %String(MAXLEN = 400);

/// 汉语拼音
Property BPNamePinyin As %String(MAXLEN = 100);

/// 汉语首拼
Property BPNameFirstPinyin As %String;

/// 英文名
Property BPEnglishName As %String;

/// 输血品分类编码
Property BPClassCodeDR As CT.WDT.CDSS.BPClassDict;

/// 血型概述
Property BloodTypeDesc As %String;

/// 适用症概述
Property IndicationDesc As %String;

/// 禁忌症概述
Property TabooDesc As %String;

/// 注意事项概述
Property PrecautionDesc As %String;

/// 不良反应概述
Property AdverseReactionsDesc As %String;

/// 适用疾病概述
Property DiseaseDesc As %String;

/// 并发症概述
Property ComplicationDesc As %String;

/// 替代制品概述
Property SubstituteDesc As %String;

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

/// 知识数量
Property KnowledgeTotal As %Integer;

/// 更新时间
Property UpdateDate As %TimeStamp;

/// 更新人员
Property UpdateUser As %String(MAXLEN = 12);

/// 使用标识（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 备注
Property Remarks As %String;

/// 别名
Property BPAlias As %String;

Index NameIndex On BPName;

Index CodeIndex On BPCode;

Index NationCodeIndex On BPNationCode;

Index TotalIndex On KnowledgeTotal;

Index BPClassDRIndex On BPClassCodeDR;

Storage Default
{
<Data name="BloodProductDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BPNationCode</Value>
</Value>
<Value name="3">
<Value>BPCode</Value>
</Value>
<Value name="4">
<Value>BPName</Value>
</Value>
<Value name="5">
<Value>BPOverview</Value>
</Value>
<Value name="6">
<Value>BPNamePinyin</Value>
</Value>
<Value name="7">
<Value>BPNameFirstPinyin</Value>
</Value>
<Value name="8">
<Value>BPEnglishName</Value>
</Value>
<Value name="9">
<Value>BPClassCodeDR</Value>
</Value>
<Value name="10">
<Value>BloodTypeDesc</Value>
</Value>
<Value name="11">
<Value>IndicationDesc</Value>
</Value>
<Value name="12">
<Value>TabooDesc</Value>
</Value>
<Value name="13">
<Value>PrecautionDesc</Value>
</Value>
<Value name="14">
<Value>AdverseReactionsDesc</Value>
</Value>
<Value name="15">
<Value>DiseaseDesc</Value>
</Value>
<Value name="16">
<Value>ComplicationDesc</Value>
</Value>
<Value name="17">
<Value>SubstituteDesc</Value>
</Value>
<Value name="18">
<Value>QuoteFlag</Value>
</Value>
<Value name="19">
<Value>KnowledgeTotal</Value>
</Value>
<Value name="20">
<Value>UpdateDate</Value>
</Value>
<Value name="21">
<Value>UpdateUser</Value>
</Value>
<Value name="22">
<Value>UseFlag</Value>
</Value>
<Value name="23">
<Value>Remarks</Value>
</Value>
<Value name="24">
<Value>BPAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.BloodProductDictD</DataLocation>
<DefaultData>BloodProductDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.BloodProductDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.BloodProductDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.BloodProductDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
