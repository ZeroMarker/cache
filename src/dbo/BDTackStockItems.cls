///     
Class dbo.BDTackStockItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TackStockItems, StorageStrategy = Default ]
{

/// Foreign Key FKBDTSItemsPack created via DDL
ForeignKey FKBDTSItemsPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_TSItems_Pack ];

/// Foreign Key FKBDTSItemsTackStock created via DDL
ForeignKey FKBDTSItemsTackStock(TackStockDR) References dbo.BDTackStock(PKBDTACKSTOCK) [ SqlName = FK_BD_TSItems_TackStock ];

Index IndexMaster On (TackStockDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

/// DDL Primary Key Specification
Index PKBDTACKSTOCKITEMS On RowID [ PrimaryKey, SqlName = PK_BD_TACKSTOCKITEMS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TackStockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDTackStockItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TackStockDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTackStockItemsD</DataLocation>
<DefaultData>BDTackStockItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDTackStockItemsD</IdLocation>
<IndexLocation>^dbo.BDTackStockItemsI</IndexLocation>
<StreamLocation>^dbo.BDTackStockItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
