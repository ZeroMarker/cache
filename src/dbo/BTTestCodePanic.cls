Class dbo.BTTestCodePanic Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodePanic, StorageStrategy = Default ]
{

Index IndexMaster On (TestCodeDR, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTTestCodePanicSex created via DDL
ForeignKey FKBTTestCodePanicSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_BTTestCodePanicSex ];

/// Foreign Key FKBTTestCodePanicTC created via DDL
ForeignKey FKBTTestCodePanicTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTTestCodePanicTC ];

/// DDL Primary Key PKBTTestCodePanic
Index PKBTTESTCODEPANIC On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODEPANIC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AgeLow As %Library.Float [ Required, SqlColumnNumber = 6 ];

Property AgeHigh As %Library.Float [ Required, SqlColumnNumber = 7 ];

Property ValueLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Property ValueHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property TxtRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property StorageRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

Property RangeType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BTTestCodePanicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>SpeciesDR</Value>
</Value>
<Value name="5">
<Value>AgeLow</Value>
</Value>
<Value name="6">
<Value>AgeHigh</Value>
</Value>
<Value name="7">
<Value>ValueLow</Value>
</Value>
<Value name="8">
<Value>ValueHigh</Value>
</Value>
<Value name="9">
<Value>TxtRanges</Value>
</Value>
<Value name="10">
<Value>StorageRanges</Value>
</Value>
<Value name="11">
<Value>RangeType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodePanicD</DataLocation>
<DefaultData>BTTestCodePanicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodePanicD</IdLocation>
<IndexLocation>^dbo.BTTestCodePanicI</IndexLocation>
<StreamLocation>^dbo.BTTestCodePanicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
