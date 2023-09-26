///     
Class dbo.BTAntibioticsKind Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AntibioticsKind ]
{

/// DDL Primary Key RUGenusDR
Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTANTIBIOTICSKIND On RowID [ PrimaryKey, SqlName = PK_BT_ANTIBIOTICSKIND, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property Component As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Generation As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTAntibioticsKindDefaultData">
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
<Value>Component</Value>
</Value>
<Value name="5">
<Value>Generation</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAntibioticsKindD</DataLocation>
<DefaultData>BTAntibioticsKindDefaultData</DefaultData>
<IdLocation>^dbo.BTAntibioticsKindD</IdLocation>
<IndexLocation>^dbo.BTAntibioticsKindI</IndexLocation>
<StreamLocation>^dbo.BTAntibioticsKindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
