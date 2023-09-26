Class dbo.BTTestSetTCResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetTCResult ]
{

Index IndexMaster On (TestSetDR, TestCodeDR, Sequence) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTESTSETTCRESULT On RowID [ PrimaryKey, SqlName = PK_BT_TESTSETTCRESULT, Type = index, Unique ];

/// Foreign Key FKTestSetLayoutTS created via DDL
ForeignKey FKTestSetTCResultTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetTCResultTS ];

/// Foreign Key FKTestSetLayoutTestCode created via DDL
ForeignKey FKTestSetTCResultTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestSetTCResultTestCode ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTestSetTCResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetTCResultD</DataLocation>
<DefaultData>BTTestSetTCResultDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetTCResultD</IdLocation>
<IndexLocation>^dbo.BTTestSetTCResultI</IndexLocation>
<StreamLocation>^dbo.BTTestSetTCResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
