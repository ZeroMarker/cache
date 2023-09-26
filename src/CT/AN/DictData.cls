/// 字典数据
Class CT.AN.DictData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DictData ]
{

/// 数据描述
Property Description As %String(MAXLEN = 2000) [ SqlColumnNumber = 2 ];

/// 字典
Property Dictionary As CT.AN.Dictionary [ Required, SqlColumnNumber = 3 ];

/// 拼音码
Property Alias As %String(MAXLEN = 2000) [ SqlColumnNumber = 4 ];

/// 单位描述
Property Uom As %String [ SqlColumnNumber = 5 ];

/// 分数值
Property Score As %String [ SqlColumnNumber = 6 ];

/// 备用字段1
Property DataItem1 As %String(MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 备用字段2
Property DataItem2 As %String(MAXLEN = 500) [ SqlColumnNumber = 8 ];

/// 备用字段3
Property DataItem3 As %String(MAXLEN = 500) [ SqlColumnNumber = 9 ];

/// 数据代码
Property Code As %String(MAXLEN = 200) [ SqlColumnNumber = 10 ];

/// 大段文本
Property DataItem4 As %String(MAXLEN = 2000) [ SqlColumnNumber = 11 ];

/// 字典索引
Index IDictionary On Dictionary;

Index ICode On (Dictionary, Code) [ Unique ];

/// 字典外键约束
ForeignKey FKDictionary(Dictionary) References CT.AN.Dictionary() [ OnDelete = cascade ];

Storage Default
{
<Data name="DictDataDefaultData">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>Dictionary</Value>
</Value>
<Value name="3">
<Value>Alias</Value>
</Value>
<Value name="4">
<Value>Uom</Value>
</Value>
<Value name="5">
<Value>Score</Value>
</Value>
<Value name="6">
<Value>DataItem1</Value>
</Value>
<Value name="7">
<Value>DataItem2</Value>
</Value>
<Value name="8">
<Value>DataItem3</Value>
</Value>
<Value name="9">
<Value>Code</Value>
</Value>
<Value name="10">
<Value>DataItem4</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DictDataD</DataLocation>
<DefaultData>DictDataDefaultData</DefaultData>
<IdLocation>^CT.AN.DictDataD</IdLocation>
<IndexLocation>^CT.AN.DictDataI</IndexLocation>
<StreamLocation>^CT.AN.DictDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
