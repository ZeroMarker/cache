/// Creator:丁亚男
/// CreatDate:2020-06-15
/// Description：手术字典表 
/// Table：CT.WDT.CDSS.OperationDict
Class CT.WDT.CDSS.OperationDict Extends (%Persistent, User.Abstract)
{

/// 国家（国际）编码
Property OperationNationCode As %String;

/// 手术编码（公司编码）
Property OperationCode As %String [ Required ];

/// 手术名称
Property OperationName As %String [ Required ];

/// 汉语拼音
Property OperationPinyin As %String(MAXLEN = 200);

/// 汉语首拼
Property OperationFirstPinyin As %String;

/// 英文名
Property OperationEnglishName As %String;

/// ICD-9编码
Property ICD9Code As %String;

/// ICD-9名称
Property ICD9Name As %String;

/// 手术所属科室名称
Property DeptName As %String;

/// 手术类别（诊断性手术、根治性手术、姑息性手术）
Property OperationClass As %String(MAXLEN = 12);

/// 使用标识（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 更新时间
Property UpdateDate As %TimeStamp;

/// 更新人员
Property UpdateUser As %String(MAXLEN = 12);

/// 备注
Property Remarks As %String(MAXLEN = 200);

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

/// 知识数量
Property KnowledgeTotal As %Integer;

/// 别名
Property OperAliasName As %String(MAXLEN = "");

/// 版本
Property Version As %String;

// 手术分类

// Property OperationCategory As %String;

// 手术分级

// Property OperationGrade As %String;

/// 麻醉方式
Property AnesthesiaMode As CT.WDT.CDSS.CommonDict;

Index NameIndex On OperationName;

Index CodeIndex On OperationCode;

Index NationCodeIndex On OperationNationCode;

Index TotalIndex On KnowledgeTotal;

Storage Default
{
<Data name="OperationDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperationNationCode</Value>
</Value>
<Value name="3">
<Value>OperationCode</Value>
</Value>
<Value name="4">
<Value>OperationName</Value>
</Value>
<Value name="5">
<Value>OperationPinyin</Value>
</Value>
<Value name="6">
<Value>OperationFirstPinyin</Value>
</Value>
<Value name="7">
<Value>OperationEnglishName</Value>
</Value>
<Value name="8">
<Value>ICD9Code</Value>
</Value>
<Value name="9">
<Value>ICD9Name</Value>
</Value>
<Value name="10">
<Value>DeptName</Value>
</Value>
<Value name="11">
<Value>OperationClass</Value>
</Value>
<Value name="12">
<Value>UseFlag</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
<Value name="15">
<Value>Remarks</Value>
</Value>
<Value name="16">
<Value>QuoteFlag</Value>
</Value>
<Value name="17">
<Value>KnowledgeTotal</Value>
</Value>
<Value name="18">
<Value>OperAliasName</Value>
</Value>
<Value name="19">
<Value>Version</Value>
</Value>
<Value name="20">
<Value>AnesthesiaMode</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.OperationDictD</DataLocation>
<DefaultData>OperationDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.OperationDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.OperationDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.OperationDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
