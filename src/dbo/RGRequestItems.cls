///     
Class dbo.RGRequestItems Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_RequestItems, StorageStrategy = Default ]
{

Index IndexMaster On (RequestTaskDR, ReagentDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReagent On ReagentDR [ SqlName = Index_Reagent, Type = index ];

Index IndexRequestTask On RequestTaskDR [ SqlName = Index_RequestTask, Type = index ];

/// DDL Primary Key Specification
Index PKRGREQUESTITEMS On RowID [ PrimaryKey, SqlName = PK_RG_REQUESTITEMS, Type = index, Unique ];

/// Foreign Key FKRGRequestItemReagent created via DDL
ForeignKey FKRGRequestItemReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_RequestItem_Reagent ];

/// Foreign Key FKRGRequestItemRequest created via DDL
ForeignKey FKRGRequestItemRequest(RequestTaskDR) References dbo.RGRequestTask(PKRGREQUESTTASK) [ SqlName = FK_RG_RequestItem_Request ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RequestTaskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property RequestQty As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property ActualQty As %Library.Float [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RGRequestItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestTaskDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>RequestQty</Value>
</Value>
<Value name="5">
<Value>ActualQty</Value>
</Value>
</Data>
<DataLocation>^dbo.RGRequestItemsD</DataLocation>
<DefaultData>RGRequestItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGRequestItemsD</IdLocation>
<IndexLocation>^dbo.RGRequestItemsI</IndexLocation>
<StreamLocation>^dbo.RGRequestItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
