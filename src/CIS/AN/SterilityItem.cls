/// 无菌包物品
Class CIS.AN.SterilityItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SterilityItem ]
{

/// 无菌包
Property SterilityPack As CIS.AN.SterilityPack [ Required, SqlColumnNumber = 2 ];

/// 物品代码，用与手术物品代码对照
Property ItemCode As %String [ SqlColumnNumber = 3 ];

/// 物品名称
Property ItemDesc As %String [ Required, SqlColumnNumber = 4 ];

/// 物品数量
Property Qty As %String [ SqlColumnNumber = 5 ];

Index ISterilityPack On SterilityPack;

/// 外键约束
ForeignKey FKSterilityPack(SterilityPack) References CIS.AN.SterilityPack() [ OnDelete = cascade ];

Storage Default
{
<Data name="SterilityItemDefaultData">
<Value name="1">
<Value>SterilityPack</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>Qty</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SterilityItemD</DataLocation>
<DefaultData>SterilityItemDefaultData</DefaultData>
<IdLocation>^CIS.AN.SterilityItemD</IdLocation>
<IndexLocation>^CIS.AN.SterilityItemI</IndexLocation>
<StreamLocation>^CIS.AN.SterilityItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
