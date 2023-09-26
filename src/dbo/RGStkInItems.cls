///     
Class dbo.RGStkInItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_StkInItems, StorageStrategy = Default ]
{

Index IndexMaster On (StkInDR, LotDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRGSTKINITEMS On RowID [ PrimaryKey, SqlName = PK_RG_STKINITEMS, Type = index, Unique ];

/// Foreign Key FKRGItemsStkIn created via DDL
ForeignKey FKRGItemsStkIn(StkInDR) References dbo.RGStkIn(PKRGSTKIN) [ SqlName = FK_RG_Items_StkIn ];

/// Foreign Key FKRGStkInItemsLot created via DDL
ForeignKey FKRGStkInItemsLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_StkInItems_Lot ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Quantity As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property TotalPrice As %Library.Float [ SqlColumnNumber = 6 ];

Property Removed As %Library.Boolean [ SqlColumnNumber = 7 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RGStkInItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkInDR</Value>
</Value>
<Value name="3">
<Value>LotDR</Value>
</Value>
<Value name="4">
<Value>Quantity</Value>
</Value>
<Value name="5">
<Value>TotalPrice</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>Removed</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStkInItemsD</DataLocation>
<DefaultData>RGStkInItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStkInItemsD</IdLocation>
<IndexLocation>^dbo.RGStkInItemsI</IndexLocation>
<StreamLocation>^dbo.RGStkInItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
