/// Creator:谷雪萍
/// CreatDate:2022-01-25
/// Description：中医症状字典
/// Table：CT_WDT_CDSS.TCMSymDict
Class CT.WDT.CDSS.TCMSymDict Extends (%Persistent, User.Abstract)
{

/// 症状编码
Property SymDictCode As %String [ Required ];

/// 症状名称
Property SymDictName As %String;

/// 别名
Property SymDictAlias As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已弃用)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On SymDictCode [ Unique ];

Index NameIndex On SymDictName;

Storage Default
{
<Data name="TCMSymDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SymDictCode</Value>
</Value>
<Value name="3">
<Value>SymDictName</Value>
</Value>
<Value name="4">
<Value>SymDictAlias</Value>
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
</Data>
<DataLocation>^CT.WDT.CDSS.TCMSymDictD</DataLocation>
<DefaultData>TCMSymDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMSymDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMSymDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMSymDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
