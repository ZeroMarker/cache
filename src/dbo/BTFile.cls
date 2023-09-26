Class dbo.BTFile Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_File ]
{

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

//Property id As %Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ InitialExpression = {$i(^BTFILE($s($d(initvalue):initvalue,1:0)))}, Required, SqlColumnNumber = 10 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 3 ];

Property Remarks As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property CreateDat As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5 ];

Property FilePath As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property Tid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property FileFlag As %Library.Boolean [ SqlColumnNumber = 8 ];

Property Icon As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Index IndexTid On Tid [ SqlName = Index_Tid, Type = index ];

/// DDL Primary Key Specification
Index PKBTFiLE On RowID [ PrimaryKey, SqlName = PK_BT_FILE, Type = index, Unique ];

Storage Default
{
<Data name="BTFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>Remarks</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>FilePath</Value>
</Value>
<Value name="6">
<Value>Tid</Value>
</Value>
<Value name="7">
<Value>LevelNo</Value>
</Value>
<Value name="8">
<Value>Icon</Value>
</Value>
<Value name="9">
<Value>CreateDat</Value>
</Value>
<Value name="10">
<Value>id</Value>
</Value>
<Value name="11">
<Value>FileFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFileD</DataLocation>
<DefaultData>BTFileDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTFileD</IdLocation>
<IndexLocation>^dbo.BTFileI</IndexLocation>
<StreamLocation>^dbo.BTFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
