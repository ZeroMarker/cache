Class dbo.HRAcademicParticipation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_AcademicParticipation, StorageStrategy = Default ]
{

/// Foreign Key FKHealthRecordAddUser created via DDL
ForeignKey FKAcademicParticipationAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AcademicParticipationAddUser ];

/// Foreign Key FKHealthRecordAuthUser created via DDL
ForeignKey FKAcademicParticipationAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AcademicParticipationAuthUser ];

/// Foreign Key FKHealthRecordCancelUser created via DDL
ForeignKey FKAcademicParticipationCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AcademicParticipationCancelUser ];

/// Foreign Key FKHealthRecordStaff created via DDL
ForeignKey FKAcademicParticipationStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_AcademicParticipationStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRACADEMICPARTICIPATION On RowID [ PrimaryKey, SqlName = PK_HR_ACADEMICPARTICIPATION, Type = index, Unique ];

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

Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Property Position As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="HRAcademicParticipationDefaultData">
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
<Value>Name</Value>
</Value>
<Value name="15">
<Value>Position</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.HRAcademicParticipationD</DataLocation>
<DefaultData>HRAcademicParticipationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRAcademicParticipationD</IdLocation>
<IndexLocation>^dbo.HRAcademicParticipationI</IndexLocation>
<StreamLocation>^dbo.HRAcademicParticipationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
