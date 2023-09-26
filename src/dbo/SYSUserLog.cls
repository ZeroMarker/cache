///     
Class dbo.SYSUserLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_UserLog, StorageStrategy = Default ]
{

Index IndexUserLogType On (UserDR, LogType, AddDate) [ SqlName = Index_UserLogType, Type = index ];

Index IndexLocation On (UserDR, SysCode, LocationDR, AddDate, LogType) [ SqlName = Index_Location, Type = index ];

Index IndexLogType On (SysCode, LogType, AddDate) [ SqlName = Index_LogType, Type = index ];

Index IndexMaster On (UserDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexMenu On (UserDR, SysCode, MenuDR) [ SqlName = Index_Menu, Type = index ];

Index IndexWorkGroup On (UserDR, SysCode, WorkGroupDR, AddDate, LogType) [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKSYSUSERLOG On RowID [ PrimaryKey, SqlName = PK_SYS_USERLOG, Type = index, Unique ];

/// Foreign Key FKUserLog created via DDL
ForeignKey FKUserLog(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UserLog ];

/// Foreign Key FKUserLogHosp created via DDL
ForeignKey FKUserLogHosp(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_UserLogHosp ];

/// Foreign Key FKUserLogLocation created via DDL
ForeignKey FKUserLogLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_UserLogLocation ];

/// Foreign Key FKUserLogMenu created via DDL
ForeignKey FKUserLogMenu(MenuDR) References dbo.SYSMenu(PKSYSMENU) [ SqlName = FK_UserLogMenu ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property SysCode As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 6 ];

Property Site As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

Property LogType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property MenuDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="SYSUserLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>SysCode</Value>
</Value>
<Value name="6">
<Value>Location</Value>
</Value>
<Value name="7">
<Value>IPAddress</Value>
</Value>
<Value name="8">
<Value>LogType</Value>
</Value>
<Value name="9">
<Value>WorkGroupDR</Value>
</Value>
<Value name="10">
<Value>LocationDR</Value>
</Value>
<Value name="11">
<Value>MenuDR</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>Site</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSUserLogD</DataLocation>
<DefaultData>SYSUserLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSUserLogD</IdLocation>
<IndexLocation>^dbo.SYSUserLogI</IndexLocation>
<StreamLocation>^dbo.SYSUserLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
