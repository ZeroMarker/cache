///     
Class dbo.BTOrgFamilyExpertRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrgFamilyExpertRule ]
{

Index IndexSequence On (OrganismFamilyDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTOrgFamilyExpertRuleOrganismFamilyDR created via DDL
ForeignKey FKBTOrgFamilyExpertRuleOrganismFamilyDR(OrganismFamilyDR) References dbo.BTOrganismFamily(PKBTORGANISMFAMILY) [ SqlName = FK_BTOrgFamilyExpertRuleOrganismFamilyDR ];

/// Foreign Key FKBTOrgFamilyExpertRuleHospitalDR created via DDL
ForeignKey FKBTOrgFamilyExpertRuleHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTOrgFamilyExpertRuleHospitalDR ];

/// DDL Primary Key Specification
Index PKBTORGFAMILYEXPERTRULE On RowID [ PrimaryKey, SqlName = PK_BT_ORGFAMILYEXPERTRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrganismFamilyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 5 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTOrgFamilyExpertRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismFamilyDR</Value>
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
<DataLocation>^dbo.BTOrgFamilyExpertRuleD</DataLocation>
<DefaultData>BTOrgFamilyExpertRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTOrgFamilyExpertRuleD</IdLocation>
<IndexLocation>^dbo.BTOrgFamilyExpertRuleI</IndexLocation>
<StreamLocation>^dbo.BTOrgFamilyExpertRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
