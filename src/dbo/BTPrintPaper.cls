///     
Class dbo.BTPrintPaper Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_PrintPaper, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTPRINTPAPER On RowID [ PrimaryKey, SqlName = PK_BT_PRINTPAPER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property Height As %Library.Float [ SqlColumnNumber = 5 ];

Property Width As %Library.Float [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTPrintPaperDefaultData">
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
<Value>Height</Value>
</Value>
<Value name="5">
<Value>Width</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTPrintPaperD</DataLocation>
<DefaultData>BTPrintPaperDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTPrintPaperD</IdLocation>
<IndexLocation>^dbo.BTPrintPaperI</IndexLocation>
<StreamLocation>^dbo.BTPrintPaperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
