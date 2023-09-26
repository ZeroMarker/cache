/// 血站
Class dbo.BBSupplier Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_Supplier, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexPackMark On PackMark [ SqlName = Index_PackMark, Type = index ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBSUPPLIER On RowID [ PrimaryKey, SqlName = PK_BB_SUPPLIER, Type = index, Unique ];

/// Foreign Key FKBBRTestItemHospital created via DDL
ForeignKey FKBBSupplierSupplier(LinkSupplierDR) References dbo.BBSupplier(PKBBSUPPLIER) [ SqlName = PK_BB_SU_PPLIER ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 简称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 全称  
Property FullDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 机构代码  
Property InstitutionNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 7 ];

/// 联系电话  
Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 血袋条码标识  
Property PackMark As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 10 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 血袋条码长度  
Property PackIdLength As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 关联血站
Property LinkSupplierDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BBSupplierDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>FullDesc</Value>
</Value>
<Value name="5">
<Value>InstitutionNo</Value>
</Value>
<Value name="6">
<Value>Address</Value>
</Value>
<Value name="7">
<Value>Telephone</Value>
</Value>
<Value name="8">
<Value>PackMark</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>SeqNum</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>PackIdLength</Value>
</Value>
<Value name="13">
<Value>LinkSupplierDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSupplierD</DataLocation>
<DefaultData>BBSupplierDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBSupplierD</IdLocation>
<IndexLocation>^dbo.BBSupplierI</IndexLocation>
<StreamLocation>^dbo.BBSupplierS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
