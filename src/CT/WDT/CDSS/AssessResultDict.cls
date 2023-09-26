/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：评估结果字典表V2.0
/// Table：CT.WDT.CDSS.AssessResultDict
Class CT.WDT.CDSS.AssessResultDict Extends (%Persistent, User.Abstract)
{

/// 评估结果代码
Property ARCode As %String [ Required ];

/// 评估结果名称
Property ARDesc As %String [ Required ];

/// 使用标志（0在用，1停用）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property AssessResultAlias As %String;

Index CodeIndex On ARCode [ Unique ];

Index DescIndex On ARDesc;

Storage Default
{
<Data name="AssessResultDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ARCode</Value>
</Value>
<Value name="3">
<Value>ARDesc</Value>
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
<Value>AssessResultAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssessResultDictD</DataLocation>
<DefaultData>AssessResultDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssessResultDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssessResultDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssessResultDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
