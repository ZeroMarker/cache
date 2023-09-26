///     
Class dbo.BTEpisRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EpisRule ]
{

/// Foreign Key FKBTEpisRuleWorkGroupMachineDR created via DDL
ForeignKey FKBTEpisRuleWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_BTEpisRuleWorkGroupMachineDR ];

/// Foreign Key FKBTEpisRuleSYSRuleDR created via DDL
ForeignKey FKBTEpisRuleSYSRuleDR(SYSRuleDR) References dbo.SYSRuleNoBase(PKSYSRULENOBASE) [ SqlName = FK_BTEpisRuleSYSRuleDR ];

/// DDL Primary Key Specification
Index PKBTEPISRULE On RowID [ PrimaryKey, SqlName = PK_BT_EPISRULELAYOUT, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexMaster On (WorkGroupMachineDR, Code) [ SqlName = Index_Master, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property SYSRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property MTestSetGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property CTestSetGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property LocationGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property AdmTypeGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property TSUrgentGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

Property SpecimenGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

Property SttTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Priority As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BTEpisRuleDefaultData">
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
<Value>SYSRuleDR</Value>
</Value>
<Value name="6">
<Value>MTestSetGroup</Value>
</Value>
<Value name="7">
<Value>CTestSetGroup</Value>
</Value>
<Value name="8">
<Value>LocationGroup</Value>
</Value>
<Value name="9">
<Value>AdmTypeGroup</Value>
</Value>
<Value name="10">
<Value>TSUrgentGroup</Value>
</Value>
<Value name="11">
<Value>SpecimenGroup</Value>
</Value>
<Value name="12">
<Value>SttTime</Value>
</Value>
<Value name="13">
<Value>EndTime</Value>
</Value>
<Value name="14">
<Value>Priority</Value>
</Value>
<Value name="15">
<Value>PrintNum</Value>
</Value>
<Value name="16">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEpisRuleD</DataLocation>
<DefaultData>BTEpisRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTEpisRuleD</IdLocation>
<IndexLocation>^dbo.BTEpisRuleI</IndexLocation>
<StreamLocation>^dbo.BTEpisRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
