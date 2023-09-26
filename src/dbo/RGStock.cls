///     
Class dbo.RGStock Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_Stock, StorageStrategy = Default ]
{

Index IndexInDate On InDate [ SqlName = Index_InDate, Type = index ];

Index IndexMaster On (ReagentGroupDR, LotDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSumQty On SumQty [ SqlName = Index_SumQty, Type = index ];

/// DDL Primary Key Specification
Index PKRGSTOCK On RowID [ PrimaryKey, SqlName = PK_RG_STOCK, Type = index, Unique ];

/// Foreign Key FKRGStockGroup created via DDL
ForeignKey FKRGStockGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Stock_Group ];

/// Foreign Key FKRGStockLot created via DDL
ForeignKey FKRGStockLot(LotDR) References dbo.RGLot(PKRGLOT) [ SqlName = FK_RG_Stock_Lot ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property LotDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property InDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property InQty As %Library.Float [ Required, SqlColumnNumber = 6 ];

Property OutQty As %Library.Float [ Required, SqlColumnNumber = 7 ];

Property SumQty As %Library.Float [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RGStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LotDR</Value>
</Value>
<Value name="3">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="4">
<Value>InDate</Value>
</Value>
<Value name="5">
<Value>InQty</Value>
</Value>
<Value name="6">
<Value>OutQty</Value>
</Value>
<Value name="7">
<Value>SumQty</Value>
</Value>
</Data>
<DataLocation>^dbo.RGStockD</DataLocation>
<DefaultData>RGStockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGStockD</IdLocation>
<IndexLocation>^dbo.RGStockI</IndexLocation>
<StreamLocation>^dbo.RGStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
