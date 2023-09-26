///     
Class dbo.BTEpisRuleLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EpisRuleLink ]
{

/// Foreign Key FKBTEpisRuleLinkEpisRuleDR created via DDL
ForeignKey FKBTEpisRuleLinkEpisRuleDR(EpisRuleDR) References dbo.BTEpisRule(PKBTEPISRULE) [ SqlName = FK_BTEpisRuleLinkEpisRuleDR ];

/// DDL Primary Key Specification
Index PKBTEPISRULELINK On RowID [ PrimaryKey, SqlName = PK_BT_EPISRULELINK, Type = index, Unique ];

Index IndexMaster On (EpisRuleDR, EpisRuleLinkGroup) [ SqlName = Index_Master, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EpisRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property EpisRuleLinkGroup As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property SameEpis As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTEpisRuleLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisRuleDR</Value>
</Value>
<Value name="3">
<Value>EpisRuleLinkGroup</Value>
</Value>
<Value name="4">
<Value>SameEpis</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEpisRuleLinkD</DataLocation>
<DefaultData>BTEpisRuleLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTEpisRuleLinkD</IdLocation>
<IndexLocation>^dbo.BTEpisRuleLinkI</IndexLocation>
<StreamLocation>^dbo.BTEpisRuleLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
