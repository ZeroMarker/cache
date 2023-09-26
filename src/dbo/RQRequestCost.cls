/// 申请费用
Class dbo.RQRequestCost Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_RequestCost, StorageStrategy = Default ]
{

/// Foreign Key FKRequestCostItem created via DDL
ForeignKey FKRequestCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_RequestCostItem ];

/// Foreign Key FKRequestCostReq created via DDL
ForeignKey FKRequestCostReq(RequestDR) References dbo.RQRequest(PKRQREQUEST) [ SqlName = FK_RequestCostReq ];

/// Foreign Key FKRequestCostTs created via DDL
ForeignKey FKRequestCostTs(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_RequestCostTs ];

Index IndexCostItem On (RequestDR, CostItemDR) [ SqlName = Index_CostItem, Type = index ];

Index IndexMaster On (RequestDR, ItemType, ItemCode, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (RequestDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexTestSet On (RequestDR, TestSetDR) [ SqlName = Index_TestSet, Type = index ];

/// DDL Primary Key Specification
Index PKRQREQUESTCOST On RowID [ PrimaryKey, SqlName = PK_RQ_REQUESTCOST, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单  
Property RequestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目类型  {1:true,0:false}
Property ItemType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// 项目代码  
Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// 收费项目  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 数量  
Property Quantity As %Library.Float [ SqlColumnNumber = 7 ];

/// 实收金额  
Property ItemFee As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 8 ];

/// 单价  
Property Price As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 9 ];

/// 折扣率  
Property Discount As %Library.Float [ SqlColumnNumber = 10 ];

/// 发票号  
Property InvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 状态  {1:登记,2:执行,3:取消,O:其他}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 12 ];

/// 项目组合套  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RQRequestCostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestDR</Value>
</Value>
<Value name="3">
<Value>ItemType</Value>
</Value>
<Value name="4">
<Value>ItemCode</Value>
</Value>
<Value name="5">
<Value>CostItemDR</Value>
</Value>
<Value name="6">
<Value>Quantity</Value>
</Value>
<Value name="7">
<Value>ItemFee</Value>
</Value>
<Value name="8">
<Value>Price</Value>
</Value>
<Value name="9">
<Value>Discount</Value>
</Value>
<Value name="10">
<Value>InvoiceNo</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>TestSetDR</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RQRequestCostD</DataLocation>
<DefaultData>RQRequestCostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQRequestCostD</IdLocation>
<IndexLocation>^dbo.RQRequestCostI</IndexLocation>
<StreamLocation>^dbo.RQRequestCostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
