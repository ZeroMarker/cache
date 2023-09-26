/// 表单记录数据项
Class CT.AN.DataItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DataItem ]
{

/// 数据项代码
Property Code As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2 ];

/// 数据项名称
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 数据类型(数值或文本)
Property DataType As %String(DISPLAYLIST = ",数值,文本", VALUELIST = ",N,T") [ Required, SqlColumnNumber = 4 ];

/// 选择项(以";"拼接)
Property Options As %String(MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 通道号
Property ChannelNo As %String(MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// 数据项分类
Property ItemCategory As %String(DISPLAYLIST = ",生命体征,事件,药品,检验,治疗", VALUELIST = ",V,E,D,L,T") [ SqlColumnNumber = 7 ];

/// 简拼
Property Alias As %String [ SqlColumnNumber = 8 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 10 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 11 ];

/// 数据项代码唯一索引
Index ICode On Code [ Unique ];

/// 数据项分类索引
Index IItemCategory On ItemCategory;

Storage Default
{
<Data name="DataItemDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>DataType</Value>
</Value>
<Value name="4">
<Value>Options</Value>
</Value>
<Value name="5">
<Value>ChannelNo</Value>
</Value>
<Value name="6">
<Value>ItemCategory</Value>
</Value>
<Value name="7">
<Value>Alias</Value>
</Value>
<Value name="8">
<Value>ActiveDate</Value>
</Value>
<Value name="9">
<Value>ExpireDate</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DataItemD</DataLocation>
<DefaultData>DataItemDefaultData</DefaultData>
<IdLocation>^CT.AN.DataItemD</IdLocation>
<IndexLocation>^CT.AN.DataItemI</IndexLocation>
<StreamLocation>^CT.AN.DataItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
