///     
Class dbo.BDBloodOutStockItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_BloodOutStockItems, StorageStrategy = Default ]
{

Index IndexMaster On (BloodOutStockDR, PackDR) [ SqlName = Index_Master, Type = index ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

/// Foreign Key FKOutStockItemsOutStock created via DDL
ForeignKey FKOutStockItemsOutStock(BloodOutStockDR) References dbo.BDBloodOutStock(PKBDBloodOutStock) [ SqlName = FK_OutStockItems_OutStock ];

/// Foreign Key FKOutStockItemsPack created via DDL
ForeignKey FKOutStockItemsPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_OutStockItems_Pack ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodOutStockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PayAmount As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ Required, SqlColumnNumber = 5 ];

Property IsReturned As %Library.Boolean [ SqlColumnNumber = 6 ];

Property IsFinish As %Library.Boolean [ SqlColumnNumber = 7 ];

Property CostType As %Library.SmallInt [ SqlColumnNumber = 8 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Price As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 10 ];

Property Quantity As %Library.Float [ SqlColumnNumber = 11 ];

Property OutAmount As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BDBloodOutStockItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodOutStockDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>PayAmount</Value>
</Value>
<Value name="5">
<Value>IsReturned</Value>
</Value>
<Value name="6">
<Value>IsFinish</Value>
</Value>
<Value name="7">
<Value>CostType</Value>
</Value>
<Value name="8">
<Value>CostItemDR</Value>
</Value>
<Value name="9">
<Value>Price</Value>
</Value>
<Value name="10">
<Value>Quantity</Value>
</Value>
<Value name="11">
<Value>OutAmount</Value>
</Value>
</Data>
<DataLocation>^dbo.BDBloodOutStockItemsD</DataLocation>
<DefaultData>BDBloodOutStockItemsDefaultData</DefaultData>
<IdLocation>^dbo.BDBloodOutStockItemsD</IdLocation>
<IndexLocation>^dbo.BDBloodOutStockItemsI</IndexLocation>
<StreamLocation>^dbo.BDBloodOutStockItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
