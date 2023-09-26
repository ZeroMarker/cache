Class dbo.BBTreatPurPoseCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_TreatPurPoseCostItem, StorageStrategy = Default ]
{

Index IndexMaster On (TreatPurposeDR, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBBTRREQPurpose(TreatPurposeDR) References dbo.BBTreatPurpose(PKBBTRPURPOSE) [ SqlName = FK_BB_TRREQPurpose ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBBTRREQCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_TRREQ_CostItem ];

/// DDL Primary Key Specification
Index PKBBTREATREQCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BB_TREATREQCOSTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TreatPurposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ItemNum As %Library.Float [ SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBTreatPurPoseCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PurPoseDR</Value>
</Value>
<Value name="3">
<Value>CostItemDR</Value>
</Value>
<Value name="4">
<Value>ItemNum</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>TreatPurposeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBTreatPurPoseCostItemD</DataLocation>
<DefaultData>BBTreatPurPoseCostItemDefaultData</DefaultData>
<IdLocation>^dbo.BBTreatPurPoseCostItemD</IdLocation>
<IndexLocation>^dbo.BBTreatPurPoseCostItemI</IndexLocation>
<StreamLocation>^dbo.BBTreatPurPoseCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
