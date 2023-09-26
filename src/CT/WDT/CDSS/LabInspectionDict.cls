/// Creator:丁亚男
/// CreatDate:2020-05-22
/// Description：检验字典表 
/// Table：CT.WDT.CDSS.LabInspectionDict
Class CT.WDT.CDSS.LabInspectionDict Extends (%Persistent, User.Abstract)
{

/// 国家（国际）编码
Property LabNationCode As %String;

/// 公司编码
Property LabCode As %String(MAXLEN = "") [ Required ];

/// 检验项目名称
Property LabName As %String(MAXLEN = "") [ Required ];

/// 汉语拼音
Property LabNamePinyin As %String(MAXLEN = "");

/// 汉语首拼
Property LabNameFirstPinyin As %String(MAXLEN = "");

/// 英文名
Property LabEnglishName As %String;

/// 检验项目类型DR
Property LabClassCodeDR As %String;

/// 检验项目概述
Property LabDesc As %String(MAXLEN = "");

/// 检验标本概述
Property LabSpecimen As %String(MAXLEN = "");

/// 检验过程概述
Property LabProcess As %String(MAXLEN = "");

/// 适用症概述
Property IndicationOverview As %String(MAXLEN = "");

/// 禁忌症概述
Property LabTaboo As %String(MAXLEN = "");

/// 不良反应概述
Property AdverseReactions As %String(MAXLEN = "");

/// 注意事项概述
Property LabPrecautions As %String(MAXLEN = "");

/// 检验结果概述
Property LabResult As %String(MAXLEN = "");

/// 检验结果有效期（天）
Property LabResultExp As %Integer;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

/// 知识数量
Property KnowledgeTotal As %Integer;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String [ InitialExpression = "dhcc" ];

/// 别名
Property Alias As %String(MAXLEN = "");

/// 状态(0编辑中,1已删除,2已审核)
Property UseFlag As %Integer;

Index NameIndex On LabName;

Index CodeIndex On LabCode;

Index NationCodeIndex On LabNationCode;

Index LabClassCodeDRIndex On LabClassCodeDR;

Index KnowledgeTotalIndex On KnowledgeTotal;

Storage Default
{
<Data name="LabInspectionDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabNationCode</Value>
</Value>
<Value name="3">
<Value>LabCode</Value>
</Value>
<Value name="4">
<Value>LabName</Value>
</Value>
<Value name="5">
<Value>LabNamePinyin</Value>
</Value>
<Value name="6">
<Value>LabNameFirstPinyin</Value>
</Value>
<Value name="7">
<Value>LabEnglishName</Value>
</Value>
<Value name="8">
<Value>LabClassCodeDR</Value>
</Value>
<Value name="9">
<Value>LabDesc</Value>
</Value>
<Value name="10">
<Value>LabSpecimen</Value>
</Value>
<Value name="11">
<Value>LabProcess</Value>
</Value>
<Value name="12">
<Value>IndicationOverview</Value>
</Value>
<Value name="13">
<Value>LabTaboo</Value>
</Value>
<Value name="14">
<Value>AdverseReactions</Value>
</Value>
<Value name="15">
<Value>LabPrecautions</Value>
</Value>
<Value name="16">
<Value>LabResult</Value>
</Value>
<Value name="17">
<Value>LabResultExp</Value>
</Value>
<Value name="18">
<Value>Remarks</Value>
</Value>
<Value name="19">
<Value>QuoteFlag</Value>
</Value>
<Value name="20">
<Value>KnowledgeTotal</Value>
</Value>
<Value name="21">
<Value>CreateDate</Value>
</Value>
<Value name="22">
<Value>CreateUserID</Value>
</Value>
<Value name="23">
<Value>Alias</Value>
</Value>
<Value name="24">
<Value>UseFlag</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.LabInspectionDictD</DataLocation>
<DefaultData>LabInspectionDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.LabInspectionDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.LabInspectionDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.LabInspectionDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
