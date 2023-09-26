Class dbo.HRHealthRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_HealthRecord, StorageStrategy = Default ]
{

/// Foreign Key FKHealthRecordAddUser created via DDL
ForeignKey FKHealthRecordAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_HealthRecordAddUser ];

/// Foreign Key FKHealthRecordAuthUser created via DDL
ForeignKey FKHealthRecordAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_HealthRecordAuthUser ];

/// Foreign Key FKHealthRecordCancelUser created via DDL
ForeignKey FKHealthRecordCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_HealthRecordCancelUser ];

/// Foreign Key FKHealthRecordStaff created via DDL
ForeignKey FKHealthRecordStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_HealthRecordStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRHEALTHRECORD On RowID [ PrimaryKey, SqlName = PK_HR_HEALTHRECORD, Type = index, Unique ];

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

Property Year As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

Property HealthCondition As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 16 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="HRHealthRecordDefaultData">
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
<Value>Year</Value>
</Value>
<Value name="15">
<Value>HealthCondition</Value>
</Value>
<Value name="16">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.HRHealthRecordD</DataLocation>
<DefaultData>HRHealthRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRHealthRecordD</IdLocation>
<IndexLocation>^dbo.HRHealthRecordI</IndexLocation>
<StreamLocation>^dbo.HRHealthRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
