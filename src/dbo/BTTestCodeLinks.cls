Class dbo.BTTestCodeLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeLinks ]
{

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

Index IndexDataMaster On (TestCodeDR, TCSCode) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexTCSCode On (TCSCode, TestCodeDR) [ SqlName = Index_TCSCode, Type = index, Unique ];

Index IndexTCSequence On (TestCodeDR, Sequence, TCSCode) [ SqlName = Index_TCSequence, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TCSCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property ResultDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property IsSameLabNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTestCodeLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>TCSCode</Value>
</Value>
<Value name="4">
<Value>ResultDays</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>IsSameLabNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeLinksD</DataLocation>
<DefaultData>BTTestCodeLinksDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeLinksD</IdLocation>
<IndexLocation>^dbo.BTTestCodeLinksI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
