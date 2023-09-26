/// Creator:丁亚男
/// CreatDate:2020-04-22
/// Description：药品字典表 
/// Table：CT.WDT.CDSS.DrugDict
Class CT.WDT.CDSS.DrugDict Extends (%Persistent, User.Abstract)
{

/// 国家（国际）编码
Property DrugNationCode As %String;

/// 公司编码
Property DrugCode As %String [ Required ];

/// 通用名（中文名）
Property DrugName As %String [ Required ];

/// 汉语拼音
Property DrugNamePinyin As %String(MAXLEN = "");

/// 汉语首拼
Property DrugNameFirstPinyin As %String;

/// 英文名
Property DrugEnglishName As %String;

/// 药物一级分类编码
Property DrugFirstClass As %String;

/// 药物二级分类编码
Property DrugSecondClass As %String;

/// 药物三级分类编码
Property DrugClass As %String;

/// 药物概述
Property DrugOverview As %String(MAXLEN = "");

/// 适应症概述
Property IndicationOverview As %String(MAXLEN = "");

/// 用法用量概述
Property DosageOverview As %String(MAXLEN = "");

/// 不良反应概述
Property AdverseReactions As %String(MAXLEN = "");

/// 禁忌症概述
Property Contraindications As %String(MAXLEN = "");

/// 辅料信息概述
Property DrugAccessories As %String(MAXLEN = "");

/// 适用情况概述
Property DrugApplication As %String(MAXLEN = "");

/// 相互作用概述
Property DrugInteraction As %String(MAXLEN = "");

/// 药物过量概述
Property DrugOverdose As %String(MAXLEN = "");

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

/// 知识数量
Property KnowledgeTotal As %Integer;

/// 药监局报批
Property ApprovalFlag As %String;

/// 剂型
Property DrugType As %String;

/// 别名
Property DrugAlias As %String(MAXLEN = "");

/// 药物类
Property DrugCategory As %String;

/// （化学名）主要成分
Property DrugChemicalName As %String(MAXLEN = "");

/// 成分
Property DrugComposition As %String(MAXLEN = "");

/// 商品名
Property DrugTradeName As %String(MAXLEN = "");

/// 维护标识 (编辑中 0 ,已审核 1)
Property MaintainFlag As %Integer;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String;

Index NameIndex On DrugName;

Index CodeIndex On DrugCode;

Index NationCodeIndex On DrugNationCode;

Index TradeNameIndex On DrugTradeName;

Index DrugAliasIndex On DrugAlias;

Index ChemicalNameIndex On DrugChemicalName;

Index DrugCategoryIndex On (DrugCategory, DrugName);

Storage Default
{
<Data name="DrugDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DrugNationCode</Value>
</Value>
<Value name="3">
<Value>DrugCode</Value>
</Value>
<Value name="4">
<Value>DrugName</Value>
</Value>
<Value name="5">
<Value>DrugNamePinyin</Value>
</Value>
<Value name="6">
<Value>DrugNameFirstPinyin</Value>
</Value>
<Value name="7">
<Value>DrugEnglishName</Value>
</Value>
<Value name="8">
<Value>DrugFirstClass</Value>
</Value>
<Value name="9">
<Value>DrugSecondClass</Value>
</Value>
<Value name="10">
<Value>DrugClass</Value>
</Value>
<Value name="11">
<Value>DrugOverview</Value>
</Value>
<Value name="12">
<Value>IndicationOverview</Value>
</Value>
<Value name="13">
<Value>DosageOverview</Value>
</Value>
<Value name="14">
<Value>AdverseReactions</Value>
</Value>
<Value name="15">
<Value>Contraindications</Value>
</Value>
<Value name="16">
<Value>DrugAccessories</Value>
</Value>
<Value name="17">
<Value>DrugApplication</Value>
</Value>
<Value name="18">
<Value>DrugInteraction</Value>
</Value>
<Value name="19">
<Value>DrugOverdose</Value>
</Value>
<Value name="20">
<Value>Remarks</Value>
</Value>
<Value name="21">
<Value>QuoteFlag</Value>
</Value>
<Value name="22">
<Value>KnowledgeTotal</Value>
</Value>
<Value name="23">
<Value>ApprovalFlag</Value>
</Value>
<Value name="24">
<Value>DrugType</Value>
</Value>
<Value name="25">
<Value>DrugAlias</Value>
</Value>
<Value name="26">
<Value>DrugCategory</Value>
</Value>
<Value name="27">
<Value>DrugChemicalName</Value>
</Value>
<Value name="28">
<Value>DrugComposition</Value>
</Value>
<Value name="29">
<Value>DrugTradeName</Value>
</Value>
<Value name="30">
<Value>MaintainFlag</Value>
</Value>
<Value name="31">
<Value>CreateDate</Value>
</Value>
<Value name="32">
<Value>CreateUserID</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DrugDictD</DataLocation>
<DefaultData>DrugDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DrugDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DrugDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DrugDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
