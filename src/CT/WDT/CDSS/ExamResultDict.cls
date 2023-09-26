/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：检查结果字典表V2.0
/// Table：CT.WDT.CDSS.ExamResultDict
Class CT.WDT.CDSS.ExamResultDict Extends (%Persistent, User.Abstract)
{

/// 检查结果代码
Property ERCode As %String [ Required ];

/// 检查结果名称
Property ERDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property ExamResultAlias As %String;

Index CodeIndex On ERCode [ Unique ];

Index DescIndex On ERDesc;

Storage Default
{
<Data name="ExamResultDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ERCode</Value>
</Value>
<Value name="3">
<Value>ERDesc</Value>
</Value>
<Value name="4">
<Value>UseFlag</Value>
</Value>
<Value name="5">
<Value>UpdateUser</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>ExamResultAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ExamResultDictD</DataLocation>
<DefaultData>ExamResultDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ExamResultDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ExamResultDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ExamResultDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
