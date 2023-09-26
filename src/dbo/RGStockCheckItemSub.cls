Class dbo.RGStockCheckItemSub Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StockCheckItemSub, StorageStrategy = Default ]
{

Index IndexMaster On (StockCheckItemDR, BoxBarcode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexType On (StockCheckItemDR, CheckType, BoxBarcode) [ SqlName = Index_Type, Type = index ];

Index IndexBoxBarcode On (BoxBarcode, StockCheckItemDR) [ SqlName = Index_BoxBarcode, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTOCKCHECKITEMSUB On RowID [ PrimaryKey, SqlName = PK_RG_STOCKCHECKITEMSUB, Type = index, Unique ];

ForeignKey FKRGStockCheckItemSubStockCheckItem(StockCheckItemDR) References dbo.RGStockCheckItem(PKRGSTOCKCHECKITEM) [ SqlName = FK_RG_StockCheckItemSub_StockCheckItem ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StockCheckItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BoxBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property CheckType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="RGStockCheckItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StockCheckItemDR</Value>
</Value>
<Value name="3">
<Value>BoxBarcode</Value>
</Value>
<Value name="4">
<Value>CheckType</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStockCheckItemSubD</DataLocation>
<DefaultData>RGStockCheckItemSubDefaultData</DefaultData>
<IdLocation>^dbo.RGStockCheckItemSubD</IdLocation>
<IndexLocation>^dbo.RGStockCheckItemSubI</IndexLocation>
<StreamLocation>^dbo.RGStockCheckItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
