Class dbo.BDPackVerifyLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackVerifyLog ]
{

Index IndexMaster On (PackDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexVerDate On (PackDR, VerDate, CheckStage) [ SqlName = Index_VerDate, Type = index ];

Index IndexCheckStage On (PackDR, CheckStage, VerDate) [ SqlName = Index_CheckStage, Type = index ];

Index IndexOperateType On (OperateType, AddDate) [ SqlName = Index_OperateType, Type = index ];

Index PKBDPackVerifyLog On RowID [ PrimaryKey, SqlName = PK_BD_PackVerifyLog, Type = index, Unique ];

ForeignKey FKVerifyLogBDPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_VerifyLog_BD_Pack ];

ForeignKey FKFirUser(FirUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_Fir_User ];

ForeignKey FKSecUser(SecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_Sec_User ];

ForeignKey FKIssueRecord(IssueRecordDR) References dbo.BDIssueRecord(PKBDISSUERECORD) [ SqlName = FK_IssueRecord ];

ForeignKey FKBDPackVerifyLogWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_PackVerifyLog_WorkGroup ];

ForeignKey FKBDPackVerifyLogLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BD_PackVerifyLog_Location ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property CheckStage As %Library.SmallInt [ Required, SqlColumnNumber = 6 ];

Property VerDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property VerTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property FirUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property SecUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property IsPass As %Library.Boolean [ SqlColumnNumber = 11 ];

Property IssueRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property VerifyResult As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 15 ];

Property OperateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 16 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BDPackVerifyLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>CheckStage</Value>
</Value>
<Value name="6">
<Value>VerDate</Value>
</Value>
<Value name="7">
<Value>VerTime</Value>
</Value>
<Value name="8">
<Value>FirUserDR</Value>
</Value>
<Value name="9">
<Value>SecUserDR</Value>
</Value>
<Value name="10">
<Value>IsPass</Value>
</Value>
<Value name="11">
<Value>IssueRecordDR</Value>
</Value>
<Value name="12">
<Value>WorkGroupDR</Value>
</Value>
<Value name="13">
<Value>LocationDR</Value>
</Value>
<Value name="14">
<Value>VerifyResult</Value>
</Value>
<Value name="15">
<Value>OperateType</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackVerifyLogD</DataLocation>
<DefaultData>BDPackVerifyLogDefaultData</DefaultData>
<IdLocation>^dbo.BDPackVerifyLogD</IdLocation>
<IndexLocation>^dbo.BDPackVerifyLogI</IndexLocation>
<StreamLocation>^dbo.BDPackVerifyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
