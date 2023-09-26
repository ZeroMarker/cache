Class User.DHCBPArrangeStock Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPAS_RowId, SqlTableName = DHC_BP_ArrangeStock, StorageStrategy = CacheStorage ]
{

Property BPASBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 2, SqlFieldName = BPAS_BPArrange_Dr ];

Property BPASBPCSIDr As User.DHCBPCStockItem [ SqlColumnNumber = 3, SqlFieldName = BPAS_BPCSI_Dr ];

Property BPASQty As %Float [ SqlColumnNumber = 4, SqlFieldName = BPAS_Qty ];

Property BPASPreQty As %Float [ SqlColumnNumber = 5, SqlFieldName = BPAS_PreQty ];

Property BPASStockAdjQty As %Float [ SqlColumnNumber = 6, SqlFieldName = BPAS_StockAdjQty ];

Property BPASUpdateUserDr As %String [ SqlColumnNumber = 7, SqlFieldName = BPAS_UpdateUser_Dr ];

Property BPASUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BPAS_UpdateDate ];

Property BPASUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BPAS_UpdateTime ];

Index ArrStockItem On (BPASBPArrangeDr As Exact, BPASBPCSIDr As Plus);

Storage CacheStorage
{
<Data name="DHCBPArrangeStockClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPArrangeStockDefaultData">
<Value name="1">
<Value>BPASBPArrangeDr</Value>
</Value>
<Value name="2">
<Value>BPASBPCSIDr</Value>
</Value>
<Value name="3">
<Value>BPASQty</Value>
</Value>
<Value name="4">
<Value>BPASPreQty</Value>
</Value>
<Value name="5">
<Value>BPASStockAdjQty</Value>
</Value>
<Value name="6">
<Value>BPASUpdateUserDr</Value>
</Value>
<Value name="7">
<Value>BPASUpdateDate</Value>
</Value>
<Value name="8">
<Value>BPASUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPArrangeStock</DataLocation>
<DefaultData>DHCBPArrangeStockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPArrangeStock</IdLocation>
<IndexLocation>^DHCBPArrangeStock(0)</IndexLocation>
<StreamLocation>^User.DHCBPArrangeStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
