/// 浓度单位
Class CT.AN.ConcentrationUom Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ConcentrationUom ]
{

/// 浓度单位
Property Uom As CT.AN.Uom [ Required, SqlColumnNumber = 2 ];

/// 溶质单位
Property SoluteUom As CT.AN.Uom [ SqlColumnNumber = 3 ];

/// 溶剂单位
Property SolventUom As CT.AN.Uom [ SqlColumnNumber = 4 ];

/// 速度单位索引
Index IUom On Uom;

/// 单位外键约束
ForeignKey FKUom(Uom) References CT.AN.Uom() [ OnDelete = cascade ];

Storage Default
{
<Data name="ConcentrationUomDefaultData">
<Value name="1">
<Value>Uom</Value>
</Value>
<Value name="2">
<Value>SoluteUom</Value>
</Value>
<Value name="3">
<Value>SolventUom</Value>
</Value>
</Data>
<DataLocation>^CT.AN.ConcentrationUomD</DataLocation>
<DefaultData>ConcentrationUomDefaultData</DefaultData>
<IdLocation>^CT.AN.ConcentrationUomD</IdLocation>
<IndexLocation>^CT.AN.ConcentrationUomI</IndexLocation>
<StreamLocation>^CT.AN.ConcentrationUomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
