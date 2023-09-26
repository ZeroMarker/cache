///     
Class dbo.BTSpecies Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Species, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexHISCode On HISCode [ SqlName = Index_HISCode, Type = index ];

/// DDL Primary Key Specification
Index PKBTSPECIES On RowID [ PrimaryKey, SqlName = PK_BT_SPECIES, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property Pregnant As %Library.Boolean [ SqlColumnNumber = 5 ];

Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

Property STDCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTSpeciesDefaultData">
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
<Value>Pregnant</Value>
</Value>
<Value name="5">
<Value>HISCode</Value>
</Value>
<Value name="6">
<Value>STDCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSpeciesD</DataLocation>
<DefaultData>BTSpeciesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTSpeciesD</IdLocation>
<IndexLocation>^dbo.BTSpeciesI</IndexLocation>
<StreamLocation>^dbo.BTSpeciesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
