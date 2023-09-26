Class dbo.HRTitleChange Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_TitleChange, StorageStrategy = Default ]
{

Index IndexMaster On (StaffDR, ChangeType, ChangeDate, ChangeTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexChangeDate On ChangeDate [ SqlName = Index_ChangeDate, Type = index ];

Index IndexChangeUser On (ChangeUserDR, ChangeDate) [ SqlName = Index_ChangeUser, Type = index ];

/// DDL Primary Key Specification
Index PKHRTitleChange On RowID [ PrimaryKey, SqlName = PK_HR_TITLECHANGE, Type = index, Unique ];

ForeignKey FKTitleChangeStaff(StaffDR) References dbo.HRStaff(PKHRSTAFF) [ SqlName = FK_TitleChangeStaff ];

ForeignKey FKTitleChangeChangeUser(ChangeUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TitleChangeChangeUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property StaffDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ChangeType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property NewTitleID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ChangeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property ChangeTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property ChangeUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="HRTitleChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StaffDR</Value>
</Value>
<Value name="3">
<Value>ChangeType</Value>
</Value>
<Value name="4">
<Value>NewTitleID</Value>
</Value>
<Value name="5">
<Value>ChangeDate</Value>
</Value>
<Value name="6">
<Value>ChangeTime</Value>
</Value>
<Value name="7">
<Value>ChangeUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.HRTitleChangeD</DataLocation>
<DefaultData>HRTitleChangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRTitleChangeD</IdLocation>
<IndexLocation>^dbo.HRTitleChangeI</IndexLocation>
<StreamLocation>^dbo.HRTitleChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
