Class dbo.RGStockCheckItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StockCheckItem, StorageStrategy = Default ]
{

Index IndexMaster On (StockCheckDR, ReagentDR, LotDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexLotBarcode On LotBarcode [ SqlName = Index_LotBarcode, Type = index ];

Index IndexLot On (StockCheckDR, LotDR) [ SqlName = Index_Lot, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTOCKCHECKITEM On RowID [ PrimaryKey, SqlName = PK_RG_STOCKCHECKITEM, Type = index, Unique ];

ForeignKey FKRGStockCheckItemStockCheck(StockCheckDR) References dbo.RGStockCheck(PKRGSTOCKCHECK) [ SqlName = FK_RG_StockCheckItem_StockCheck ];

ForeignKey FKRGStockCheckItemLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_StockCheckItem_Lot ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StockCheckDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LotBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 5 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property SystemStock As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property ActualStock As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property DiffStock As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Price As %Library.Float [ SqlColumnNumber = 11 ];

Property ManuLotNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

Property ExpireDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property TotalPrice As %Library.Float [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RGStockCheckItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StockCheckDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>LotBarcode</Value>
</Value>
<Value name="5">
<Value>LotDR</Value>
</Value>
<Value name="6">
<Value>SystemStock</Value>
</Value>
<Value name="7">
<Value>ActualStock</Value>
</Value>
<Value name="8">
<Value>DiffStock</Value>
</Value>
<Value name="9">
<Value>SupplierDR</Value>
</Value>
<Value name="10">
<Value>Price</Value>
</Value>
<Value name="11">
<Value>ManuLotNo</Value>
</Value>
<Value name="12">
<Value>ExpireDate</Value>
</Value>
<Value name="13">
<Value>TotalPrice</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStockCheckItemD</DataLocation>
<DefaultData>RGStockCheckItemDefaultData</DefaultData>
<IdLocation>^dbo.RGStockCheckItemD</IdLocation>
<IndexLocation>^dbo.RGStockCheckItemI</IndexLocation>
<StreamLocation>^dbo.RGStockCheckItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
