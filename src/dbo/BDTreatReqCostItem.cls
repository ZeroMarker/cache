Class dbo.BDTreatReqCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TreatReqCostItem, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFCostIAddUser created via DDL
ForeignKey FKBDTRRFCostIAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRRFCostI_AddUser ];

/// Foreign Key FKBDRFCostICancelUser created via DDL
ForeignKey FKBDTRRFCostICancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRRFCostI_CancelUser ];

/// Foreign Key FKBDRFCostICostItem created via DDL
ForeignKey FKBDTRRFCostICostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BD_TRRFCostI_CostItem ];

/// Foreign Key FKBDRFCostIExecUser created via DDL
ForeignKey FKBDTRRFCostIExecUser(ExecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_TRRFCostI_ExecUser ];

/// Foreign Key FKBDRFCostIReqForm created via DDL
ForeignKey FKBDTRRFCostIReqForm(TreatReqDR) References dbo.BDTreatReqForm(PKBDTRREQFORM) [ SqlName = FK_BD_TRRFCostI_ReqForm ];

ForeignKey FKBDTRRICOSTTRPurpose(TreatPurposeDR) References dbo.BBTreatPurpose(PKBBTRPURPOSE) [ SqlName = FK_BD_TRRICOSTTR_Purpose ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexExecDate On ExecDate [ SqlName = Index_ExecDate, Type = index ];

Index IndexHISOrderID On HISOrderID [ SqlName = Index_HISOrderID, Type = index ];

Index IndexTRReqForm On TreatReqDR [ SqlName = Index_TRReqForm, Type = index ];

/// DDL Primary Key Specification
Index PKBDREQFORMCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BD_TRREQFORMCOSTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TreatReqDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TreatPurposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Price As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ Required, SqlColumnNumber = 6 ];

Property Quantity As %Library.Float [ Required, SqlColumnNumber = 7 ];

Property PayAmount As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ Required, SqlColumnNumber = 8 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ExecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property ExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property ExecUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property ItemStatus As %Library.SmallInt [ Required, SqlColumnNumber = 18 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

Property HISOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BDTreatReqCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TreatReqDR</Value>
</Value>
<Value name="3">
<Value>TreatPurposeDR</Value>
</Value>
<Value name="4">
<Value>CostItemDR</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
<Value name="6">
<Value>Quantity</Value>
</Value>
<Value name="7">
<Value>PayAmount</Value>
</Value>
<Value name="8">
<Value>AddDate</Value>
</Value>
<Value name="9">
<Value>AddTime</Value>
</Value>
<Value name="10">
<Value>AddUserDR</Value>
</Value>
<Value name="11">
<Value>ExecDate</Value>
</Value>
<Value name="12">
<Value>ExecTime</Value>
</Value>
<Value name="13">
<Value>ExecUserDR</Value>
</Value>
<Value name="14">
<Value>CancelDate</Value>
</Value>
<Value name="15">
<Value>CancelTime</Value>
</Value>
<Value name="16">
<Value>CancelUserDR</Value>
</Value>
<Value name="17">
<Value>ItemStatus</Value>
</Value>
<Value name="18">
<Value>Remark</Value>
</Value>
<Value name="19">
<Value>HISOrderID</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTreatReqCostItemD</DataLocation>
<DefaultData>BDTreatReqCostItemDefaultData</DefaultData>
<IdLocation>^dbo.BDTreatReqCostItemD</IdLocation>
<IndexLocation>^dbo.BDTreatReqCostItemI</IndexLocation>
<StreamLocation>^dbo.BDTreatReqCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
