///     
Class dbo.BTRUOrganismFamily Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRU_OrganismFamily ]
{

/// DDL Primary Key Specification
Index PKBTRUORGANISMFAMILY On RowID [ PrimaryKey, SqlName = PK_BTRU_ORGANISMFAMILY, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexBTCode On BTCode [ SqlName = Index_BTCode, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property BTCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTRUOrganismFamilyDefaultData">
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
<Value>BTCode</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRUOrganismFamilyD</DataLocation>
<DefaultData>BTRUOrganismFamilyDefaultData</DefaultData>
<IdLocation>^dbo.BTRUOrganismFamilyD</IdLocation>
<IndexLocation>^dbo.BTRUOrganismFamilyI</IndexLocation>
<StreamLocation>^dbo.BTRUOrganismFamilyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
