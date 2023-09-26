///     
Class dbo.BDTransEvaluation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TransEvaluation, StorageStrategy = Default ]
{

/// Foreign Key FKEvaluationAddUser created via DDL
ForeignKey FKEvaluationAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_Evaluation_AddUser ];

/// Foreign Key FKEvaluationCheckUser created via DDL
ForeignKey FKEvaluationCheckUser(CheckUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_Evaluation_CheckUser ];

/// Foreign Key FKEvaluationCheckUser created via DDL
ForeignKey FKEvaluationEvaluateUser(EvaluateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_Evaluation_EvaluateUser ];

/// Foreign Key FKEvaluationLocation created via DDL
ForeignKey FKEvaluationLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_Evaluation_Location ];

/// Foreign Key FKEvaluationReqForm created via DDL
ForeignKey FKEvaluationReqForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_Evaluation_ReqForm ];

/// Foreign Key FKEvaluationCheckUser created via DDL
ForeignKey FKEvaluationDepartUser(DepartUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_EvaluationDepart_User ];

/// Foreign Key FKEvaluationCheckUser created via DDL
ForeignKey FKEvaluationMedUser(MedEvaUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_Evaluation_MedUser ];

Index IndexAddDate On (AddDate, LocationDR) [ SqlName = Index_AddDate, Type = index ];

Index IndexEvaluateDate On (EvaluateDate, LocationDR) [ SqlName = Index_EvaluateDate, Type = index ];

Index IndexCheckDate On (CheckDate, LocationDR) [ SqlName = Index_CheckDate, Type = index ];

Index IndexMaster On EvaluationNo [ SqlName = Index_Master, Type = index, Unique ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexReqForm On ReqFormDR [ SqlName = Index_ReqForm, Type = index ];

/// DDL Primary Key Specification
Index PKBDTransEvaluation On RowID [ PrimaryKey, SqlName = PK_BD_TransEvaluation, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EvaluationNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property IssueRecordDRs As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property EvaluateResult As %Library.SmallInt [ Required, SqlColumnNumber = 7 ];

Property EvaluateText As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

Property DepartEvaluate As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Property MedEvaluate As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 10 ];

Property Status As %Library.SmallInt [ SqlColumnNumber = 11 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 13 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

Property EvaluateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

Property EvaluateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 16 ];

Property EvaluateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 17 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property DepartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property DepartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property DepartUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Property MedEvaDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Property MedEvaTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Property MedEvaUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

Property OutVolume As %Library.Float [ SqlColumnNumber = 28 ];

Property BodyStatus As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 29 ];

Property BefAneSym As %Library.Boolean [ SqlColumnNumber = 30 ];

Property BefAneSymDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 31 ];

Property BefAneApp As %Library.Boolean [ SqlColumnNumber = 32 ];

Property BefAneAppDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 33 ];

Property BefBldOut As %Library.Boolean [ SqlColumnNumber = 34 ];

Property BefBldOutDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 35 ];

Property AftAneSym As %Library.Boolean [ SqlColumnNumber = 36 ];

Property AftAneSymDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 37 ];

Property AftAneApp As %Library.Boolean [ SqlColumnNumber = 38 ];

Property AftAneAppDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 39 ];

Property AftBldOutDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 40 ];

Property ResultReason As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 41 ];

Property ResultMeasure As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 42 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 43 ];

Property EvaluationStatus As %Library.SmallInt [ Required, SqlColumnNumber = 44 ];

Storage Default
{
<Data name="BDTransEvaluationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EvaluationNo</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>IssueRecordDRs</Value>
</Value>
<Value name="5">
<Value>RegNo</Value>
</Value>
<Value name="6">
<Value>EvaluateResult</Value>
</Value>
<Value name="7">
<Value>EvaluateText</Value>
</Value>
<Value name="8">
<Value>DepartEvaluate</Value>
</Value>
<Value name="9">
<Value>MedEvaluate</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>AddDate</Value>
</Value>
<Value name="12">
<Value>AddTime</Value>
</Value>
<Value name="13">
<Value>AddUserDR</Value>
</Value>
<Value name="14">
<Value>EvaluateDate</Value>
</Value>
<Value name="15">
<Value>EvaluateTime</Value>
</Value>
<Value name="16">
<Value>EvaluateUserDR</Value>
</Value>
<Value name="17">
<Value>LocationDR</Value>
</Value>
<Value name="18">
<Value>CheckDate</Value>
</Value>
<Value name="19">
<Value>CheckTime</Value>
</Value>
<Value name="20">
<Value>CheckUserDR</Value>
</Value>
<Value name="21">
<Value>DepartDate</Value>
</Value>
<Value name="22">
<Value>DepartTime</Value>
</Value>
<Value name="23">
<Value>DepartUserDR</Value>
</Value>
<Value name="24">
<Value>MedEvaDate</Value>
</Value>
<Value name="25">
<Value>MedEvaTime</Value>
</Value>
<Value name="26">
<Value>MedEvaUserDR</Value>
</Value>
<Value name="27">
<Value>OutVolume</Value>
</Value>
<Value name="28">
<Value>BodyStatus</Value>
</Value>
<Value name="29">
<Value>BefAneSym</Value>
</Value>
<Value name="30">
<Value>BefAneSymDesc</Value>
</Value>
<Value name="31">
<Value>BefAneApp</Value>
</Value>
<Value name="32">
<Value>BefAneAppDesc</Value>
</Value>
<Value name="33">
<Value>BefBldOut</Value>
</Value>
<Value name="34">
<Value>BefBldOutDesc</Value>
</Value>
<Value name="35">
<Value>AftAneSym</Value>
</Value>
<Value name="36">
<Value>AftAneSymDesc</Value>
</Value>
<Value name="37">
<Value>AftAneApp</Value>
</Value>
<Value name="38">
<Value>AftAneAppDesc</Value>
</Value>
<Value name="39">
<Value>AftBldOutDesc</Value>
</Value>
<Value name="40">
<Value>ResultReason</Value>
</Value>
<Value name="41">
<Value>ResultMeasure</Value>
</Value>
<Value name="42">
<Value>Remark</Value>
</Value>
<Value name="43">
<Value>EvaluationStatus</Value>
</Value>
</Data>
<DataLocation>^dbo.BDTransEvaluationD</DataLocation>
<DefaultData>BDTransEvaluationDefaultData</DefaultData>
<IdLocation>^dbo.BDTransEvaluationD</IdLocation>
<IndexLocation>^dbo.BDTransEvaluationI</IndexLocation>
<StreamLocation>^dbo.BDTransEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
