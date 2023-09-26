Class dbo.RGOrderPlanItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_OrderPlanItems, StorageStrategy = Default ]
{

Index IndexMaster On (OrderPlanDR, ReagentDR) [ SqlName = Index_Master, Type = index, Unique ];

Index PKRGORDERPLANITEMS On RowID [ PrimaryKey, SqlName = PK_RG_ORDERPLANITEMS, Type = index, Unique ];

ForeignKey FKRGOrderPlanItemsGroup(OrderPlanDR) References dbo.RGOrderPlan(PKRGORDERPLAN) [ SqlName = FK_RG_OrderPlanItems_Group ];

ForeignKey FKRGOrderPlanItemsReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_OrderPlanItems_Reagent ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrderPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Quantity As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property ApprovedQty As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Approved As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="RGOrderPlanItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderPlanDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>Quantity</Value>
</Value>
<Value name="5">
<Value>ApprovedQty</Value>
</Value>
<Value name="6">
<Value>Approved</Value>
</Value>
</Data>
<DataLocation>^dbo.RGOrderPlanItemsD</DataLocation>
<DefaultData>RGOrderPlanItemsDefaultData</DefaultData>
<IdLocation>^dbo.RGOrderPlanItemsD</IdLocation>
<IndexLocation>^dbo.RGOrderPlanItemsI</IndexLocation>
<StreamLocation>^dbo.RGOrderPlanItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
