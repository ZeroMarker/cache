///     
Class dbo.BBBloodProductFee Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductFee, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPFBProduct created via DDL
ForeignKey FKBBBPFBProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_BPF_BProduct ];

/// Foreign Key FKBBBPFCostItem created via DDL
ForeignKey FKBBBPFCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_BPF_CostItem ];

/// Foreign Key FKBBBPFSupplier created via DDL
ForeignKey FKBBBPFSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BB_BPF_Supplier ];

Index IndexMaster On (BloodProductDR, SupplierDR, RH, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSupplier On (SupplierDR, BloodProductDR) [ SqlName = Index_Supplier, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCTFEE On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCTFEE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property RH As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 5 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ItemNum As %Library.Float [ SqlColumnNumber = 7 ];

Property ScaleFactor As %Library.Float [ SqlColumnNumber = 8 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 9 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BBBloodProductFeeDefaultData">
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
<Value>RH</Value>
</Value>
<Value name="5">
<Value>CostItemDR</Value>
</Value>
<Value name="6">
<Value>ItemNum</Value>
</Value>
<Value name="7">
<Value>ScaleFactor</Value>
</Value>
<Value name="8">
<Value>IsDefault</Value>
</Value>
<Value name="9">
<Value>SeqNum</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductFeeD</DataLocation>
<DefaultData>BBBloodProductFeeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodProductFeeD</IdLocation>
<IndexLocation>^dbo.BBBloodProductFeeI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
