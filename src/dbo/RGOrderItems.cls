/// 采购订单明细
Class dbo.RGOrderItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_OrderItems, StorageStrategy = Default ]
{

Index IndexMaster On (OrderDR, ReagentDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRGORDERITEMS On RowID [ PrimaryKey, SqlName = PK_RG_ORDERITEMS, Type = index, Unique ];

/// Foreign Key FKRGOrderItemsOrder created via DDL
ForeignKey FKRGOrderItemsOrder(OrderDR) References dbo.RGOrder(PKRGORDER) [ SqlName = FK_RG_OrderItems_Order ];

/// Foreign Key FKRGOrderItemsReagent created via DDL
ForeignKey FKRGOrderItemsReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_OrderItems_Reagent ];

/// ID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 订单号  
Property OrderDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 试剂  
Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 数量  
Property Quantity As %Library.Float [ Required, SqlColumnNumber = 5 ];

///       
Property InQty As %Library.Float [ SqlColumnNumber = 6 ];

///       
Property ManuLotNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

Property Price As %Library.Double [ SqlColumnNumber = 8 ];

Property TotalPrice As %Library.Double [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RGOrderItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>Quantity</Value>
</Value>
<Value name="5">
<Value>InQty</Value>
</Value>
<Value name="6">
<Value>ManuLotNo</Value>
</Value>
<Value name="7">
<Value>Price</Value>
</Value>
<Value name="8">
<Value>TotalPrice</Value>
</Value>
</Data>
<DataLocation>^dbo.RGOrderItemsD</DataLocation>
<DefaultData>RGOrderItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGOrderItemsD</IdLocation>
<IndexLocation>^dbo.RGOrderItemsI</IndexLocation>
<StreamLocation>^dbo.RGOrderItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
