///     
Class dbo.BTEQAItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EQAItem, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexItemType On ItemType [ SqlName = Index_ItemType, Type = index ];

/// DDL Primary Key Specification
Index PKBTEQAITEM On RowID [ PrimaryKey, SqlName = PK_BT_EQAITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property EQACode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property ItemType As %Library.String(COLLATION = "Exact", MAXLEN = 4) [ SqlColumnNumber = 7 ];

Property Abbreviation As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTEQAItemDefaultData">
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
<Value>EQACode</Value>
</Value>
<Value name="6">
<Value>ItemType</Value>
</Value>
<Value name="7">
<Value>Abbreviation</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEQAItemD</DataLocation>
<DefaultData>BTEQAItemDefaultData</DefaultData>
<IdLocation>^dbo.BTEQAItemD</IdLocation>
<IndexLocation>^dbo.BTEQAItemI</IndexLocation>
<StreamLocation>^dbo.BTEQAItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
