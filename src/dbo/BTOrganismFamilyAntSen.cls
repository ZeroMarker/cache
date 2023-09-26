Class dbo.BTOrganismFamilyAntSen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismFamilyAntSen ]
{

/// Foreign Key FKOrganismFamilyAntSen created via DDL
ForeignKey FKOrganismFamilyAntSen(OrganismFamilyAntDR) References dbo.BTOrganismFamilyAnt(PKBTORGANISMFAMILYANT) [ SqlName = FK_OrganismFamilyAntSen ];

/// Foreign Key FKOrganismFamilyAntSenRes created via DDL
ForeignKey FKOrganismFamilyAntSenRes(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_OrganismFamilyAntSenRes ];

Index IndexMaster On (OrganismFamilyAntDR, SenMethod, SensitivityDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTORGANISMANTSEN On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMANTSEN, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrganismFamilyAntDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SenMethod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Operand As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 6 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTOrganismFamilyAntSenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrganismFamilyAntDR</Value>
</Value>
<Value name="3">
<Value>SenMethod</Value>
</Value>
<Value name="4">
<Value>SensitivityDR</Value>
</Value>
<Value name="5">
<Value>Operand</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrganismFamilyAntSenD</DataLocation>
<DefaultData>BTOrganismFamilyAntSenDefaultData</DefaultData>
<IdLocation>^dbo.BTOrganismFamilyAntSenD</IdLocation>
<IndexLocation>^dbo.BTOrganismFamilyAntSenI</IndexLocation>
<StreamLocation>^dbo.BTOrganismFamilyAntSenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
