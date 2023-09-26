/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：扩展码字典表V2.0
/// Table：CT.WDT.CDSS.ExtendCodeDict
Class CT.WDT.CDSS.ExtendCodeDict Extends (%Persistent, User.Abstract)
{

/// 扩展码代码
Property ExtendCode As %String [ Required ];

/// 扩展码名称
Property ExtendDesc As %String(MAXLEN = "") [ Required ];

/// 扩展码ICD编码
Property ExtendICD As %String;

/// 版本
Property ExtendVersion As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property ExtendAlias As %String;

Index CodeIndex On ExtendCode [ Unique ];

Index DescIndex On ExtendDesc;

Index ICDCodeIndex On ExtendICD;

Storage Default
{
<Data name="ExtendCodeDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExtendCode</Value>
</Value>
<Value name="3">
<Value>ExtendDesc</Value>
</Value>
<Value name="4">
<Value>ExtendICD</Value>
</Value>
<Value name="5">
<Value>ExtendVersion</Value>
</Value>
<Value name="6">
<Value>UseFlag</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
<Value name="10">
<Value>ExtendAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ExtendCodeDictD</DataLocation>
<DefaultData>ExtendCodeDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ExtendCodeDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ExtendCodeDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ExtendCodeDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
