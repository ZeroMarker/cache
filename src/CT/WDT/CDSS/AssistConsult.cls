/// Creator:谷雪萍
/// CreatDate:2023-04-20
/// Description：辅助问诊字典表
/// Table：CT_WDT_CDSS.AssistConsult
Class CT.WDT.CDSS.AssistConsult Extends (%Persistent, User.Abstract)
{

/// 主要症状
Property MainSymptom As %String [ Required ];

/// 科室
Property LocDesc As %String;

/// 部位
Property PartDesc As %String(MAXLEN = "");

/// 伴随症状
Property CompanySym As %String;

/// 病因诱因
Property Cause As %String;

/// 发病缓急
Property Emergency As %String;

/// 程度
Property Degree As %String;

/// 性质
Property Nature As %String;

/// 缓解或加重因素
Property ReliefFactor As %String;

/// 精神
Property Spirit As %TimeStamp;

/// 体力
Property Physical As %String;

/// 食欲
Property Appetite As %String;

/// 睡眠
Property Sleep As %String;

/// 大小便
Property Defecation As %String;

/// 使用标识（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 操作人员
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

Index MainSymptomIndex On MainSymptom;

Storage Default
{
<Data name="AssistConsultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MainSymptom</Value>
</Value>
<Value name="3">
<Value>LocDesc</Value>
</Value>
<Value name="4">
<Value>CompanySym</Value>
</Value>
<Value name="5">
<Value>Cause</Value>
</Value>
<Value name="6">
<Value>Emergency</Value>
</Value>
<Value name="7">
<Value>Degree</Value>
</Value>
<Value name="8">
<Value>Nature</Value>
</Value>
<Value name="9">
<Value>ReliefFactor</Value>
</Value>
<Value name="10">
<Value>Spirit</Value>
</Value>
<Value name="11">
<Value>Physical</Value>
</Value>
<Value name="12">
<Value>Appetite</Value>
</Value>
<Value name="13">
<Value>Sleep</Value>
</Value>
<Value name="14">
<Value>Defecation</Value>
</Value>
<Value name="15">
<Value>UseFlag</Value>
</Value>
<Value name="16">
<Value>UpdateUser</Value>
</Value>
<Value name="17">
<Value>UpdateDate</Value>
</Value>
<Value name="18">
<Value>PartDesc</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssistConsultD</DataLocation>
<DefaultData>AssistConsultDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssistConsultD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssistConsultI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssistConsultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
