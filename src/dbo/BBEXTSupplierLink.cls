Class dbo.BBEXTSupplierLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_EXTSupplierLink, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPSBProduct created via DDL
ForeignKey FKBBBPSBProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_ESL_BProduct ];

/// Foreign Key FKBBBPSSupplier created via DDL
ForeignKey FKBBBPSSupplier(ToSupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BB_ESL_Supplier ];

Index IndexMaster On (FromSuppCode, FromBarCode, ToSupplierDR, ToBarCode) [ SqlName = Index_Master, Type = index ];

Index IndexBloodProduct On (FromSuppCode, FromBarCode, ToSupplierDR, BloodProductDR) [ SqlName = Index_BloodProduct, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCTSUPPLIER On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCTSUPPLIER, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 原始血站  
Property FromSuppCode As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 3 ];

/// 原始产品码  
Property FromBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 目标血站  
Property ToSupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 目标产品码  
Property ToBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 6 ];

/// 目标血产品   
Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 目标规格   
Property PackSize As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBEXTSupplierLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FromSuppCode</Value>
</Value>
<Value name="3">
<Value>FromBarCode</Value>
</Value>
<Value name="4">
<Value>ToSupplierDR</Value>
</Value>
<Value name="5">
<Value>ToBarCode</Value>
</Value>
<Value name="6">
<Value>BloodProductDR</Value>
</Value>
<Value name="7">
<Value>PackSize</Value>
</Value>
</Data>
<DataLocation>^dbo.BBEXTSupplierLinkD</DataLocation>
<DefaultData>BBEXTSupplierLinkDefaultData</DefaultData>
<IdLocation>^dbo.BBEXTSupplierLinkD</IdLocation>
<IndexLocation>^dbo.BBEXTSupplierLinkI</IndexLocation>
<StreamLocation>^dbo.BBEXTSupplierLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
