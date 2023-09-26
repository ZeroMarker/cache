/// Creator:丁亚男
/// CreatDate:2020-06-12
/// Description：输血品分类字典表 
/// Table：CT.WDT.CDSS.BPClassDict
Class CT.WDT.CDSS.BPClassDict Extends (%Persistent, User.Abstract)
{

/// 输血品分类编码
Property BPClassCode As %String [ Required ];

/// 输血品分类名称
Property BPClassName As %String;

/// 输血品分类名称拼音
Property BPClassPinyin As %String(MAXLEN = 100);

/// 拼音首拼
Property BPClassFirstPinyin As %String;

/// 输血品分类说明
Property BPClassDesc As %String(MAXLEN = 200);

/// 更新时间
Property UpdateDate As %TimeStamp;

/// 更新人员
Property UpdateUser As %String(MAXLEN = 12);

/// 使用标识（0为使用，1为停用）
Property UseFlag As %Integer;

/// 别名
Property BPClassAlias As %String;

Index CodeIndex On BPClassCode As Exact;

Index NameIndex On BPClassName As Exact;

Index UpdateDateIndex On UpdateDate As Exact;

Storage Default
{
<Data name="BPClassDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BPClassCode</Value>
</Value>
<Value name="3">
<Value>BPClassName</Value>
</Value>
<Value name="4">
<Value>BPClassPinyin</Value>
</Value>
<Value name="5">
<Value>BPClassFirstPinyin</Value>
</Value>
<Value name="6">
<Value>BPClassDesc</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateUser</Value>
</Value>
<Value name="9">
<Value>UseFlag</Value>
</Value>
<Value name="10">
<Value>BPClassAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.BPClassDictD</DataLocation>
<DefaultData>BPClassDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.BPClassDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.BPClassDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.BPClassDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
