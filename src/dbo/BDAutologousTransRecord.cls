Class dbo.BDAutologousTransRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AutologousTransRecord, StorageStrategy = Default ]
{

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexOpsCode On OpsCode [ SqlName = Index_OpsCode, Type = index ];

Index IndexReqForm On ReqFormDR [ SqlName = Index_ReqForm, Type = index ];

Index IndexTransRecordNo On TransRecordNo [ SqlName = Index_TransRecordNo, Type = index, Unique ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKBDAUTOTRANSREC On RowID [ PrimaryKey, SqlName = PK_BD_AUTOTRANSREC, Type = index, Unique ];

/// Foreign Key FKBDReqAddUser created via DDL
ForeignKey FKBDTransAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Trans_AddUser ];

/// Foreign Key FKBDReqCheckUser created via DDL
ForeignKey FKBDTransCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_Trans_CheckUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TransRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Status As %Library.SmallInt [ Required, SqlColumnNumber = 5 ];

Property OpsName As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 6 ];

Property OpsCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 7 ];

Property InfusionStartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property InfusionStartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property InfusionEndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property InfusionEndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CallbackDevice As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

Property Anticoagulant As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

Property CallBackVolume As %Library.Float [ SqlColumnNumber = 14 ];

Property CollectPart As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Property ObligateVolume As %Library.Float [ SqlColumnNumber = 16 ];

Property SeparateCompType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

Property SeparateComponent As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

Property SeparateDevice As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

Property SeparateNote As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 20 ];

Property TransfusionRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 21 ];

Property IsAdverseReaction As %Library.Boolean [ SqlColumnNumber = 22 ];

Property AdverseReactionDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property AdverseReactionTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property AdverseReactionNote As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 25 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 26 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

Storage Default
{
<Data name="BDAutologousTransRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransRecordNo</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>OpsName</Value>
</Value>
<Value name="6">
<Value>OpsCode</Value>
</Value>
<Value name="7">
<Value>InfusionStartDate</Value>
</Value>
<Value name="8">
<Value>InfusionStartTime</Value>
</Value>
<Value name="9">
<Value>InfusionEndDate</Value>
</Value>
<Value name="10">
<Value>InfusionEndTime</Value>
</Value>
<Value name="11">
<Value>CallbackDevice</Value>
</Value>
<Value name="12">
<Value>Anticoagulant</Value>
</Value>
<Value name="13">
<Value>CallBackVolume</Value>
</Value>
<Value name="14">
<Value>CollectPart</Value>
</Value>
<Value name="15">
<Value>ObligateVolume</Value>
</Value>
<Value name="16">
<Value>SeparateCompType</Value>
</Value>
<Value name="17">
<Value>SeparateComponent</Value>
</Value>
<Value name="18">
<Value>SeparateDevice</Value>
</Value>
<Value name="19">
<Value>SeparateNote</Value>
</Value>
<Value name="20">
<Value>TransfusionRemark</Value>
</Value>
<Value name="21">
<Value>IsAdverseReaction</Value>
</Value>
<Value name="22">
<Value>AdverseReactionDate</Value>
</Value>
<Value name="23">
<Value>AdverseReactionTime</Value>
</Value>
<Value name="24">
<Value>AdverseReactionNote</Value>
</Value>
<Value name="25">
<Value>Remark</Value>
</Value>
<Value name="26">
<Value>AddDate</Value>
</Value>
<Value name="27">
<Value>AddTime</Value>
</Value>
<Value name="28">
<Value>AddUserDR</Value>
</Value>
<Value name="29">
<Value>CheckDate</Value>
</Value>
<Value name="30">
<Value>CheckTime</Value>
</Value>
<Value name="31">
<Value>CheckUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAutologousTransRecordD</DataLocation>
<DefaultData>BDAutologousTransRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDAutologousTransRecordD</IdLocation>
<IndexLocation>^dbo.BDAutologousTransRecordI</IndexLocation>
<StreamLocation>^dbo.BDAutologousTransRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
