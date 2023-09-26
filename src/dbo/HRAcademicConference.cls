Class dbo.HRAcademicConference Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_AcademicConference, StorageStrategy = Default ]
{

/// Foreign Key FKAcademicConferenceAddUser created via DDL
ForeignKey FKAcademicConferenceAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AcademicConferenceAddUser ];

/// Foreign Key FKAcademicConferenceAuthUser created via DDL
ForeignKey FKAcademicConferenceAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AcademicConferenceAuthUser ];

/// Foreign Key FKAcademicConferenceCancelUser created via DDL
ForeignKey FKAcademicConferenceCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AcademicConferenceCancelUser ];

/// Foreign Key FKAcademicConferenceStaff created via DDL
ForeignKey FKAcademicConferenceStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_AcademicConferenceStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRACADEMICCONFERENCE On RowID [ PrimaryKey, SqlName = PK_HR_ACADEMICCONFERENCE, Type = index, Unique ];

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

Property ConferenceTitle As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Property ConferenceDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property ConferenceTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

Property Department As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="HRAcademicConferenceDefaultData">
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
<Value>ConferenceTitle</Value>
</Value>
<Value name="15">
<Value>ConferenceDate</Value>
</Value>
<Value name="16">
<Value>ConferenceTime</Value>
</Value>
<Value name="17">
<Value>Address</Value>
</Value>
<Value name="18">
<Value>Department</Value>
</Value>
<Value name="19">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.HRAcademicConferenceD</DataLocation>
<DefaultData>HRAcademicConferenceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRAcademicConferenceD</IdLocation>
<IndexLocation>^dbo.HRAcademicConferenceI</IndexLocation>
<StreamLocation>^dbo.HRAcademicConferenceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
