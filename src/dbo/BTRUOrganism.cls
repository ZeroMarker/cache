Class dbo.BTRUOrganism Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_Organism ]
{

/// Foreign Key FKRUOrganismGenus created via DDL
ForeignKey FKOrganismGenus(RUGenusDR) References dbo.BTRUGenus(PKBTRUGENUS) [ SqlName = FK_RUOrganismGenus ];

/// Foreign Key FKRUOrganismGroup created via DDL
ForeignKey FKOrganismGroup(RUOrganismGroupDR) References dbo.BTRUOrganismGroup(PKBTRUORGANISMGROUP) [ SqlName = FK_RUOrganismGroup ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexWCode On WCode [ SqlName = Index_WCode, Type = index ];

/// DDL Primary Key Specification
Index PKBTRUORGANISM On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property SName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property WCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property Gram As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

Property RUOrganismGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property RUGenusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property OrgGroup As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

Property OrgSubGroup As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 15 ];

Property UseNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property Positive As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BTRUOrganismDefaultData">
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
<Value>EName</Value>
</Value>
<Value name="5">
<Value>SName</Value>
</Value>
<Value name="6">
<Value>WCode</Value>
</Value>
<Value name="7">
<Value>Gram</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>RUOrganismGroupDR</Value>
</Value>
<Value name="10">
<Value>RUGenusDR</Value>
</Value>
<Value name="11">
<Value>OrgGroup</Value>
</Value>
<Value name="12">
<Value>OrgSubGroup</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
<Value name="14">
<Value>Active</Value>
</Value>
<Value name="15">
<Value>UseNum</Value>
</Value>
<Value name="16">
<Value>Positive</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRUOrganismD</DataLocation>
<DefaultData>BTRUOrganismDefaultData</DefaultData>
<IdLocation>^dbo.BTRUOrganismD</IdLocation>
<IndexLocation>^dbo.BTRUOrganismI</IndexLocation>
<StreamLocation>^dbo.BTRUOrganismS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
