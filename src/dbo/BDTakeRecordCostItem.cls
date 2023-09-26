Class dbo.BDTakeRecordCostItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TakeRecordCostItem, StorageStrategy = Default ]
{

/// Foreign Key FKBDRFCostIAddUser created via DDL
ForeignKey FKBDRFCostIAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFCostI_AddUser ];

/// Foreign Key FKBDRFCostICancelUser created via DDL
ForeignKey FKBDRFCostICancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFCostI_CancelUser ];

/// Foreign Key FKBDRFCostICostItem created via DDL
ForeignKey FKBDRFCostICostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_BD_RFCostI_CostItem ];

/// Foreign Key FKBDRFCostIExecUser created via DDL
ForeignKey FKBDRFCostIExecUser(ExecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RFCostI_ExecUser ];

/// Foreign Key FKBDRFCostIIssueRecord created via DDL
ForeignKey FKBDRFCostIIssueRecord(IssueRecordDR) References dbo.BDIssueRecord(PKBDISSUERECORD) [ SqlName = FK_BD_RFCostI_IssueRecord ];

/// Foreign Key FKBDRFCostIReqForm created via DDL
ForeignKey FKBDRFCostITakeRecord(TakeRecordDR) References dbo.BDTakeRecord(PKBDTAKERECORD) [ SqlName = FK_BD_TRCostI_TakeRecord ];

/// Foreign Key FKBBRPCIReqProduct created via DDL
ForeignKey FKBBRPCIReqProduct(ReqProductDR) References dbo.BBReqProduct(PKBBREQPRODUCT) [ SqlName = FK_BB_RPCI_ReqProduct ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexExecDate On ExecDate [ SqlName = Index_ExecDate, Type = index ];

Index IndexIssueRecord On IssueRecordDR [ SqlName = Index_IssueRecord, Type = index ];

Index IndexTakeRecord On TakeRecordDR [ SqlName = Index_TakeRecord, Type = index ];

/// DDL Primary Key Specification
Index PKBDRTAKERECORDCOSTITEM On RowID [ PrimaryKey, SqlName = PK_BD_REQTAKERECORDCOSTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TakeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CostType As %Library.SmallInt [ Required, SqlColumnNumber = 4 ];

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

Property IssueRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property IsSended As %Library.Boolean [ SqlColumnNumber = 21 ];

Property ReqProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property HISOrderID As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="BDTakeRecordCostItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TakeRecordDR</Value>
</Value>
<Value name="3">
<Value>CostType</Value>
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
<Value>IssueRecordDR</Value>
</Value>
<Value name="20">
<Value>IsSended</Value>
</Value>
<Value name="21">
<Value>ReqProductDR</Value>
</Value>
<Value name="22">
<Value>BloodGroupDR</Value>
</Value>
<Value name="23">
<Value>HISOrderID</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTakeRecordCostItemD</DataLocation>
<DefaultData>BDTakeRecordCostItemDefaultData</DefaultData>
<IdLocation>^dbo.BDTakeRecordCostItemD</IdLocation>
<IndexLocation>^dbo.BDTakeRecordCostItemI</IndexLocation>
<StreamLocation>^dbo.BDTakeRecordCostItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
