Class dbo.HREstimate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_Estimate, StorageStrategy = Default ]
{

/// Foreign Key FKEstimateAddUser created via DDL
ForeignKey FKEstimateAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_EstimateAddUser ];

/// Foreign Key FKEstimateAuthUser created via DDL
ForeignKey FKEstimateAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_EstimateAuthUser ];

/// Foreign Key FKEstimateCancelUser created via DDL
ForeignKey FKEstimateCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_EstimateCancelUser ];

/// Foreign Key FKEstimateStaff created via DDL
ForeignKey FKEstimateStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_EstimateStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRESTIMATE On RowID [ PrimaryKey, SqlName = PK_HR_ESTIMATE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StaffDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 17 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 18 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property EstimateName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 23 ];

Property EstimateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 24 ];

Property AppraiseType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 25 ];

Property Score As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

Property Comment As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 27 ];

Storage Default
{
<Data name="HREstimateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StaffDR</Value>
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
<Value>AuthDate</Value>
</Value>
<Value name="7">
<Value>AuthTime</Value>
</Value>
<Value name="8">
<Value>AuthUserDR</Value>
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
<Value>CancelRemark</Value>
</Value>
<Value name="13">
<Value>Status</Value>
</Value>
<Value name="14">
<Value>StartDate</Value>
</Value>
<Value name="15">
<Value>StartTime</Value>
</Value>
<Value name="16">
<Value>EndDate</Value>
</Value>
<Value name="17">
<Value>EndTime</Value>
</Value>
<Value name="18">
<Value>EstimateName</Value>
</Value>
<Value name="19">
<Value>EstimateType</Value>
</Value>
<Value name="20">
<Value>AppraiseType</Value>
</Value>
<Value name="21">
<Value>Score</Value>
</Value>
<Value name="22">
<Value>Comment</Value>
</Value>
</Data>
<DataLocation>^dbo.HREstimateD</DataLocation>
<DefaultData>HREstimateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HREstimateD</IdLocation>
<IndexLocation>^dbo.HREstimateI</IndexLocation>
<StreamLocation>^dbo.HREstimateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
