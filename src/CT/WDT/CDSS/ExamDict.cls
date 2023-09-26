/// Creator:丁亚男
/// CreatDate:2020-05-07
/// Description： 检查字典表 
/// Table： CT.WDT.CDSS.ExamDict
Class CT.WDT.CDSS.ExamDict Extends (%Persistent, User.Abstract)
{

/// 国家（国际）编码
Property ExamNationCode As %String;

/// 公司编码
Property ExamCode As %String [ Required ];

/// 检查项目名称
Property ExamName As %String [ Required ];

/// 汉语拼音
Property ExamNamePinyin As %String(MAXLEN = "");

/// 汉语首拼
Property ExamNameFirstPinyin As %String;

/// 英文名
Property ExamEnglishName As %String;

/// 检查一级分类编码
Property ExamFirstClass As %String;

/// 检查二级分类编码
Property ExamSecondClass As %String;

/// 检查三级分类编码
Property ExamClass As %String;

/// 检查项目概述
Property ExamDesc As %String(MAXLEN = "");

/// 检查部位概述
Property ExamParts As %String(MAXLEN = "");

/// 检查过程概述
Property ExamProcess As %String(MAXLEN = "");

/// 适用症概述
Property IndicationOverview As %String(MAXLEN = "");

/// 禁忌症概述
Property ExamTaboo As %String(MAXLEN = "");

/// 不良反应概述
Property AdverseReactions As %String(MAXLEN = "");

/// 注意事项概述
Property ExamPrecautions As %String(MAXLEN = "");

/// 检查结果概述
Property ExamResult As %String(MAXLEN = "");

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

Index NameIndex On ExamName;

Index CodeIndex On ExamCode;

Index NationCodeIndex On ExamNationCode;

Index KnowledgeTotalIndex On KnowledgeTotal;

Storage Default
{
<Data name="ExamDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamNationCode</Value>
</Value>
<Value name="3">
<Value>ExamCode</Value>
</Value>
<Value name="4">
<Value>ExamName</Value>
</Value>
<Value name="5">
<Value>ExamNamePinyin</Value>
</Value>
<Value name="6">
<Value>ExamNameFirstPinyin</Value>
</Value>
<Value name="7">
<Value>ExamEnglishName</Value>
</Value>
<Value name="8">
<Value>ExamFirstClass</Value>
</Value>
<Value name="9">
<Value>ExamSecondClass</Value>
</Value>
<Value name="10">
<Value>ExamClass</Value>
</Value>
<Value name="11">
<Value>ExamDesc</Value>
</Value>
<Value name="12">
<Value>ExamParts</Value>
</Value>
<Value name="13">
<Value>ExamProcess</Value>
</Value>
<Value name="14">
<Value>IndicationOverview</Value>
</Value>
<Value name="15">
<Value>ExamTaboo</Value>
</Value>
<Value name="16">
<Value>AdverseReactions</Value>
</Value>
<Value name="17">
<Value>ExamPrecautions</Value>
</Value>
<Value name="18">
<Value>ExamResult</Value>
</Value>
<Value name="19">
<Value>Remarks</Value>
</Value>
<Value name="20">
<Value>QuoteFlag</Value>
</Value>
<Value name="21">
<Value>KnowledgeTotal</Value>
</Value>
<Value name="22">
<Value>CreateDate</Value>
</Value>
<Value name="23">
<Value>CreateUserID</Value>
</Value>
<Value name="24">
<Value>Alias</Value>
</Value>
<Value name="25">
<Value>UseFlag</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ExamDictD</DataLocation>
<DefaultData>ExamDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ExamDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ExamDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ExamDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
