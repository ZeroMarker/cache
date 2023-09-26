/// 血站血液产品
Class dbo.BBSupplierProduct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_SupplierProduct, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPSSupplier created via DDL
ForeignKey FKBBSPSupplier(SupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = FK_BB_SP_Supplier ];

Index IndexMaster On (SupplierDR, ProductCode) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (SupplierDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBSUPPLIERPRODUCT On RowID [ PrimaryKey, SqlName = PK_BB_SUPPLIER_PRODUCT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血站  
Property SupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 血液产品代码  
Property ProductCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 血液产品名称  
Property ProductName As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ Required, SqlColumnNumber = 5 ];

/// 计量单位  
Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// 对照码  
Property SupplierCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 7 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBSupplierProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupplierDR</Value>
</Value>
<Value name="3">
<Value>ProductCode</Value>
</Value>
<Value name="4">
<Value>ProductName</Value>
</Value>
<Value name="5">
<Value>Units</Value>
</Value>
<Value name="6">
<Value>SupplierCode</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSupplierProductD</DataLocation>
<DefaultData>BBSupplierProductDefaultData</DefaultData>
<IdLocation>^dbo.BBSupplierProductD</IdLocation>
<IndexLocation>^dbo.BBSupplierProductI</IndexLocation>
<StreamLocation>^dbo.BBSupplierProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
