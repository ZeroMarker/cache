/// 药物组
Class CT.AN.DrugGroup Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DrugGroup ]
{

/// 数据项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 2 ];

/// 是否固定比例
Property FixedProportion As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 3 ];

/// 数据项索引
Index IDataItem On DataItem;

/// 数据项外键约束
ForeignKey FKDataItem(DataItem) References CT.AN.DataItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="DrugGroupDefaultData">
<Value name="1">
<Value>DataItem</Value>
</Value>
<Value name="2">
<Value>FixedProportion</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DrugGroupD</DataLocation>
<DefaultData>DrugGroupDefaultData</DefaultData>
<IdLocation>^CT.AN.DrugGroupD</IdLocation>
<IndexLocation>^CT.AN.DrugGroupI</IndexLocation>
<StreamLocation>^CT.AN.DrugGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
