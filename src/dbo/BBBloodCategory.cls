Class dbo.BBBloodCategory Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodCategory, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPorductBComponets created via DDL
ForeignKey FKBBBCategoryBComponets(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BB_BCategory_BComponets ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODCATEGORY On RowID [ PrimaryKey, SqlName = PK_BB_BLOODCATEGORY, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

/// 所属产品大类  
Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBBloodCategoryDefaultData">
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
<Value>BloodComponentsDR</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodCategoryD</DataLocation>
<DefaultData>BBBloodCategoryDefaultData</DefaultData>
<IdLocation>^dbo.BBBloodCategoryD</IdLocation>
<IndexLocation>^dbo.BBBloodCategoryI</IndexLocation>
<StreamLocation>^dbo.BBBloodCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
