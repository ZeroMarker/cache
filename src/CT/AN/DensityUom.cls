/// 浓度单位
Class CT.AN.DensityUom Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DensityUom ]
{

/// 浓度单位
Property Uom As CT.AN.Uom [ Required, SqlColumnNumber = 2 ];

/// 溶质数量
Property SoluteQty As %Float [ SqlColumnNumber = 3 ];

/// 溶质单位
Property SoluteUom As CT.AN.Uom [ SqlColumnNumber = 4 ];

/// 溶剂数量
Property SolventQty As %Float [ SqlColumnNumber = 5 ];

/// 溶剂单位
Property SolventUom As CT.AN.Uom [ SqlColumnNumber = 6 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 8 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9 ];

/// 单位索引
Index IUom On Uom;

/// 单位外键约束
ForeignKey FKUom(Uom) References CT.AN.Uom() [ OnDelete = cascade ];

Storage Default
{
<Data name="DensityUomDefaultData">
<Value name="1">
<Value>Uom</Value>
</Value>
<Value name="2">
<Value>SoluteQty</Value>
</Value>
<Value name="3">
<Value>SoluteUom</Value>
</Value>
<Value name="4">
<Value>SolventQty</Value>
</Value>
<Value name="5">
<Value>SolventUom</Value>
</Value>
<Value name="6">
<Value>ActiveDate</Value>
</Value>
<Value name="7">
<Value>ExpireDate</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DensityUomD</DataLocation>
<DefaultData>DensityUomDefaultData</DefaultData>
<IdLocation>^CT.AN.DensityUomD</IdLocation>
<IndexLocation>^CT.AN.DensityUomI</IndexLocation>
<StreamLocation>^CT.AN.DensityUomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
