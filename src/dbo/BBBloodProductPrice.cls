///     
Class dbo.BBBloodProductPrice Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductPrice, StorageStrategy = Default ]
{

/// Foreign Key FKProductPriceBloodProduct created via DDL
ForeignKey FKProductPriceBloodProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_ProductPrice_BloodProduct ];

/// Foreign Key FKProductPriceSupplier created via DDL
ForeignKey FKProductPriceSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_ProductPrice_Supplier ];

Index IndexMaster On (BloodProductDR, SupplierDR, RH) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBBloodProductPrice On RowID [ PrimaryKey, SqlName = PK_BB_BloodProductPrice, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property RH As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 5 ];

Property InPrice As %Library.Float [ SqlColumnNumber = 6 ];

Property ExtraFee As %Library.Float [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBBloodProductPriceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>BloodProductDR</Value>
</Value>
<Value name="4">
<Value>SupplierDR</Value>
</Value>
<Value name="5">
<Value>RH</Value>
</Value>
<Value name="6">
<Value>InPrice</Value>
</Value>
<Value name="7">
<Value>ExtraFee</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductPriceD</DataLocation>
<DefaultData>BBBloodProductPriceDefaultData</DefaultData>
<IdLocation>^dbo.BBBloodProductPriceD</IdLocation>
<IndexLocation>^dbo.BBBloodProductPriceI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductPriceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
