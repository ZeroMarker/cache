Class User.DHCANCStockItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANCSI_RowId, SqlTableName = DHC_ANC_StockItem, StorageStrategy = CacheStorage ]
{

Property ANCSIIncItemCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCSI_IncItemCode ];

Property ANCSIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCSI_Desc ];

Property ANCSIQty As %Float [ SqlColumnNumber = 4, SqlFieldName = ANCSI_Qty ];

Property ANCSIUomDr As %String [ SqlColumnNumber = 5, SqlFieldName = ANCSI_Uom_Dr ];

Property ANCSIType As %String(DISPLAYLIST = ",HighValueConsumable,Consumable,Implant", MAXLEN = 20, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",H,C,I") [ SqlColumnNumber = 6, SqlFieldName = ANCSI_Type ];

Property ANCSIANCStockCatDr As User.DHCANCStockCat [ SqlColumnNumber = 7, SqlFieldName = ANCSI_ANCStockCat_Dr ];

Property ANCSIVascularAccessDr As %String [ SqlColumnNumber = 8, SqlFieldName = ANCSI_VascularAccess_Dr ];

Property ANCSIANCConsumableDr As %String [ SqlColumnNumber = 9, SqlFieldName = ANCSI_ANCConsumable_Dr ];

Storage CacheStorage
{
<Data name="DHCANCStockItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCStockItemDefaultData">
<Value name="1">
<Value>ANCSIIncItemCode</Value>
</Value>
<Value name="2">
<Value>ANCSIDesc</Value>
</Value>
<Value name="3">
<Value>ANCSIQty</Value>
</Value>
<Value name="4">
<Value>ANCSIUomDr</Value>
</Value>
<Value name="5">
<Value>ANCSIType</Value>
</Value>
<Value name="6">
<Value>ANCSIANCStockCatDr</Value>
</Value>
<Value name="7">
<Value>ANCSIVascularAccessDr</Value>
</Value>
<Value name="8">
<Value>ANCSIANCConsumableDr</Value>
</Value>
</Data>
<DataLocation>^DHCANC("StockItem")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("StockItem")</IdLocation>
<IndexLocation>^DHCANC("StockItem",0)</IndexLocation>
<SqlRowIdName>ANCSI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCANCStockItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
