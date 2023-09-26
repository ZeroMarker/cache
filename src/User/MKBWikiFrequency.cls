/// 描述: 基础数据平台   医卫百科小程序科室诊断频次表
/// 编写者：谷雪萍
/// 编写日期: 2019-08-29
Class User.MKBWikiFrequency Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_WikiFrequency ]
{

// ^User.MKBWikiFrequencyD   ^User.MKBWikiFrequencyI

/// 对应表名 节点 2
Property MKBWFTableName As %String(MAXLEN = "") [ Required ];

/// 对应表数据RowId 节点 3
Property MKBWFDataReference As User.MKBTerm [ Required ];

/// 对应表数据描述 节点 4
Property MKBWFDesc As %String(MAXLEN = "") [ Required ];

/// 时间 节点 5
Property MKBWFDate As %Date [ InitialExpression = {+$h}, Required ];

/// 表名的索引
Index TableNameIndex On MKBWFTableName;

/// 表名称+频率 的索引
Index TableFreqIdx On (MKBWFTableName, MKBWFDataReference, MKBWFDate);

/// 表名称+数据rowid 的索引
Index TableReferenceIdx On (MKBWFTableName, MKBWFDataReference);

Storage Default
{
<Data name="MKBWikiFrequencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBWFTableName</Value>
</Value>
<Value name="3">
<Value>MKBWFDataReference</Value>
</Value>
<Value name="4">
<Value>MKBWFDesc</Value>
</Value>
<Value name="5">
<Value>MKBWFDate</Value>
</Value>
</Data>
<DataLocation>^User.MKBWikiFrequencyD</DataLocation>
<DefaultData>MKBWikiFrequencyDefaultData</DefaultData>
<IdLocation>^User.MKBWikiFrequencyD</IdLocation>
<IndexLocation>^User.MKBWikiFrequencyI</IndexLocation>
<StreamLocation>^User.MKBWikiFrequencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
