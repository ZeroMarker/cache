/// Creator:丁亚男
/// CreatDate:2020-06-16
/// Description：护理字典表 
/// Table：CT.WDT.CDSS.NursingDict
Class CT.WDT.CDSS.NursingDict Extends (%Persistent, User.Abstract)
{

/// 国家（国际）编码
Property NursingNationCode As %String;

/// 护理项目编码（公司编码）
Property NursingCode As %String [ Required ];

/// 护理项目名称
Property NursingName As %String [ Required ];

/// 护理项目概述
Property NursingOverview As %String(MAXLEN = 400);

/// 汉语拼音
Property NursingNamePinyin As %String(MAXLEN = "");

/// 汉语首拼
Property NursingNameFirstPinyin As %String(MAXLEN = "");

/// 英文名
Property NursingEnglishName As %String;

/// 护理分类编码
Property NursingClassCodeDR As %String;

/// 护理操作概述
Property NursingContent As %String(MAXLEN = "");

/// 适应症概述
Property NursingIndication As %String(MAXLEN = "");

/// 禁忌症概述
Property NursingTaboo As %String(MAXLEN = "");

/// 不良反应概述
Property AdverseReactions As %String(MAXLEN = "");

/// 注意事项概述
Property NursingPrecaution As %String(MAXLEN = "");

/// 并发症
Property Complication As %String(MAXLEN = "");

/// 子项标记（0是，1否）
Property ChildFlag As %Integer [ InitialExpression = 1 ];

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

/// 知识数量
Property KnowledgeTotal As %Integer;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String [ InitialExpression = "dhcc" ];

/// 类型  护理/处置
Property NursingType As %String;

/// 状态 0 编辑中,1 已删除，2 已审核
Property UseFlag As %String;

/// 别名
Property NursingAliasName As %String(MAXLEN = "");

Index NameIndex On NursingName;

Index CodeIndex On NursingCode;

Index NationCodeIndex On NursingNationCode;

Index TotalIndex On KnowledgeTotal;

Index ClassDRIndex On NursingClassCodeDR;

Index NameTypeIndex On (NursingName, NursingType);

Storage Default
{
<Data name="NursingDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NursingNationCode</Value>
</Value>
<Value name="3">
<Value>NursingCode</Value>
</Value>
<Value name="4">
<Value>NursingName</Value>
</Value>
<Value name="5">
<Value>NursingOverview</Value>
</Value>
<Value name="6">
<Value>NursingNamePinyin</Value>
</Value>
<Value name="7">
<Value>NursingNameFirstPinyin</Value>
</Value>
<Value name="8">
<Value>NursingEnglishName</Value>
</Value>
<Value name="9">
<Value>NursingClassCodeDR</Value>
</Value>
<Value name="10">
<Value>NursingContent</Value>
</Value>
<Value name="11">
<Value>NursingIndication</Value>
</Value>
<Value name="12">
<Value>NursingTaboo</Value>
</Value>
<Value name="13">
<Value>AdverseReactions</Value>
</Value>
<Value name="14">
<Value>NursingPrecaution</Value>
</Value>
<Value name="15">
<Value>Complication</Value>
</Value>
<Value name="16">
<Value>ChildFlag</Value>
</Value>
<Value name="17">
<Value>QuoteFlag</Value>
</Value>
<Value name="18">
<Value>KnowledgeTotal</Value>
</Value>
<Value name="19">
<Value>CreateDate</Value>
</Value>
<Value name="20">
<Value>CreateUserID</Value>
</Value>
<Value name="21">
<Value>NursingType</Value>
</Value>
<Value name="22">
<Value>UseFlag</Value>
</Value>
<Value name="23">
<Value>NursingAliasName</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.NursingDictD</DataLocation>
<DefaultData>NursingDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.NursingDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.NursingDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.NursingDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
