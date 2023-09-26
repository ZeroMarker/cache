Class dbo.BTTestSetConclusion Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetConclusion ]
{

Index IndexMaster On (TestSetDR, Sequence) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKTestSetConclusionTS created via DDL
ForeignKey FKTestSetConclusionTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetConclusionTS ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Conclusion As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTestSetConclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>Conclusion</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetConclusionD</DataLocation>
<DefaultData>BTTestSetConclusionDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetConclusionD</IdLocation>
<IndexLocation>^dbo.BTTestSetConclusionI</IndexLocation>
<StreamLocation>^dbo.BTTestSetConclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
