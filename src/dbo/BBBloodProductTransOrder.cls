///     
Class dbo.BBBloodProductTransOrder Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductTransOrder ]
{

/// Foreign Key FKBBBloodProductTransOrderBloodProductDR created via DDL
ForeignKey FKBBBloodProductTransOrderBloodProductDR(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BBBloodProductTransOrderBloodProductDR ];

/// Foreign Key FKBBBloodProductTransOrderCostItemDR created via DDL
ForeignKey FKBBBloodProductTransOrderCostItemDR(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BBBloodProductTransOrderCostItemDR ];

/// Foreign Key FKBBBloodProductTransOrderBloodGroupDR created via DDL
ForeignKey FKBBBloodProductTransOrderBloodGroupDR(BloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BBBloodProductTransOrderBloodGroupDR ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCTTRANSORDER On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCTTRANSORDER, Type = index, Unique ];

Index IndexBloodGroup On (BloodProductDR, BloodGroupDR, CostItemDR) [ SqlName = Index_BloodGroup, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBBloodProductTransOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodProductDR</Value>
</Value>
<Value name="3">
<Value>CostItemDR</Value>
</Value>
<Value name="4">
<Value>BloodGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductTransOrderD</DataLocation>
<DefaultData>BBBloodProductTransOrderDefaultData</DefaultData>
<IdLocation>^dbo.BBBloodProductTransOrderD</IdLocation>
<IndexLocation>^dbo.BBBloodProductTransOrderI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductTransOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
