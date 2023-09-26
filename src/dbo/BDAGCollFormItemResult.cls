///     
Class dbo.BDAGCollFormItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGCollFormItemResult, StorageStrategy = Default ]
{

/// Foreign Key FKAGCollFormItemResult1 created via DDL
ForeignKey FKAGCollFormItemResult1(AGCollectFormDR) References dbo.BDAGCollForm(PKBDAGCOLLFORM) [ SqlName = FK_AGCollFormItemResult1 ];

/// Foreign Key FKAGCollFormItemResult2 created via DDL
ForeignKey FKAGCollFormItemResult2(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_AGCollFormItemResult2 ];

/// Foreign Key FKAGCollFormItemResult3 created via DDL
ForeignKey FKAGCollFormItemResult3(ResultUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_AGCollFormItemResult3 ];

Index IndexMaster On (AGCollectFormDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDAGCOLLFORMITEMRESULT On RowID [ PrimaryKey, SqlName = PK_BD_AGCOLLFORMITEMRESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGCollectFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property ResultUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BDAGCollFormItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGCollectFormDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>ResultDate</Value>
</Value>
<Value name="8">
<Value>ResultTime</Value>
</Value>
<Value name="9">
<Value>ResultUserDR</Value>
</Value>
<Value name="10">
<Value>SeqNum</Value>
</Value>
<Value name="11">
<Value>AbFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGCollFormItemResultD</DataLocation>
<DefaultData>BDAGCollFormItemResultDefaultData</DefaultData>
<IdLocation>^dbo.BDAGCollFormItemResultD</IdLocation>
<IndexLocation>^dbo.BDAGCollFormItemResultI</IndexLocation>
<StreamLocation>^dbo.BDAGCollFormItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
