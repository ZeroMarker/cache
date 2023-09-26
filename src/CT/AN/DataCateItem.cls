/// 数据项分类关联数据项
Class CT.AN.DataCateItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DataCateItem ]
{

/// 数据项分类
Property DataCategory As CT.AN.DataCategory [ Required, SqlColumnNumber = 2 ];

/// 数据项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 3 ];

/// 序号
Property SeqNo As %Float [ SqlColumnNumber = 4 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7 ];

/// 数据归属
Property DataAttribution As CF.AN.DataAttribution [ SqlColumnNumber = 8 ];

/// 数据项分类索引
Index IDataCategory On DataCategory;

Storage Default
{
<Data name="DataCateItemDefaultData">
<Value name="1">
<Value>DataCategory</Value>
</Value>
<Value name="2">
<Value>DataItem</Value>
</Value>
<Value name="3">
<Value>SeqNo</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DataCateItemD</DataLocation>
<DefaultData>DataCateItemDefaultData</DefaultData>
<IdLocation>^CT.AN.DataCateItemD</IdLocation>
<IndexLocation>^CT.AN.DataCateItemI</IndexLocation>
<StreamLocation>^CT.AN.DataCateItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
