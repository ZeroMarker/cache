///     
Class dbo.BTOrgAntRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrgAntRule ]
{

/// Foreign Key FKRuleSpecType created via DDL
ForeignKey FKRuleSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_RuleSpecType ];

/// DDL Primary Key RUGenusDR
Index IndexMasterSP On (OrgWCode, AntiWCode, Sensitivity, SpecimenDR) [ SqlName = Index_MasterSP, Type = index, Unique ];

/// DDL Primary Key RUGenusDR
Index IndexMaster On (OrgWCode, AntiWCode, Sensitivity) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key CheckType
Index IndexCheckType On (OrgWCode, AntiWCode, CheckType, Sensitivity) [ SqlName = Index_CheckType, Type = index ];

/// DDL Primary Key Specification
Index PKBTORGANTRULE On RowID [ PrimaryKey, SqlName = PK_BT_ORGANTRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrgWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 3 ];

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
<Data name="BTOrgAntRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrgWCode</Value>
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
<DataLocation>^dbo.BTOrgAntRuleD</DataLocation>
<DefaultData>BTOrgAntRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTOrgAntRuleD</IdLocation>
<IndexLocation>^dbo.BTOrgAntRuleI</IndexLocation>
<StreamLocation>^dbo.BTOrgAntRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
