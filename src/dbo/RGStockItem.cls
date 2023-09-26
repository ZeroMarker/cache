///     
Class dbo.RGStockItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StockItem, StorageStrategy = Default ]
{

/// Foreign Key FKRGStockItemRGLotBox created via DDL
ForeignKey FKRGStockItemRGLotBox(LotBoxDR) References dbo.RGLotBox(PKRGLotBox) [ SqlName = FK_RG_StockItem_RG_LotBox ];

/// Foreign Key FKRGStockItemRGStock created via DDL
ForeignKey FKRGStockItemRGStock(StockDR) References dbo.RGStock(PKRGSTOCK) [ SqlName = FK_RG_StockItem_RG_Stock ];

/// Foreign Key FKRGStockItemPosition created via DDL
ForeignKey FKRGStockItemPosition(PositionDR) References dbo.BTRGPosition(PKBTRGPOSITION) [ SqlName = FK_RG_StockItem_Position ];

Index IndexMaster On LotBoxDR [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStockDR On StockDR [ SqlName = Index_StockDR, Type = index ];

/// DDL Primary Key Specification
Index PKRGStockItem On RowID [ PrimaryKey, SqlName = PK_RG_StockItem, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LotBoxDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PositionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="RGStockItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>StockDR</Value>
</Value>
<Value name="4">
<Value>LotBoxDR</Value>
</Value>
<Value name="5">
<Value>PositionDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStockItemD</DataLocation>
<DefaultData>RGStockItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStockItemD</IdLocation>
<IndexLocation>^dbo.RGStockItemI</IndexLocation>
<StreamLocation>^dbo.RGStockItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
