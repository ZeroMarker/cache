Class dbo.BBTakeComponetCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_TakeComponetCostItem, StorageStrategy = Default ]
{

/// Foreign Key FKBBRPCICostItem created via DDL
ForeignKey FKBBRPCICostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BB_RPCI_CostItem ];

/// Foreign Key FKBDTRComComponents created via DDL
ForeignKey FKBDTRComComponents(BloodComponentsDR) References dbo.BBBloodComponents(PKBBBLOODCOMPONENTS) [ SqlName = FK_BD_TRCom_Components ];

Index IndexMaster On (ReqBloodGroupDR, BloodComponentsDR, CostItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBDRFPBloodGroup created via DDL
ForeignKey FKBDRFPBloodGroup(ReqBloodGroupDR) References dbo.BBBloodGroup(PKBBBLOODGROUP) [ SqlName = FK_BD_RFP_BloodGroup ];

/// DDL Primary Key Specification
Index PKBBREQPRODUCTCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BB_REQPRODUCTCOSTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqBloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property BloodComponentsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property BillType As %Library.SmallInt [ Required, SqlColumnNumber = 6 ];

Property ItemNum As %Library.Float [ SqlColumnNumber = 7 ];

Property ScaleFactor As %Library.Float [ SqlColumnNumber = 8 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Property Hours As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BBTakeComponetCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqBloodGroupDR</Value>
</Value>
<Value name="3">
<Value>BloodComponentsDR</Value>
</Value>
<Value name="4">
<Value>CostItemDR</Value>
</Value>
<Value name="5">
<Value>BillType</Value>
</Value>
<Value name="6">
<Value>ItemNum</Value>
</Value>
<Value name="7">
<Value>ScaleFactor</Value>
</Value>
<Value name="8">
<Value>SeqNum</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>Hours</Value>
</Value>
</Data>
<DataLocation>^dbo.BBTakeComponetCostItemD</DataLocation>
<DefaultData>BBTakeComponetCostItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBTakeComponetCostItemD</IdLocation>
<IndexLocation>^dbo.BBTakeComponetCostItemI</IndexLocation>
<StreamLocation>^dbo.BBTakeComponetCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
