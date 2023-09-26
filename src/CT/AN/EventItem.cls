/// 表单事件项目
Class CT.AN.EventItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = EventItem ]
{

/// 数据项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 2 ];

/// 是否显示明细
Property ShowDetail As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 3 ];

/// 图例
Property Legend As CT.AN.Legend [ SqlColumnNumber = 4 ];

/// 图例颜色
Property LegendColor As %String [ SqlColumnNumber = 5 ];

/// 是否显示项目名称
Property ShowItemDesc As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 6 ];

/// 是否显示文本标记
Property ShowTextMark As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// 文本标记方向
Property MarkDirection As %String(DISPLAYLIST = ",竖排,横排", VALUELIST = ",V,H") [ SqlColumnNumber = 8 ];

/// 关联开始事件
Property RelatedStartEvent As CT.AN.DataItem [ SqlColumnNumber = 9 ];

/// 关联结束事件
Property RelatedEndEvent As CT.AN.DataItem [ SqlColumnNumber = 10 ];

/// 条形标记颜色
Property BarColor As %String [ SqlColumnNumber = 11 ];

/// 数据项索引
Index IDataItem On DataItem;

/// 数据项外键约束
ForeignKey FKDataItem(DataItem) References CT.AN.DataItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="EventItemDefaultData">
<Value name="1">
<Value>DataItem</Value>
</Value>
<Value name="2">
<Value>ShowDetail</Value>
</Value>
<Value name="3">
<Value>Legend</Value>
</Value>
<Value name="4">
<Value>LegendColor</Value>
</Value>
<Value name="5">
<Value>ShowItemDesc</Value>
</Value>
<Value name="6">
<Value>ShowTextMark</Value>
</Value>
<Value name="7">
<Value>MarkDirection</Value>
</Value>
<Value name="8">
<Value>RelatedStartEvent</Value>
</Value>
<Value name="9">
<Value>RelatedEndEvent</Value>
</Value>
<Value name="10">
<Value>BarColor</Value>
</Value>
</Data>
<DataLocation>^CT.AN.EventItemD</DataLocation>
<DefaultData>EventItemDefaultData</DefaultData>
<IdLocation>^CT.AN.EventItemD</IdLocation>
<IndexLocation>^CT.AN.EventItemI</IndexLocation>
<StreamLocation>^CT.AN.EventItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
