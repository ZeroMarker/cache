Class dbo.BBBloodProductCategory Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductCategory, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPorductBComponets created via DDL
ForeignKey FKBBBPCBLDCategory(BloodCategoryDR) References dbo.BBBloodCategory(PKBBBLOODCATEGORY) [ SqlName = FK_BB_BPC_BLDCategory ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCTCATEGORY On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCTCATEGORY, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 所属品种类别  
Property BloodCategoryDR As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBBloodProductCategoryDefaultData">
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
<Value>Remark</Value>
</Value>
<Value name="5">
<Value>BloodCategoryDR</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductCategoryD</DataLocation>
<DefaultData>BBBloodProductCategoryDefaultData</DefaultData>
<IdLocation>^dbo.BBBloodProductCategoryD</IdLocation>
<IndexLocation>^dbo.BBBloodProductCategoryI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
