///     
Class dbo.BTOrgFamilyAntRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrgFamilyAntRule ]
{

/// Foreign Key FKBTOrgFamilyAntRuleRUOrganismFamilyDR created via DDL
ForeignKey FKBTOrgFamilyAntRuleRUOrganismFamilyDR(RUOrganismFamilyDR) References dbo.BTRUOrganismFamily(PKBTRUORGANISMFAMILY) [ SqlName = FK_BTOrgFamilyAntRuleRUOrganismFamilyDR ];

/// Foreign Key FKRuleSpecType created via DDL
ForeignKey FKRuleSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_RuleSpecType ];

/// DDL Primary Key Specification
Index PKBTORGFAMILYANTRULE On RowID [ PrimaryKey, SqlName = PK_BT_ORGFAMILYANTRULE, Type = index, Unique ];

Index IndexMasterSP On (RUOrganismFamilyDR, AntiWCode, Sensitivity, SpecimenDR) [ SqlName = Index_MasterSP, Type = index, Unique ];

Index IndexMaster On (RUOrganismFamilyDR, AntiWCode, Sensitivity) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUOrganismFamilyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property Sensitivity As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 5 ];

Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

Property PromptType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Property Prompt As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTOrgFamilyAntRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUOrganismFamilyDR</Value>
</Value>
<Value name="3">
<Value>AntiWCode</Value>
</Value>
<Value name="4">
<Value>Sensitivity</Value>
</Value>
<Value name="5">
<Value>CheckType</Value>
</Value>
<Value name="6">
<Value>PromptType</Value>
</Value>
<Value name="7">
<Value>Prompt</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrgFamilyAntRuleD</DataLocation>
<DefaultData>BTOrgFamilyAntRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTOrgFamilyAntRuleD</IdLocation>
<IndexLocation>^dbo.BTOrgFamilyAntRuleI</IndexLocation>
<StreamLocation>^dbo.BTOrgFamilyAntRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
