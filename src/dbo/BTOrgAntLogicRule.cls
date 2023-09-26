///     
Class dbo.BTOrgAntLogicRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrgAntLogicRule ]
{

/// Foreign Key FKRuleSpecType created via DDL
ForeignKey FKRuleSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_RuleSpecType ];

/// DDL Primary Key RUGenusDR
Index IndexMasterSP On (OrgWCode, AntiWCode, Sensitivity, PerAntiWCode, PerSensitivity, SpecimenDR) [ SqlName = Index_MasterSP, Type = index ];

/// DDL Primary Key RUGenusDR
Index IndexMaster On (OrgWCode, AntiWCode, Sensitivity, PerAntiWCode, PerSensitivity) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTORGANTLOGICRULE On RowID [ PrimaryKey, SqlName = PK_BT_ORGANTLOGICRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrgWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 3 ];

Property AntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property Sensitivity As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 5 ];

Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

Property PerAntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property PerSensitivity As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 8 ];

Property Prompt As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BTOrgAntLogicRuleDefaultData">
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
<Value>PerAntiWCode</Value>
</Value>
<Value name="7">
<Value>PerSensitivity</Value>
</Value>
<Value name="8">
<Value>Prompt</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrgAntLogicRuleD</DataLocation>
<DefaultData>BTOrgAntLogicRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTOrgAntLogicRuleD</IdLocation>
<IndexLocation>^dbo.BTOrgAntLogicRuleI</IndexLocation>
<StreamLocation>^dbo.BTOrgAntLogicRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
