Class dbo.BTWorkGroupMachineRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupMachineRule ]
{

Index IndexMaster On (WorkGroupMachineDR, Code) [ SqlName = IndexMaster, Type = index ];

Index IndexCode On (WorkGroupMachineDR, Code, IsShow) [ SqlName = IndexCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTWorkGroupMachineRule On RowID [ PrimaryKey, SqlName = PK_BT_WorkGroupMachineRule, Type = index, Unique ];

/// Foreign Key FKWGMRuleWorkGroupMachine created via DDL
ForeignKey FKWGMRuleWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WGMRuleWorkGroupMachine ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 400) [ Required, SqlColumnNumber = 4 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property IsShow As %Library.Boolean [ SqlColumnNumber = 6 ];

Property EpisRuleID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTWorkGroupMachineRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="5">
<Value>IsShow</Value>
</Value>
<Value name="6">
<Value>EpisRuleID</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>PrintNum</Value>
</Value>
<Value name="9">
<Value>VisitNumber</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupMachineRuleD</DataLocation>
<DefaultData>BTWorkGroupMachineRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTWorkGroupMachineRuleD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupMachineRuleI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupMachineRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
