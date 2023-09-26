///     
Class dbo.SYSUserAccessReport Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_UserAccessReport, StorageStrategy = Default ]
{

/// Foreign Key FKUserAccessReportUser created via DDL
ForeignKey FKUserAccessReportUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_UserAccessReportUser ];

/// Foreign Key FKUserAccessReportWg created via DDL
ForeignKey FKUserAccessReportWg(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_UserAccessReportWg ];

Index IndexMaster On (UserDR, WorkGroupDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSUSERACCESSREPORT On RowID [ PrimaryKey, SqlName = PK_SYS_USERACCESSREPORT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="SYSUserAccessReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSUserAccessReportD</DataLocation>
<DefaultData>SYSUserAccessReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSUserAccessReportD</IdLocation>
<IndexLocation>^dbo.SYSUserAccessReportI</IndexLocation>
<StreamLocation>^dbo.SYSUserAccessReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
