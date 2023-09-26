/// 登陆选择用户
Class dbo.SYSLoginSelectUser Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_LoginSelectUser ]
{

/// Foreign Key FKSYSLoginSelectUserWorkGroupDR created via DDL
ForeignKey FKSYSLoginSelectUserWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_SYSLoginSelectUserWorkGroupDR ];

/// Foreign Key FKSYSLoginSelectUserWorkGroupMachineDR created via DDL
ForeignKey FKSYSLoginSelectUserWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_SYSLoginSelectUserWorkGroupMachineDR ];

/// Foreign Key FKSYSLoginSelectUserUserDR created via DDL
ForeignKey FKSYSLoginSelectUserUserDR(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_SYSLoginSelectUserUserDR ];

/// DDL Primary Key Specification
Index PKSYSLOGINSELECTUSER On RowID [ PrimaryKey, SqlName = PK_SYS_LOGINSELECTUSER, Type = index ];

Index IndexWorkGroupDR On (WorkGroupDR, UserDR) [ SqlName = Index_WorkGroupDR, Type = index ];

Index IndexState On (WorkGroupDR, State, UserDR) [ SqlName = Index_State, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 状态  {2:初审,3:审核}
Property State As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 3 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 用户  
Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSLoginSelectUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>State</Value>
</Value>
<Value name="4">
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="6">
<Value>UserDR</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSLoginSelectUserD</DataLocation>
<DefaultData>SYSLoginSelectUserDefaultData</DefaultData>
<IdLocation>^dbo.SYSLoginSelectUserD</IdLocation>
<IndexLocation>^dbo.SYSLoginSelectUserI</IndexLocation>
<StreamLocation>^dbo.SYSLoginSelectUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
