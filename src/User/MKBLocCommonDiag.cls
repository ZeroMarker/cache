/// Creator:谷雪萍
/// CreatDate:2021-03-17
/// Description：科室常用诊断表-用于结构化诊断录入
/// Table：User.MKBLocCommonDiag
Class User.MKBLocCommonDiag Extends (%Persistent, User.Abstract)
{

/// 科室名称
Property LocDesc As %String;

/// 术语ID
Property TermDR As User.MKBTerm;

/// 数量
Property Frequency As %String;

/// 科室+术语ID索引 (唯一)
Index LocTermIdx On (LocDesc As Exact, TermDR As Exact);

/// 科室+数量+术语ID索引
Index FrequencyIndex On (LocDesc As Exact, Frequency As Exact, TermDR As Exact);

Storage Default
{
<Data name="MKBLocCommonDiagDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocDesc</Value>
</Value>
<Value name="3">
<Value>TermDR</Value>
</Value>
<Value name="4">
<Value>Frequency</Value>
</Value>
</Data>
<DataLocation>^User.MKBLocCommonDiagD</DataLocation>
<DefaultData>MKBLocCommonDiagDefaultData</DefaultData>
<IdLocation>^User.MKBLocCommonDiagD</IdLocation>
<IndexLocation>^User.MKBLocCommonDiagI</IndexLocation>
<StreamLocation>^User.MKBLocCommonDiagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
