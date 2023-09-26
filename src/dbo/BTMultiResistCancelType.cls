///     
Class dbo.BTMultiResistCancelType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_MultiResistCancelType ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTMULTIRESISTCANCELTYPE On RowID [ PrimaryKey, SqlName = PK_BT_MULTIRESISTCANCELTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTMultiResistCancelTypeDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMultiResistCancelTypeD</DataLocation>
<DefaultData>BTMultiResistCancelTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTMultiResistCancelTypeD</IdLocation>
<IndexLocation>^dbo.BTMultiResistCancelTypeI</IndexLocation>
<StreamLocation>^dbo.BTMultiResistCancelTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
