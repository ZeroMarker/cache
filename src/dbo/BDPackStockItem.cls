Class dbo.BDPackStockItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackStockItem ]
{

ForeignKey FKBDStItemPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_StItem_Pack ];

ForeignKey FKBDPackStcok(PackStockDR) References dbo.BDPackStock(PKPACKSTOCK) [ SqlName = FK_BD_PackStcok ];

ForeignKey FKBDPackStcokCount(PackStockCountDR) References dbo.BDPackStockCount(PKPACKSTOCKCOUNT) [ SqlName = FK_BD_PackStcokCount ];

Index IndexMaster On (PackDR, PackStockDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPackStock On (PackStockDR, PackDR) [ SqlName = Index_PackStock, Type = index ];

Index IndexPackCount On (PackStockCountDR, PackDR) [ SqlName = Index_PackCount, Type = index ];

Index IndexPackMaster On (PackStockDR, PackStockCountDR, PackDR) [ SqlName = Index_PackMaster, Type = index ];

Index PKPACKSTOCKITEM On RowID [ PrimaryKey, SqlName = PK_BD_PACKSTOCKITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackStockDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PackStockCountDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property IsPackStock As %Library.Boolean [ SqlColumnNumber = 6 ];

Property StockDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property StockTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 标记是否是盘库出库
Property IsPackStockOut As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDPackStockItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>PackStockDR</Value>
</Value>
<Value name="4">
<Value>PackStockCountDR</Value>
</Value>
<Value name="5">
<Value>IsPackStock</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>StockDate</Value>
</Value>
<Value name="9">
<Value>StockTime</Value>
</Value>
<Value name="10">
<Value>IsPackStockOut</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackStockItemD</DataLocation>
<DefaultData>BDPackStockItemDefaultData</DefaultData>
<IdLocation>^dbo.BDPackStockItemD</IdLocation>
<IndexLocation>^dbo.BDPackStockItemI</IndexLocation>
<StreamLocation>^dbo.BDPackStockItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
