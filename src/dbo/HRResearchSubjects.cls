Class dbo.HRResearchSubjects Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_ResearchSubjects, StorageStrategy = Default ]
{

/// Foreign Key FKResearchSubjectsAddUser created via DDL
ForeignKey FKResearchSubjectsAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ResearchSubjectsAddUser ];

/// Foreign Key FKResearchSubjectsAuthUser created via DDL
ForeignKey FKResearchSubjectsAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ResearchSubjectsAuthUser ];

/// Foreign Key FKResearchSubjectsCancelUser created via DDL
ForeignKey FKResearchSubjectsCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_ResearchSubjectsCancelUser ];

/// Foreign Key FKResearchSubjectsStaff created via DDL
ForeignKey FKResearchSubjectsStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_ResearchSubjectsStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRRESEARCHSUBJECTS On RowID [ PrimaryKey, SqlName = PK_HR_RESEARCHSUBJECTS, Type = index, Unique ];

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

Property ProjectNameAndCode As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 15 ];

Property Resource As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 16 ];

Property DateRange As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

Property Funds As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

Property PersonalContent As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 19 ];

Property Progress As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 20 ];

Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="HRResearchSubjectsDefaultData">
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
<Value>ProjectNameAndCode</Value>
</Value>
<Value name="15">
<Value>Resource</Value>
</Value>
<Value name="16">
<Value>DateRange</Value>
</Value>
<Value name="17">
<Value>Funds</Value>
</Value>
<Value name="18">
<Value>PersonalContent</Value>
</Value>
<Value name="19">
<Value>Progress</Value>
</Value>
<Value name="20">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^dbo.HRResearchSubjectsD</DataLocation>
<DefaultData>HRResearchSubjectsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRResearchSubjectsD</IdLocation>
<IndexLocation>^dbo.HRResearchSubjectsI</IndexLocation>
<StreamLocation>^dbo.HRResearchSubjectsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
