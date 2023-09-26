/// Creator:高姗姗
/// CreatDate:2021-08-11 
/// Description：中医症候字典
/// Table：CT.WDT.CDSS.TCMSymptom
Class CT.WDT.CDSS.TCMSymptom Extends (%Persistent, User.Abstract)
{

/// 症候编码
Property SymptomCode As %String [ Required ];

/// 症候名称
Property SymptomName As %String;

/// 别名
Property SymptomAlias As %String;

/// 版本
Property SymptomVersion As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On SymptomCode [ Unique ];

Index NameIndex On SymptomName;

Storage Default
{
<Data name="TCMSymptomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SymptomCode</Value>
</Value>
<Value name="3">
<Value>SymptomName</Value>
</Value>
<Value name="4">
<Value>SymptomAlias</Value>
</Value>
<Value name="5">
<Value>SymptomVersion</Value>
</Value>
<Value name="6">
<Value>Operator</Value>
</Value>
<Value name="7">
<Value>OperatTime</Value>
</Value>
<Value name="8">
<Value>State</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TCMSymptomD</DataLocation>
<DefaultData>TCMSymptomDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TCMSymptomD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TCMSymptomI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TCMSymptomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
