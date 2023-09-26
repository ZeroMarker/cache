///     
Class dbo.BTRGSupplierItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_SupplierItems, StorageStrategy = Default ]
{

Index IndexExpireDate On ExpireDate [ SqlName = Index_ExpireDate, Type = index ];

Index IndexStartDate On StartDate [ SqlName = Index_StartDate, Type = index ];

Index IndexSupplier On SupplierDR [ SqlName = Index_Supplier, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGSUPPLIERITEMS On RowID [ PrimaryKey, SqlName = PK_BTRG_SUPPLIERITEMS, Type = index, Unique ];

/// Foreign Key FKRGSupplierDR created via DDL
ForeignKey FKRGSupplierDR(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_SupplierDR ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ExpireDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Business As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 6 ];

Property License As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 7 ];

Property Authorize As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 8 ];

Property IDCardFromt As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 9 ];

Property IDCardBack As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTRGSupplierItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierDR</Value>
</Value>
<Value name="3">
<Value>ExpireDate</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>Business</Value>
</Value>
<Value name="6">
<Value>License</Value>
</Value>
<Value name="7">
<Value>Authorize</Value>
</Value>
<Value name="8">
<Value>IDCardFromt</Value>
</Value>
<Value name="9">
<Value>IDCardBack</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGSupplierItemsD</DataLocation>
<DefaultData>BTRGSupplierItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGSupplierItemsD</IdLocation>
<IndexLocation>^dbo.BTRGSupplierItemsI</IndexLocation>
<StreamLocation>^dbo.BTRGSupplierItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
