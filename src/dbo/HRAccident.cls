///     
Class dbo.HRAccident Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_Accident, StorageStrategy = Default ]
{

/// Foreign Key FKAccidentAddUser created via DDL
ForeignKey FKAccidentAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AccidentAddUser ];

/// Foreign Key FKAccidentAuthUser created via DDL
ForeignKey FKAccidentAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AccidentAuthUser ];

/// Foreign Key FKAccidentCancelUser created via DDL
ForeignKey FKAccidentCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AccidentCancelUser ];

/// Foreign Key FKAccidentStaff created via DDL
ForeignKey FKAccidentStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_AccidentStaff ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

Index IndexOccurDate On OccurDate [ SqlName = Index_OccurDate, Type = index ];

/// DDL Primary Key Specification
Index PKHRACCIDENT On RowID [ PrimaryKey, SqlName = PK_HR_ACCIDENT, Type = index, Unique ];

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

Property OccurDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property OccurTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 17 ];

Property Reason As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

Property Aftermath As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 19 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="HRAccidentDefaultData">
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
<Value>OccurDate</Value>
</Value>
<Value name="15">
<Value>OccurTime</Value>
</Value>
<Value name="16">
<Value>Description</Value>
</Value>
<Value name="17">
<Value>Reason</Value>
</Value>
<Value name="18">
<Value>Aftermath</Value>
</Value>
<Value name="19">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.HRAccidentD</DataLocation>
<DefaultData>HRAccidentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRAccidentD</IdLocation>
<IndexLocation>^dbo.HRAccidentI</IndexLocation>
<StreamLocation>^dbo.HRAccidentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
