///     
Class dbo.BBAutologousAssTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AutologousAssTestItem, StorageStrategy = Default ]
{

Index IndexMaster On Code [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBBAutologousAssTestItem On RowID [ PrimaryKey, SqlName = PK_BB_AutologousAssTestItem, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property SCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

Property LonicCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property ValueHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property ValueLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Property Units As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BBAutologousAssTestItemDefaultData">
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
<Value>SCode</Value>
</Value>
<Value name="5">
<Value>LonicCode</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>ValueHigh</Value>
</Value>
<Value name="8">
<Value>ValueLow</Value>
</Value>
<Value name="9">
<Value>SeqNum</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>Units</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAutologousAssTestItemD</DataLocation>
<DefaultData>BBAutologousAssTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BBAutologousAssTestItemD</IdLocation>
<IndexLocation>^dbo.BBAutologousAssTestItemI</IndexLocation>
<StreamLocation>^dbo.BBAutologousAssTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
