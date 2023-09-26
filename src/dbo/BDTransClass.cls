///     
Class dbo.BDTransClass Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TransClass, StorageStrategy = Default ]
{

Index IndexEndDateTime On (TransWorkGroupDR, TransEndDate, TransEndTime) [ SqlName = Index_EndDateTime, Type = index ];

/// DDL Primary Key Specification
Index IndexMaster On TransRecordNo [ PrimaryKey, SqlName = Index_Master, Type = index, Unique ];

Index IndexTransUserBefore On (TransUserBeforeDR, TransEndDate) [ SqlName = Index_TransUserBefore, Type = index ];

/// Foreign Key FKBDTransClassBTWorkGroup created via DDL
ForeignKey FKBDTransClassBTWorkGroup(TransWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_TransClass_BT_WorkGroup ];

/// Foreign Key FKTransClassAfterUser created via DDL
ForeignKey FKTransClassAfterUser(TransUserAfterDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TransClass_AfterUser ];

/// Foreign Key FKTransClassBeforeUser created via DDL
ForeignKey FKTransClassBeforeUser(TransUserBeforeDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TransClass_BeforeUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TransRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property TransStartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TransStartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property TransEndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property TransEndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property TransUserBeforeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property TransUserAfterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property TransWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Property TransXMCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property TransXMPackCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property TransAppformCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property TransApprovalAppformCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property TransRejectAppformCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property TransReactionCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property TransIssCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property TransTestCompCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property TransDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 19 ];

Property TransRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BDTransClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>TransRecordNo</Value>
</Value>
<Value name="4">
<Value>TransStartDate</Value>
</Value>
<Value name="5">
<Value>TransStartTime</Value>
</Value>
<Value name="6">
<Value>TransEndDate</Value>
</Value>
<Value name="7">
<Value>TransEndTime</Value>
</Value>
<Value name="8">
<Value>TransUserBeforeDR</Value>
</Value>
<Value name="9">
<Value>TransUserAfterDR</Value>
</Value>
<Value name="10">
<Value>TransWorkGroupDR</Value>
</Value>
<Value name="11">
<Value>TransXMCount</Value>
</Value>
<Value name="12">
<Value>TransXMPackCount</Value>
</Value>
<Value name="13">
<Value>TransAppformCount</Value>
</Value>
<Value name="14">
<Value>TransApprovalAppformCount</Value>
</Value>
<Value name="15">
<Value>TransRejectAppformCount</Value>
</Value>
<Value name="16">
<Value>TransReactionCount</Value>
</Value>
<Value name="17">
<Value>TransIssCount</Value>
</Value>
<Value name="18">
<Value>TransTestCompCount</Value>
</Value>
<Value name="19">
<Value>TransDesc</Value>
</Value>
<Value name="20">
<Value>TransRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTransClassD</DataLocation>
<DefaultData>BDTransClassDefaultData</DefaultData>
<IdLocation>^dbo.BDTransClassD</IdLocation>
<IndexLocation>^dbo.BDTransClassI</IndexLocation>
<StreamLocation>^dbo.BDTransClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
