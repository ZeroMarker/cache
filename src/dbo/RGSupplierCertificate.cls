Class dbo.RGSupplierCertificate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_SupplierCertificate, StorageStrategy = Default ]
{

Index IndexType On (SupplierDR, ReagentDR, CertificateType, FilePathDR) [ SqlName = Index_Type, Type = index ];

Index PKRGSUPPLIERCERTIFICATE On RowID [ PrimaryKey, SqlName = PK_RG_SUPPLIERCERTIFICATE, Type = index, Unique ];

ForeignKey FKRGCertificateSupplier(SupplierDR) References dbo.BTRGSupplier(PKBTRGSUPPLIER) [ SqlName = FK_RG_Certificate_Supplier ];

ForeignKey FKRGCertificateReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_Certificate_Reagent ];

ForeignKey FKRGCertificateFilePath(FilePathDR) References dbo.RGFilePath(PKRGFILEPATH) [ SqlName = FK_RG_Certificate_FilePath ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property CertificateType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property FilePathDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property ExpireDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property CertiNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RGSupplierCertificateDefaultData">
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
<Value>CertificateType</Value>
</Value>
<Value name="5">
<Value>FilePathDR</Value>
</Value>
<Value name="6">
<Value>StartDate</Value>
</Value>
<Value name="7">
<Value>ExpireDate</Value>
</Value>
<Value name="8">
<Value>CertiNo</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RGSupplierCertificateD</DataLocation>
<DefaultData>RGSupplierCertificateDefaultData</DefaultData>
<IdLocation>^dbo.RGSupplierCertificateD</IdLocation>
<IndexLocation>^dbo.RGSupplierCertificateI</IndexLocation>
<StreamLocation>^dbo.RGSupplierCertificateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
