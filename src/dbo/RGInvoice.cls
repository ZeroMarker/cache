///     
Class dbo.RGInvoice Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_Invoice, StorageStrategy = Default ]
{

/// Foreign Key FKRGInvoiceStkIn created via DDL
ForeignKey FKRGInvoiceStkIn(StkInDR) References dbo.RGStkIn(PKRGSTKIN) [ SqlName = FK_RG_Invoice_StkIn ];

Index IndexInvoiceNo On InvoiceNo [ SqlName = Index_InvoiceNo, Type = index ];

Index IndexStkInDR On StkInDR [ SqlName = Index_StkInDR, Type = index ];

Index IndexInvoiceDate On InvoiceDate [ SqlName = Index_InvoiceDate, Type = index ];

/// DDL Primary Key Specification
Index PKRGINVOICE On RowID [ PrimaryKey, SqlName = PK_RG_INVOICE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StkInDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property InvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property InvoiceDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property InvoiceAmount As %Library.Float [ Required, SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="RGInvoiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StkInDR</Value>
</Value>
<Value name="3">
<Value>InvoiceNo</Value>
</Value>
<Value name="4">
<Value>InvoiceDate</Value>
</Value>
<Value name="5">
<Value>InvoiceAmount</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.RGInvoiceD</DataLocation>
<DefaultData>RGInvoiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGInvoiceD</IdLocation>
<IndexLocation>^dbo.RGInvoiceI</IndexLocation>
<StreamLocation>^dbo.RGInvoiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
