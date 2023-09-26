/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗节点内容依据表
/// Table：CT.WDT.CDSS.RuleBasis
Class CT.WDT.CDSS.RuleBasis Extends (%Persistent, User.Abstract)
{

/// 来源内容
Property Content As %String(MAXLEN = "");

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String;

Storage Default
{
<Data name="RuleBasisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>UpdateUser</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
<Value name="5">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleBasisD</DataLocation>
<DefaultData>RuleBasisDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleBasisD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleBasisI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleBasisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
