/// 事件参数
Class CT.AN.EventOptions Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EventOptions ]
{

/// 事件项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 2 ];

/// 数据类型
Property DataType As %String(DISPLAYLIST = ",字符串,数值,图片", VALUELIST = ",S,N,I") [ Required, SqlColumnNumber = 3 ];

/// 明细项标题
Property Description As %String(MAXLEN = 100) [ SqlColumnNumber = 4 ];

/// 编辑控件名称
Property Editor As %String [ Required, SqlColumnNumber = 5 ];

/// 控件宽度
Property EditorSize As %String [ SqlColumnNumber = 6 ];

/// 单位
Property Unit As %String [ SqlColumnNumber = 7 ];

/// 值范围
Property ValueRange As %String [ SqlColumnNumber = 8 ];

/// 排序号
Property SeqNo As %Integer [ SqlColumnNumber = 9 ];

/// 明细项代码
Property Code As %String [ SqlColumnNumber = 10 ];

/// 明细项类型
Property OptType As %String(DISPLAYLIST = ",药品,其他", VALUELIST = ",D,O") [ SqlColumnNumber = 11 ];

/// 数据项索引
Index IDataItem On DataItem;

/// 数据项外键约束
ForeignKey FKDataItem(DataItem) References CT.AN.DataItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="EventOptionsDefaultData">
<Value name="1">
<Value>DataItem</Value>
</Value>
<Value name="2">
<Value>DataType</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Editor</Value>
</Value>
<Value name="5">
<Value>EditorSize</Value>
</Value>
<Value name="6">
<Value>Unit</Value>
</Value>
<Value name="7">
<Value>ValueRange</Value>
</Value>
<Value name="8">
<Value>SeqNo</Value>
</Value>
<Value name="9">
<Value>Code</Value>
</Value>
<Value name="10">
<Value>OptType</Value>
</Value>
</Data>
<DataLocation>^CT.AN.EventOptionsD</DataLocation>
<DefaultData>EventOptionsDefaultData</DefaultData>
<IdLocation>^CT.AN.EventOptionsD</IdLocation>
<IndexLocation>^CT.AN.EventOptionsI</IndexLocation>
<StreamLocation>^CT.AN.EventOptionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
