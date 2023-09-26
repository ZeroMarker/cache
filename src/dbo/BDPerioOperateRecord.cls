Class dbo.BDPerioOperateRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PerioOperateRecord, StorageStrategy = Default ]
{

/// Foreign Key FKEvaluationAddUser created via DDL
ForeignKey FKPerOpeRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PerOpeRecord_AddUser ];

/// Foreign Key FKEvaluationCheckUser created via DDL
ForeignKey FKPerOpeRecordCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PerOpeRecord_CheckUser ];

/// Foreign Key FKBDRFPPurpose created via DDL
ForeignKey FKPerOpeRecordPurpose(PurposeDR) References dbo.BBPurpose(PKBBPURPOSE) [ SqlName = FK_PerOpeRecord_Purpose ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexCheckDate On CheckDate [ SqlName = Index_CheckDate, Type = index ];

Index IndexAdmNo On AdmNo [ SqlName = Index_AdmNo, Type = index ];

/// DDL Primary Key Specification
Index PKBDPerioOpeRecord On RowID [ PrimaryKey, SqlName = PK_BD_PerioOpeRecord, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OperateRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

Property IssueRecordDRs As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property InfusionStartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property InfusionStartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property InfusionEndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property InfusionEndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property BodyStatus As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 13 ];

Property ClinicDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 14 ];

Property OutVolume As %Library.Float [ SqlColumnNumber = 15 ];

Property CallBackVolume As %Library.Float [ SqlColumnNumber = 16 ];

Property Anticoagulant As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

Property BefAnticoagulant As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

Property TransRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 19 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 20 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property PurposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="BDPerioOperateRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperateRecordNo</Value>
</Value>
<Value name="3">
<Value>AdmNo</Value>
</Value>
<Value name="4">
<Value>IssueRecordDRs</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>InfusionStartDate</Value>
</Value>
<Value name="9">
<Value>InfusionStartTime</Value>
</Value>
<Value name="10">
<Value>InfusionEndDate</Value>
</Value>
<Value name="11">
<Value>InfusionEndTime</Value>
</Value>
<Value name="12">
<Value>BodyStatus</Value>
</Value>
<Value name="13">
<Value>ClinicDesc</Value>
</Value>
<Value name="14">
<Value>OutVolume</Value>
</Value>
<Value name="15">
<Value>CallBackVolume</Value>
</Value>
<Value name="16">
<Value>Anticoagulant</Value>
</Value>
<Value name="17">
<Value>BefAnticoagulant</Value>
</Value>
<Value name="18">
<Value>TransRemark</Value>
</Value>
<Value name="19">
<Value>Remark</Value>
</Value>
<Value name="20">
<Value>CheckDate</Value>
</Value>
<Value name="21">
<Value>CheckTime</Value>
</Value>
<Value name="22">
<Value>CheckUserDR</Value>
</Value>
<Value name="23">
<Value>PurposeDR</Value>
</Value>
<Value name="24">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPerioOperateRecordD</DataLocation>
<DefaultData>BDPerioOperateRecordDefaultData</DefaultData>
<IdLocation>^dbo.BDPerioOperateRecordD</IdLocation>
<IndexLocation>^dbo.BDPerioOperateRecordI</IndexLocation>
<StreamLocation>^dbo.BDPerioOperateRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
