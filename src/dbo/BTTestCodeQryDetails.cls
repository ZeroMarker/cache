Class dbo.BTTestCodeQryDetails Extends %Persistent [ ClassType = persistent, SqlTableName = BT_TestCodeQryDetails ]
{

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeCName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property Operate As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

Property Condition As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property TestCodeQryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

ForeignKey FKTestCodeQry(TestCodeQryDR) References dbo.BTTestCodeQry(PKBTTESTCODEQry);

Index PKBTTESTCODEQryDetails On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODEQryDetails, Type = index, Unique ];

Index IndexTestCodeQry On TestCodeQryDR [ SqlName = Index_TestCodeQry, Type = index ];

Storage Default
{
<Data name="BTTestCodeQryDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>TestCodeCName</Value>
</Value>
<Value name="4">
<Value>Operate</Value>
</Value>
<Value name="5">
<Value>Result</Value>
</Value>
<Value name="6">
<Value>Condition</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>TestCodeQryDR</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeQryDetailsD</DataLocation>
<DefaultData>BTTestCodeQryDetailsDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeQryDetailsD</IdLocation>
<IndexLocation>^dbo.BTTestCodeQryDetailsI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeQryDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
