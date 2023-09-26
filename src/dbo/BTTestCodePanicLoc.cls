Class dbo.BTTestCodePanicLoc Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodePanicLoc, StorageStrategy = Default ]
{

Index IndexMaster On (TestCodePanicDR, LocationDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTTestCodePanicSex created via DDL
ForeignKey FKBTTestCodePanicDR(TestCodePanicDR) References dbo.BTTestCodePanic(PKBTTESTCODEPANIC) [ SqlName = FK_BT_TestCodePanicDR ];

/// Foreign Key FKTestCodeRangesLoc created via DDL
ForeignKey FKBTTestCodePanicLocDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_BT_TestCodePanicLocDR ];

/// DDL Primary Key PKBTTestCodePanic
Index PKBTTESTCODEPANICLOC On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODEPANICLOC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodePanicDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTTestCodePanicLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodePanicDR</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodePanicLocD</DataLocation>
<DefaultData>BTTestCodePanicLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodePanicLocD</IdLocation>
<IndexLocation>^dbo.BTTestCodePanicLocI</IndexLocation>
<StreamLocation>^dbo.BTTestCodePanicLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
