///     
Class dbo.BBBloodProductQuality Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductQuality, StorageStrategy = Default ]
{

/// Foreign Key FKBBBCQBProduct created via DDL
ForeignKey FKBBBCQBProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_BCQ_BProduct ];

/// Foreign Key FKBBBCQQualityItem created via DDL
ForeignKey FKBBBCQQualityItem(QualityItemDR) References dbo.BBQualityItem(PKBBQUALITYITEM) [ SqlName = FK_BB_BCQ_QualityItem ];

Index IndexMaster On (BloodProductDR, QualityItemDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCTQUALITY On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCTQUALITY, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property QualityItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBBloodProductQualityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodProductDR</Value>
</Value>
<Value name="3">
<Value>QualityItemDR</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductQualityD</DataLocation>
<DefaultData>BBBloodProductQualityDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodProductQualityD</IdLocation>
<IndexLocation>^dbo.BBBloodProductQualityI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductQualityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
