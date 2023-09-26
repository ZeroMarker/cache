///     
Class dbo.RGRequestTask Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_RequestTask, StorageStrategy = Default ]
{

Index IndexFromReagentGroupDate On (FromReagentGroupDR, RequestDate) [ SqlName = Index_FromReagentGroup_Date, Type = index ];

Index IndexProcessDate On ProcessDate [ SqlName = Index_Process_Date, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_Check_Date, Type = index ];

Index IndexCancellDate On CancellDate [ SqlName = Index_Cancell_Date, Type = index ];

Index IndexRequestNo On RequestNo [ SqlName = Index_RequestNo, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexCheckStatus On Status [ SqlName = Index_CheckStatus, Type = index ];

Index IndexToReagentGroupDate On (ToReagentGroupDR, RequestDate) [ SqlName = Index_ToReagentGroup_Date, Type = index ];

Index IndexUserDate On (RequestUserDR, RequestDate) [ SqlName = Index_User_Date, Type = index ];

/// DDL Primary Key Specification
Index PKRGREQUESTTASK On RowID [ PrimaryKey, SqlName = PK_RG_REQUESTTASK, Type = index, Unique ];

/// Foreign Key FKRGTaskFromGroup created via DDL
ForeignKey FKRGTaskFromGroup(FromReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Task_FromGroup ];

/// Foreign Key FKRGTaskRejector created via DDL
ForeignKey FKRGTaskRejector(ProcessDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Task_Rejector ];

/// Foreign Key FKRGTaskToGroup created via DDL
ForeignKey FKRGTaskToGroup(ToReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Task_ToGroup ];

/// Foreign Key FKRGTaskUser created via DDL
ForeignKey FKRGTaskUser(RequestUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Task_User ];

/// Foreign Key FKRGTaskChecker created via DDL
ForeignKey FKRGTaskChecker(CheckerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Task_Checker ];

/// Foreign Key FKRGTaskCanceller created via DDL
ForeignKey FKRGTaskCanceller(CancellerDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Task_Canceller ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property ToReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property FromReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property RequestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property RequestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property RequestUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property ProcessDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ProcessTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ProcessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property RejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

Property CheckStatus As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property CheckerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property CancellDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property CancellTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property CancellerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="RGRequestTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestNo</Value>
</Value>
<Value name="3">
<Value>ToReagentGroupDR</Value>
</Value>
<Value name="4">
<Value>FromReagentGroupDR</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>RequestDate</Value>
</Value>
<Value name="7">
<Value>RequestTime</Value>
</Value>
<Value name="8">
<Value>RequestUserDR</Value>
</Value>
<Value name="9">
<Value>ProcessDate</Value>
</Value>
<Value name="10">
<Value>ProcessTime</Value>
</Value>
<Value name="11">
<Value>ProcessDR</Value>
</Value>
<Value name="12">
<Value>RejectReason</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>CheckStatus</Value>
</Value>
<Value name="15">
<Value>CheckDate</Value>
</Value>
<Value name="16">
<Value>CheckTime</Value>
</Value>
<Value name="17">
<Value>CheckerDR</Value>
</Value>
<Value name="18">
<Value>CancellDate</Value>
</Value>
<Value name="19">
<Value>CancellTime</Value>
</Value>
<Value name="20">
<Value>CancellerDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RGRequestTaskD</DataLocation>
<DefaultData>RGRequestTaskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGRequestTaskD</IdLocation>
<IndexLocation>^dbo.RGRequestTaskI</IndexLocation>
<StreamLocation>^dbo.RGRequestTaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
