/// 血袋入库单明细
Class dbo.BDPackInItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackInItems, StorageStrategy = Default ]
{

/// Foreign Key FKBDPIItemsPack created via DDL
ForeignKey FKBDPIItemsPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PIItems_Pack ];

/// Foreign Key FKBDPIItemsPackIn created via DDL
ForeignKey FKBDPIItemsPackIn(PackInDR) References dbo.BDPackIn(PKBDPACKIN) [ SqlName = FK_BD_PIItems_PackIn ];

Index IndexMaster On (PackInDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexOutStockNo On OutStockNo [ SqlName = Index_OutStockNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKINITEMS On RowID [ PrimaryKey, SqlName = PK_BD_PACKINITEMS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋入库单  
Property PackInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血袋  
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 血站出库单号  
Property OutStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDPackInItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackInDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>OutStockNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackInItemsD</DataLocation>
<DefaultData>BDPackInItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackInItemsD</IdLocation>
<IndexLocation>^dbo.BDPackInItemsI</IndexLocation>
<StreamLocation>^dbo.BDPackInItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
