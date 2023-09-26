Class dbo.BBSupplierData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_SupplierData ]
{

ForeignKey FKBBSDSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BB_SD_Supplier ];

Index IndexMaster On (SupplierDR, DataType, DataCode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

Index IndexSuppCode On (SupplierDR, DataType, SuppCode) [ SqlName = Index_SuppCode, Type = index ];

/// DDL Primary Key Specification
Index PKBBSUPPLIERDATA On RowID [ PrimaryKey, SqlName = PK_BB_SUPPLIERDATA, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property DataCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property SuppCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBSupplierDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierDR</Value>
</Value>
<Value name="3">
<Value>DataType</Value>
</Value>
<Value name="4">
<Value>DataCode</Value>
</Value>
<Value name="5">
<Value>SuppCode</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSupplierDataD</DataLocation>
<DefaultData>BBSupplierDataDefaultData</DefaultData>
<IdLocation>^dbo.BBSupplierDataD</IdLocation>
<IndexLocation>^dbo.BBSupplierDataI</IndexLocation>
<StreamLocation>^dbo.BBSupplierDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
