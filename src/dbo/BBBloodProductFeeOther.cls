///     
Class dbo.BBBloodProductFeeOther Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodProductFeeOther, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPFOBProduct created via DDL
ForeignKey FKBBBPFOBProduct(BloodProductDR) References dbo.BBBloodProduct(PKBBBLOODPRODUCT) [ SqlName = FK_BB_BPFO_BProduct ];

/// Foreign Key FKBBBPFOCostItem created via DDL
ForeignKey FKBBBPFOCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_BPFO_CostItem ];

Index IndexMaster On (BloodProductDR, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBBLOODPRODUCTFEEOTHER On RowID [ PrimaryKey, SqlName = PK_BB_BLOODPRODUCTFEEOTHER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BloodProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BillType As %Library.SmallInt [ Required, SqlColumnNumber = 5 ];

Property ItemNum As %Library.Float [ SqlColumnNumber = 6 ];

Property ScaleFactor As %Library.Float [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBBloodProductFeeOtherDefaultData">
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
<Value>BillType</Value>
</Value>
<Value name="5">
<Value>ItemNum</Value>
</Value>
<Value name="6">
<Value>ScaleFactor</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodProductFeeOtherD</DataLocation>
<DefaultData>BBBloodProductFeeOtherDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodProductFeeOtherD</IdLocation>
<IndexLocation>^dbo.BBBloodProductFeeOtherI</IndexLocation>
<StreamLocation>^dbo.BBBloodProductFeeOtherS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
