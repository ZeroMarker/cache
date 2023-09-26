/// Creator:胡宜良
/// CreatDate:2021-08-24
/// Description：中医疾病字典
/// Table：CT.WDT.CDSS.TCMDisease
Class CT.WDT.CDSS.TCMDisease Extends (%Persistent, User.Abstract)
{

/// 疾病编码
Property DiseaseCode As %String [ Required ];

/// 疾病名称
Property DiseaseName As %String;

/// 对应西医名称
Property DiseaseMedicineName As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String(MAXLEN = 10);

/// 别名
Property DiseaseAlias As %String;

/// 版本
Property Version As %String;

Index CodeIndex On DiseaseCode [ Unique ];

Index NameIndex On DiseaseName As Exact;

Index OperatTimeIndex On OperatTime;

Index BothIndex On (DiseaseCode, DiseaseName);

Storage Default
{
<Data name="TCMDiseaseDefaultData">
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
<Value>DiseaseMedicineName</Value>
</Value>
<Value name="5">
<Value>Operator</Value>
</Value>
<Value name="6">
<Value>OperatTime</Value>
</Value>
<Value name="7">
<Value>State</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
<Value name="9">
<Value>QuoteFlag</Value>
</Value>
<Value name="10">
<Value>DiseaseAlias</Value>
</Value>
<Value name="11">
<Value>Version</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMDiseaseD</DataLocation>
<DefaultData>TCMDiseaseDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMDiseaseD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMDiseaseI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
