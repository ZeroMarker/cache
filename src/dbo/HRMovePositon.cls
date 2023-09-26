///     
Class dbo.HRMovePositon Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_MovePositon, StorageStrategy = Default ]
{

/// Foreign Key FKMovePositonAddUser created via DDL
ForeignKey FKMovePositonAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MovePositonAddUser ];

/// Foreign Key FKMovePositonAuthUser created via DDL
ForeignKey FKMovePositonAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MovePositonAuthUser ];

/// Foreign Key FKMovePositonCancelUser created via DDL
ForeignKey FKMovePositonCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MovePositonCancelUser ];

/// Foreign Key FKMovePositonStaff created via DDL
ForeignKey FKMovePositonStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_MovePositonStaff ];

/// Foreign Key FKMovePositonWorkGroup created via DDL
ForeignKey FKMovePositonWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_MovePositonWorkGroup ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMaster On (StaffDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On Status [ SqlName = Index_Status, Type = index ];

/// DDL Primary Key Specification
Index PKHRMovePositon On RowID [ PrimaryKey, SqlName = PK_HR_MovePositon, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StaffDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property MoveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 12 ];

Property MoveType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 13 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 17 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="HRMovePositonDefaultData">
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
<Value>MoveDate</Value>
</Value>
<Value name="10">
<Value>WorkGroupDR</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>MoveType</Value>
</Value>
<Value name="13">
<Value>CancelDate</Value>
</Value>
<Value name="14">
<Value>CancelTime</Value>
</Value>
<Value name="15">
<Value>CancelUserDR</Value>
</Value>
<Value name="16">
<Value>CancelRemark</Value>
</Value>
<Value name="17">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.HRMovePositonD</DataLocation>
<DefaultData>HRMovePositonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRMovePositonD</IdLocation>
<IndexLocation>^dbo.HRMovePositonI</IndexLocation>
<StreamLocation>^dbo.HRMovePositonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
