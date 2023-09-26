Class dbo.BTTestCodeResColor Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeResColor ]
{

/// Foreign Key FKTestCodeDR created via DDL
ForeignKey FKTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeDR ];

Index IndexMaster On (TestCodeDR, Result, Color) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTESTCODERESCOLOR On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODERESCOLOR, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ Required, SqlColumnNumber = 4 ];

Property Color As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTestCodeResColorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
<Value name="4">
<Value>Color</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeResColorD</DataLocation>
<DefaultData>BTTestCodeResColorDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeResColorD</IdLocation>
<IndexLocation>^dbo.BTTestCodeResColorI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeResColorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
