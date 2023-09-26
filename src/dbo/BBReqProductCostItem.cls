///     
Class dbo.BBReqProductCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqProductCostItem, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPCICostItem created via DDL
ForeignKey FKBBRPCICostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_RPCI_CostItem ];

/// Foreign Key FKBBRPCICostItem created via DDL
ForeignKey FKBBTRCICostItem(TakeRecordCostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_TRCI_CostItem ];

/// Foreign Key FKBBRPCIReqProduct created via DDL
ForeignKey FKBBRPCIReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_RPCI_ReqProduct ];

ForeignKey FKBBCOLLCostItem(CollectCostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_COLL_CostItem ];

Index IndexMaster On (ReqProductDR, ReqBloodGroupDR, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBDRFPBloodGroup(ReqBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_RFP_BloodGroup ];

/// DDL Primary Key Specification
Index PKBBREQPRODUCTCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BB_REQPRODUCTCOSTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property BillType As %Library.SmallInt [ Required, SqlColumnNumber = 5 ];

Property ItemNum As %Library.Float [ SqlColumnNumber = 6 ];

Property ScaleFactor As %Library.Float [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Property ReqBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property Hours As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property TakeRecordCostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property NewSpecTime As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

Property CollectCostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BBReqProductCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqProductDR</Value>
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
<Value name="9">
<Value>ReqBloodGroupDR</Value>
</Value>
<Value name="10">
<Value>Hours</Value>
</Value>
<Value name="11">
<Value>TakeRecordCostItemDR</Value>
</Value>
<Value name="12">
<Value>NewSpecTime</Value>
</Value>
<Value name="13">
<Value>CollectCostItemDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqProductCostItemD</DataLocation>
<DefaultData>BBReqProductCostItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReqProductCostItemD</IdLocation>
<IndexLocation>^dbo.BBReqProductCostItemI</IndexLocation>
<StreamLocation>^dbo.BBReqProductCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
