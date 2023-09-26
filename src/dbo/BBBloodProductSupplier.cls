///     
Class dbo.BBBloodProductSupplier Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductSupplier, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPSBProduct created via DDL
ForeignKey FKBBBPSBProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_BPS_BProduct ];

/// Foreign Key FKBBBPSSupplier created via DDL
ForeignKey FKBBBPSSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BB_BPS_Supplier ];

Index IndexBarCode On (SupplierDR, BarCode) [ SqlName = Index_BarCode, Type = index ];

Index IndexMaster On (BloodProductDR, SupplierDR) [ SqlName = Index_Master, Type = index ];

Index IndexSupplier On (SupplierDR, BloodProductDR) [ SqlName = Index_Supplier, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCTSUPPLIER On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCTSUPPLIER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BarCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property InPrice As %Library.Float [ SqlColumnNumber = 6 ];

Property PackVolume As %Library.Float [ SqlColumnNumber = 7 ];

Property SpecialChar As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property Positions As %Library.String(COLLATION = "Exact", MAXLEN = 11) [ SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BBBloodProductSupplierDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodProductDR</Value>
</Value>
<Value name="3">
<Value>SupplierDR</Value>
</Value>
<Value name="4">
<Value>BarCode</Value>
</Value>
<Value name="5">
<Value>InPrice</Value>
</Value>
<Value name="6">
<Value>PackVolume</Value>
</Value>
<Value name="7">
<Value>SpecialChar</Value>
</Value>
<Value name="8">
<Value>Positions</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductSupplierD</DataLocation>
<DefaultData>BBBloodProductSupplierDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodProductSupplierD</IdLocation>
<IndexLocation>^dbo.BBBloodProductSupplierI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductSupplierS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
