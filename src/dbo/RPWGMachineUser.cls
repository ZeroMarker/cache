Class dbo.RPWGMachineUser Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_WGMachineUser ]
{

Index IndexMaster On (WorkGroupMachineDR, AddDate) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKWGMachineAuthUser created via DDL
ForeignKey FKWGMachineRecUser(RecUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_WGMachineRecUser ];

/// Foreign Key FKWGMachineAuthUser created via DDL
ForeignKey FKWGMachineAcceptUser(AcceptUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_WGMachineAcceptUser ];

/// Foreign Key FKWGMachineAuthUser created via DDL
ForeignKey FKWGMachineAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_WGMachineAuthUser ];

/// Foreign Key FKWGMachineEntryUser created via DDL
ForeignKey FKWGMachineEntryUser(EntryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_WGMachineEntryUser ];

/// Foreign Key FKWGMachineWorkGroup created via DDL
ForeignKey FKWGMachineWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WGMachineWorkGroup ];

/// DDL Primary Key Specification
Index PKRPREPORTAUTHUSER On RowID [ PrimaryKey, SqlName = PK_RP_REPORTAUTHUSER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property RecUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AcceptUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property EntryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property OpenAutoAuth As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPWGMachineUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>RecUserDR</Value>
</Value>
<Value name="5">
<Value>AcceptUserDR</Value>
</Value>
<Value name="6">
<Value>EntryUserDR</Value>
</Value>
<Value name="7">
<Value>AuthUserDR</Value>
</Value>
<Value name="8">
<Value>OpenAutoAuth</Value>
</Value>
</Data>
<DataLocation>^dbo.RPWGMachineUserD</DataLocation>
<DefaultData>RPWGMachineUserDefaultData</DefaultData>
<IdLocation>^dbo.RPWGMachineUserD</IdLocation>
<IndexLocation>^dbo.RPWGMachineUserI</IndexLocation>
<StreamLocation>^dbo.RPWGMachineUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
