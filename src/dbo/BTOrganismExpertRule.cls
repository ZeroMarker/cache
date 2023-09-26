///     
Class dbo.BTOrganismExpertRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismExpertRule ]
{

Index IndexSequence On (OrganismDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTOrganismExpertRuleOrganismDR created via DDL
ForeignKey FKBTOrganismExpertRuleOrganismDR(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_BTOrganismExpertRuleOrganismDR ];

/// Foreign Key FKBTOrganismExpertRuleHospitalDR created via DDL
ForeignKey FKBTOrganismExpertRuleHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTOrganismExpertRuleHospitalDR ];

/// DDL Primary Key Specification
Index PKBTORGANISMEXPERTRULE On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMEXPERTRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 5 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTOrganismExpertRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>EName</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrganismExpertRuleD</DataLocation>
<DefaultData>BTOrganismExpertRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTOrganismExpertRuleD</IdLocation>
<IndexLocation>^dbo.BTOrganismExpertRuleI</IndexLocation>
<StreamLocation>^dbo.BTOrganismExpertRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
