Class dbo.HRTraining Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_Training, StorageStrategy = Default ]
{

/// Foreign Key FKTrainingAddUser created via DDL
ForeignKey FKTrainingAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TrainingAddUser ];

/// Foreign Key FKTrainingAuthUser created via DDL
ForeignKey FKTrainingAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TrainingAuthUser ];

/// Foreign Key FKTrainingCancelUser created via DDL
ForeignKey FKTrainingCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TrainingCancelUser ];

/// Foreign Key FKTrainingStaff created via DDL
ForeignKey FKTrainingStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_TrainingStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRTRAINING On RowID [ PrimaryKey, SqlName = PK_HR_TRAINING, Type = index, Unique ];

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

Property TrainingName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 23 ];

Property TrainingType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 24 ];

Property AppraiseType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 25 ];

Property Score As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

Property Comment As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 27 ];

Storage Default
{
<Data name="HRTrainingDefaultData">
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
<Value>TrainingName</Value>
</Value>
<Value name="19">
<Value>TrainingType</Value>
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
<DataLocation>^dbo.HRTrainingD</DataLocation>
<DefaultData>HRTrainingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRTrainingD</IdLocation>
<IndexLocation>^dbo.HRTrainingI</IndexLocation>
<StreamLocation>^dbo.HRTrainingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
