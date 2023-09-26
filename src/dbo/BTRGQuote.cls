///     
Class dbo.BTRGQuote Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Quote, StorageStrategy = Default ]
{

/// Foreign Key FKRGQuoteReagent created via DDL
ForeignKey FKRGQuoteReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_Quote_Reagent ];

/// Foreign Key FKRGQuoteSupplier created via DDL
ForeignKey FKRGQuoteSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_Quote_Supplier ];

Index IndexMaster On (ReagentDR, SupplierDR, StartDate) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequece On Sequence [ SqlName = Index_Sequece, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGQUOTE On RowID [ PrimaryKey, SqlName = PK_BTRG_QUOTE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Price As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ManuLotNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

Property ProductDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ExpireDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 10 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BTRGQuoteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>Price</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>ManuLotNo</Value>
</Value>
<Value name="7">
<Value>ProductDate</Value>
</Value>
<Value name="8">
<Value>ExpireDate</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGQuoteD</DataLocation>
<DefaultData>BTRGQuoteDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGQuoteD</IdLocation>
<IndexLocation>^dbo.BTRGQuoteI</IndexLocation>
<StreamLocation>^dbo.BTRGQuoteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
