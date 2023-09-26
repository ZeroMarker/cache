Class dbo.BTWGMRuleSpecimenNo Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WGMRuleSpecimenNo ]
{

Index IndexMaster On (WorkGroupMachineRuleDR, SpecimenDR) [ SqlName = IndexMaster, Type = index, Unique ];

/// Foreign Key FKWGMTSWorkGroupMachine created via DDL
ForeignKey FKWGMTSWorkGroupMachine(WorkGroupMachineRuleDR) References dbo.BTWorkGroupMachineRule(PKBTWorkGroupMachineRule) [ SqlName = FK_WGMTSWorkGroupMachine ];

/// Foreign Key FKWGMRuleSpecimen created via DDL
ForeignKey FKWGMRuleSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_WGMRuleSpecimen ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property EpisRuleID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTWGMRuleSpecimenNoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineRuleDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
<Value name="4">
<Value>EpisRuleID</Value>
</Value>
<Value name="5">
<Value>PrintNum</Value>
</Value>
<Value name="6">
<Value>VisitNumber</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWGMRuleSpecimenNoD</DataLocation>
<DefaultData>BTWGMRuleSpecimenNoDefaultData</DefaultData>
<IdLocation>^dbo.BTWGMRuleSpecimenNoD</IdLocation>
<IndexLocation>^dbo.BTWGMRuleSpecimenNoI</IndexLocation>
<StreamLocation>^dbo.BTWGMRuleSpecimenNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
