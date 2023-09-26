/// 速度单位关系
Class CT.AN.SpeedUom Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SpeedUom ]
{

/// 速度单位
Property Uom As CT.AN.Uom [ Required, SqlColumnNumber = 2 ];

/// 剂量单位
Property DoseUom As CT.AN.Uom [ Required, SqlColumnNumber = 3 ];

/// 时间单位
Property TimeUom As CT.AN.Uom [ Required, SqlColumnNumber = 4 ];

/// 体重单位
Property WeightUom As CT.AN.Uom [ SqlColumnNumber = 5 ];

/// 速度单位索引
Index IUom On Uom;

/// 单位外键约束
ForeignKey FKUom(Uom) References CT.AN.Uom() [ OnDelete = cascade ];

Storage Default
{
<Data name="SpeedUomDefaultData">
<Value name="1">
<Value>Uom</Value>
</Value>
<Value name="2">
<Value>DoseUom</Value>
</Value>
<Value name="3">
<Value>TimeUom</Value>
</Value>
<Value name="4">
<Value>WeightUom</Value>
</Value>
</Data>
<DataLocation>^CT.AN.SpeedUomD</DataLocation>
<DefaultData>SpeedUomDefaultData</DefaultData>
<IdLocation>^CT.AN.SpeedUomD</IdLocation>
<IndexLocation>^CT.AN.SpeedUomI</IndexLocation>
<StreamLocation>^CT.AN.SpeedUomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
