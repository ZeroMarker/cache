Class User.DHCBPCStockItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCSI_RowId, SqlTableName = DHC_BPC_StockItem, StorageStrategy = CacheStorage ]
{

Property BPCSIIncItemCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCSI_IncItemCode ];

Property BPCSIQty As %Float [ SqlColumnNumber = 3, SqlFieldName = BPCSI_Qty ];

Property BPCSIUomDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPCSI_Uom_Dr ];

Property BPCSIType As %String(DISPLAYLIST = ",All,Consumable,EquipModel,VascularAccess", MAXLEN = 14, SELECTIVITY = "20%", TRUNCATE = 1, VALUELIST = ",A,C,E,V") [ SqlColumnNumber = 5, SqlFieldName = BPCSI_Type ];

Property BPCSIBPEquipModelDr As User.DHCBPCEquipModel [ SqlColumnNumber = 6, SqlFieldName = BPCSI_BPEquipModel_Dr ];

Property BPCSIBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 7, SqlFieldName = BPCSI_BPMode_Dr ];

Property BPCSIVascularAccessDr As User.DHCBPCVascularAccess [ SqlColumnNumber = 8, SqlFieldName = BPCSI_VascularAccess_Dr ];

Property BPCSIBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 9, SqlFieldName = BPCSI_BPCConsumable_Dr ];

Index TypeConSumable On (BPCSIType As Exact, BPCSIBPCConsumableDr As Plus);

Storage CacheStorage
{
<Data name="DHCBPCStockItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCStockItemDefaultData">
<Value name="1">
<Value>BPCSIIncItemCode</Value>
</Value>
<Value name="2">
<Value>BPCSIQty</Value>
</Value>
<Value name="3">
<Value>BPCSIUomDr</Value>
</Value>
<Value name="4">
<Value>BPCSIType</Value>
</Value>
<Value name="5">
<Value>BPCSIBPEquipModelDr</Value>
</Value>
<Value name="6">
<Value>BPCSIBPModeDr</Value>
</Value>
<Value name="7">
<Value>BPCSIVascularAccessDr</Value>
</Value>
<Value name="8">
<Value>BPCSIBPCConsumableDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("StockItem")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("StockItem")</IdLocation>
<IndexLocation>^DHCBPC("StockItem",0)</IndexLocation>
<SqlRowIdName>BPCSI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBPCStockItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
