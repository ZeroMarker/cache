///     
Class dbo.SYSTable Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Table, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexParentName On ParentName [ SqlName = Index_ParentName, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKSYSTABLE On RowID [ PrimaryKey, SqlName = PK_SYS_TABLE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

Property ParentName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSTableDefaultData">
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
<Value>Description</Value>
</Value>
<Value name="5">
<Value>ParentName</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSTableD</DataLocation>
<DefaultData>SYSTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSTableD</IdLocation>
<IndexLocation>^dbo.SYSTableI</IndexLocation>
<StreamLocation>^dbo.SYSTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
