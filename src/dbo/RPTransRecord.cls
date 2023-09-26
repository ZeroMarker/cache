Class dbo.RPTransRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_TransRecord ]
{

/// Foreign Key FKRPTRecordAddUser created via DDL
ForeignKey FKRPTRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_TRecord_AddUser ];

/// Foreign Key FKRPTRecordCancelUser created via DDL
ForeignKey FKRPTRecordCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_TRecord_CancleUser ];

/// Foreign Key FKRPTRecordCheckUser created via DDL
ForeignKey FKRPTRecordCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_TRecord_CheckUser ];

/// Foreign Key FKRPTRecordTransUser created via DDL
ForeignKey FKRPTRecordTransUser(TransUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_TRecord_TransUser ];

/// Foreign Key FKRPTRecordRecUser created via DDL
ForeignKey FKRPTRecordRecUser(RecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_TRecord_RecUser ];

/// Foreign Key FKRPTRecordWorkGroup created via DDL
ForeignKey FKRPTRecordWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RP_TRecord_WorkGroup ];

/// Foreign Key FKRPTRecordAimWorkGroup created via DDL
ForeignKey FKRPTRecordAimWorkGroup(AimWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RP_TRecord_AimWorkGroup ];

/// Foreign Key FKRPTRecordAimWorkGroup created via DDL
ForeignKey FKRPTRecordRecWorkGroup(RecWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RP_TRecord_RecWorkGroup ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexCancelDate On CancelDate [ SqlName = Index_CancleDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexWorkGroup On WorkGroupDR [ SqlName = Index_WorkGroup, Type = index ];

Index IndexAimWorkGroup On AimWorkGroupDR [ SqlName = Index_AimWorkGroup, Type = index ];

Index IndexRecWorkGroup On RecWorkGroupDR [ SqlName = Index_RecWorkGroup, Type = index ];

Index IndexMaster On RecordNo [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPTRANSRECORD On RowID [ PrimaryKey, SqlName = PK_BD_TAKERECORD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

Property TransUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Property TransUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

Property WorkGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 16 ];

Property AimWorkGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 17 ];

Property RecWorkGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 18 ];

Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 19 ];

Property IsPrinted As %Library.Boolean [ SqlColumnNumber = 20 ];

Property AimTransUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

Property RecUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property RecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property RecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="RPTransRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordNo</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>CheckDate</Value>
</Value>
<Value name="7">
<Value>CheckTime</Value>
</Value>
<Value name="8">
<Value>CheckUserDR</Value>
</Value>
<Value name="9">
<Value>CancelDate</Value>
</Value>
<Value name="10">
<Value>CancelTime</Value>
</Value>
<Value name="11">
<Value>CancelUserDR</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>TransUser</Value>
</Value>
<Value name="14">
<Value>TransUserDR</Value>
</Value>
<Value name="15">
<Value>WorkGroupDR</Value>
</Value>
<Value name="16">
<Value>AimWorkGroupDR</Value>
</Value>
<Value name="17">
<Value>RecWorkGroupDR</Value>
</Value>
<Value name="18">
<Value>Status</Value>
</Value>
<Value name="19">
<Value>IsPrinted</Value>
</Value>
<Value name="20">
<Value>AimTransUser</Value>
</Value>
<Value name="21">
<Value>RecUserDR</Value>
</Value>
<Value name="22">
<Value>RecDate</Value>
</Value>
<Value name="23">
<Value>RecTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPTransRecordD</DataLocation>
<DefaultData>RPTransRecordDefaultData</DefaultData>
<IdLocation>^dbo.RPTransRecordD</IdLocation>
<IndexLocation>^dbo.RPTransRecordI</IndexLocation>
<StreamLocation>^dbo.RPTransRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
