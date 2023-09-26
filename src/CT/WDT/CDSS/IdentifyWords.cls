/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：识别词字典表V2.0
/// Table：CT.WDT.CDSS.IdentifyWords
Class CT.WDT.CDSS.IdentifyWords Extends (%Persistent, User.Abstract)
{

/// 识别词编码
Property WordsCode As %String [ Required ];

/// 识别词名称
Property WordsDesc As %String(MAXLEN = 200) [ Required ];

/// 类型（D-诊断条件/I-识别词）
Property WordsType As %String;

/// 状态（编辑中/审核中/不通过/上线/下线）
Property WordsState As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 审核人员
Property AuditUser As %String;

/// 审核时间
Property AuditDate As %TimeStamp;

/// 拆分状态（0是/1否）
Property SplitState As %Integer;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index CodeIndex On WordsCode [ Unique ];

Index DescIndex On WordsDesc;

Index TypeIndex On WordsType;

Index DateIndex On UpdateDate;

Index DescTypeIndex On (WordsDesc As Exact, WordsType As Exact);

Storage Default
{
<Data name="IdentifyWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WordsCode</Value>
</Value>
<Value name="3">
<Value>WordsDesc</Value>
</Value>
<Value name="4">
<Value>WordsType</Value>
</Value>
<Value name="5">
<Value>WordsState</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>AuditUser</Value>
</Value>
<Value name="9">
<Value>AuditDate</Value>
</Value>
<Value name="10">
<Value>SplitState</Value>
</Value>
<Value name="11">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.IdentifyWordsD</DataLocation>
<DefaultData>IdentifyWordsDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.IdentifyWordsD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.IdentifyWordsI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.IdentifyWordsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
