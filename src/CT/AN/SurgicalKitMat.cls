/// 手术包关联手术物品
Class CT.AN.SurgicalKitMat Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SurgicalKitMat ]
{

/// 手术包
Property SurgicalKit As CT.AN.SurgicalKit [ Required, SqlColumnNumber = 2 ];

/// 手术物品
Property SurgicalMaterial As CT.AN.SurgicalMaterial [ Required, SqlColumnNumber = 3 ];

/// 默认数量
Property DefaultQty As %Float [ InitialExpression = 1, SqlColumnNumber = 4 ];

/// 序号
Property Seq As %String [ SqlColumnNumber = 5 ];

/// 包切口
Property PericardialCut As %String [ SqlColumnNumber = 6 ];

/// 主键索引
Index IKey On (SurgicalKit, SurgicalMaterial) [ Unique ];

/// 手术包索引
Index IKit On SurgicalKit;

ForeignKey FKSurgicalKit(SurgicalKit) References CT.AN.SurgicalKit() [ OnDelete = cascade ];

Storage Default
{
<Data name="SurgicalKitMatDefaultData">
<Value name="1">
<Value>SurgicalKit</Value>
</Value>
<Value name="2">
<Value>SurgicalMaterial</Value>
</Value>
<Value name="3">
<Value>DefaultQty</Value>
</Value>
<Value name="4">
<Value>Seq</Value>
</Value>
<Value name="5">
<Value>PericardialCut</Value>
</Value>
</Data>
<DataLocation>^CT.AN.SurgicalKitMatD</DataLocation>
<DefaultData>SurgicalKitMatDefaultData</DefaultData>
<IdLocation>^CT.AN.SurgicalKitMatD</IdLocation>
<IndexLocation>^CT.AN.SurgicalKitMatI</IndexLocation>
<StreamLocation>^CT.AN.SurgicalKitMatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
