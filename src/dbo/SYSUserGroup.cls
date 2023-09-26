/// 用户访问工作组
Class dbo.SYSUserGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_UserGroup, StorageStrategy = Default ]
{

Index IndexMaster On (UserDR, WorkGroupDR) [ SqlName = Index_Master, Type = index ];

Index IndexGroup On (UserDR, WorkGroupDR, GroupDR) [ SqlName = IndexGroup, Type = index ];

Index IndexPost On (UserDR, WorkGroupDR, GroupDR, PostDR) [ SqlName = IndexPost, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSUSERGROUP On RowID [ PrimaryKey, SqlName = PK_SYS_USERGROUP, Type = index, Unique ];

/// Foreign Key FKRightGroup created via DDL
ForeignKey FKRightGroup(GroupDR) References dbo.SYSGroup(PKSYSGROUP) [ SqlName = FK_RightGroup ];

/// Foreign Key FKRightUser created via DDL
ForeignKey FKRightUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RightUser ];

/// Foreign Key FKRightWGMachine created via DDL
ForeignKey FKRightWGMachine(DefWGMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RightWGMachine ];

/// Foreign Key FKRightWork created via DDL
ForeignKey FKRightWork(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RightWork ];

/// Foreign Key FKRightWork created via DDL
ForeignKey FKRightPost(PostDR) References dbo.SYSPost(PKSYSPOST) [ SqlName = FK_RightPost ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 用户  
Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 安全组  
Property GroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 是否默认  {1:true,0:false}
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 工作小组  
Property DefWGMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 报告状态  
Property WorkStatus As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// 岗位  
Property PostDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="SYSUserGroupDefaultData">
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
<Value>GroupDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>IsDefault</Value>
</Value>
<Value name="7">
<Value>DefWGMachineDR</Value>
</Value>
<Value name="8">
<Value>WorkStatus</Value>
</Value>
<Value name="9">
<Value>PostDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSUserGroupD</DataLocation>
<DefaultData>SYSUserGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSUserGroupD</IdLocation>
<IndexLocation>^dbo.SYSUserGroupI</IndexLocation>
<StreamLocation>^dbo.SYSUserGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
