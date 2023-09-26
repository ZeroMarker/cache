Class dbo.HRTeachingRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_TeachingRecord, StorageStrategy = Default ]
{

/// Foreign Key FKTeachingRecordAddUser created via DDL
ForeignKey FKTeachingRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TeachingRecordAddUser ];

/// Foreign Key FKTeachingRecordAuthUser created via DDL
ForeignKey FKTeachingRecordAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TeachingRecordAuthUser ];

/// Foreign Key FKTeachingRecordCancelUser created via DDL
ForeignKey FKTeachingRecordCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TeachingRecordCancelUser ];

/// Foreign Key FKTeachingRecordStaff created via DDL
ForeignKey FKTeachingRecordStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_TeachingRecordStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRTEACHINGRECORD On RowID [ PrimaryKey, SqlName = PK_HR_TEACHINGRECORD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StaffDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property CourseHours As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

Property Content As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 20 ];

Property Object As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="HRTeachingRecordDefaultData">
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
<Value>CourseHours</Value>
</Value>
<Value name="19">
<Value>Content</Value>
</Value>
<Value name="20">
<Value>Object</Value>
</Value>
</Data>
<DataLocation>^dbo.HRTeachingRecordD</DataLocation>
<DefaultData>HRTeachingRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRTeachingRecordD</IdLocation>
<IndexLocation>^dbo.HRTeachingRecordI</IndexLocation>
<StreamLocation>^dbo.HRTeachingRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
