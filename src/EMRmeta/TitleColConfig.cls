Class EMRmeta.TitleColConfig Extends (%Persistent, %XML.Adaptor)
{

/// 类型
Property Type As %String(TRUNCATE = 1);

/// 是否只读
Property ReadOnly As %String(TRUNCATE = 1);

/// 值格式
Property Format As %String(TRUNCATE = 1);

/// 是否换行
Property LineBreak As %String(TRUNCATE = 1);

/// 对齐方式
Property Align As %String(TRUNCATE = 1);

/// 是否显示
Property Visible As %String(TRUNCATE = 1);

/// 标题时间前后顺序
Property SeqNum As %Integer;

/// 字体
Property FontStyle As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 扩展参数
Property Params As %String(MAXLEN = 1000, TRUNCATE = 1);

Relationship TitleConfig As EMRmeta.TitleConfig [ Cardinality = parent, Inverse = ColumnConfig ];

Index IdxTitleConfig On TitleConfig;

Index IdxTitleConfigVisibleSeqNum On (TitleConfig, Visible, SeqNum);

Storage Default
{
<Data name="TitleColConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>ReadOnly</Value>
</Value>
<Value name="4">
<Value>Format</Value>
</Value>
<Value name="5">
<Value>LineBreak</Value>
</Value>
<Value name="6">
<Value>Align</Value>
</Value>
<Value name="7">
<Value>Visible</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>SeqNum</Value>
</Value>
<Value name="10">
<Value>FontStyle</Value>
</Value>
<Value name="11">
<Value>Params</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ColumnConfig")</DataLocation>
<DefaultData>TitleColConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ColumnConfig")</IdLocation>
<IndexLocation>^DHCEMRM.TitleColConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.TitleColConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
