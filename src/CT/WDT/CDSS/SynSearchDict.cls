/// Creator:丁亚男
/// CreatDate:2022-03-09
/// Description：同义词检索字典
/// Table：CT.WDT.CDSS.SynSearchDict
Class CT.WDT.CDSS.SynSearchDict Extends (%Persistent, User.Abstract)
{

/// 简称中文
Property SynSAbbre As %String [ Required ];

/// 简称拼音码
Property SynSAbbrePYCode As %String [ Required ];

/// 全名
Property SynSFullName As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperateTime As %TimeStamp;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index PYCodeIndex On SynSAbbrePYCode;

Index AbbreIndex On (SynSAbbre As Exact, SynSFullName As Exact);

Storage Default
{
<Data name="SynSearchDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SynSAbbre</Value>
</Value>
<Value name="3">
<Value>SynSAbbrePYCode</Value>
</Value>
<Value name="4">
<Value>SynSFullName</Value>
</Value>
<Value name="5">
<Value>Operator</Value>
</Value>
<Value name="6">
<Value>OperateTime</Value>
</Value>
<Value name="7">
<Value>State</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.SynSearchDictD</DataLocation>
<DefaultData>SynSearchDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.SynSearchDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.SynSearchDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.SynSearchDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
