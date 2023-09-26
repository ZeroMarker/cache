/// 血站血液产品规格
Class dbo.BBSupplierProductSize Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_SupplierProductSize, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPSSupplier created via DDL
ForeignKey FKBBSPSSupplier(SupplierProductDR) References dbo.BBSupplierProduct(PKBBSUPPLIERPRODUCT) [ SqlName = FK_BB_SPS_Supplier ];

Index IndexMaster On (SupplierProductDR, PackageSize) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (SupplierProductDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODCLASS On RowID [ PrimaryKey, SqlName = PK_BB_BLOODCLASS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血站血液产品  
Property SupplierProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 规格  
Property PackageSize As %Library.Float [ Required, SqlColumnNumber = 4 ];

/// 对照码  
Property SupplierCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBSupplierProductSizeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierProductDR</Value>
</Value>
<Value name="3">
<Value>PackageSize</Value>
</Value>
<Value name="4">
<Value>SupplierCode</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSupplierProductSizeD</DataLocation>
<DefaultData>BBSupplierProductSizeDefaultData</DefaultData>
<IdLocation>^dbo.BBSupplierProductSizeD</IdLocation>
<IndexLocation>^dbo.BBSupplierProductSizeI</IndexLocation>
<StreamLocation>^dbo.BBSupplierProductSizeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
