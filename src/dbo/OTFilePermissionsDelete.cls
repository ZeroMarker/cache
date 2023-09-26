Class dbo.OTFilePermissionsDelete Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FilePermissionsDelete ]
{

Index IndexWorkGroupDR On (WorkGroupDR, OTFileInfoDR) [ SqlName = Index_WorkGroupDR, Type = index, Unique ];

Index IndexGroupDR On (GroupDR, OTFileInfoDR) [ SqlName = Index_GroupDR, Type = index, Unique ];

Index IndexUserDR On (UserDR, OTFileInfoDR) [ SqlName = Index_UserDR, Type = index, Unique ];

/// Foreign Key FKOTFileInfoDR created via DDL
ForeignKey FKOTFileInfoDR(OTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OTFileInfoDR ];

/// Foreign Key FKWorkGroup created via DDL
ForeignKey FKWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroup ];

/// Foreign Key FKRightUser created via DDL
ForeignKey FKUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_User ];

/// Foreign Key FKGroupLinkModuleGrp created via DDL
ForeignKey FKGroupFilePermissions(GroupDR) References dbo.SYSGroup(PKSYSGROUP) [ SqlName = FK_GroupFilePermissions ];

/// DDL Primary Key Specification
Index PKOTFILEPERMISSION On RowID [ PrimaryKey, SqlName = PK_OT_FILEPERMISSION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property GroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AllowEdit As %Library.Boolean [ SqlColumnNumber = 7 ];

Property AllowDelete As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="OTFilePermissionsDeleteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTFileInfoDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
<Value name="4">
<Value>GroupDR</Value>
</Value>
<Value name="5">
<Value>UserDR</Value>
</Value>
<Value name="6">
<Value>AllowEdit</Value>
</Value>
<Value name="7">
<Value>AllowDelete</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFilePermissionsDeleteD</DataLocation>
<DefaultData>OTFilePermissionsDeleteDefaultData</DefaultData>
<IdLocation>^dbo.OTFilePermissionsDeleteD</IdLocation>
<IndexLocation>^dbo.OTFilePermissionsDeleteI</IndexLocation>
<StreamLocation>^dbo.OTFilePermissionsDeleteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
