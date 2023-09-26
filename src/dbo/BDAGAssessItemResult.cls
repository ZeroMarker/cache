///     
Class dbo.BDAGAssessItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGAssessItemResult, StorageStrategy = Default ]
{

/// Foreign Key FKAGAssessTestItem1 created via DDL
ForeignKey FKAGAssessTestItem1(AGAssessDR) References dbo.BDAGAssess(PKBDAGASSESS) [ SqlName = FK_AGAssessTestItem1 ];

/// Foreign Key FKAGAssessTestItem2 created via DDL
ForeignKey FKAGAssessTestItem2(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_AGAssessTestItem2 ];

Index IndexMaster On (AGAssessDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDAGASSESSTESTITEM On RowID [ PrimaryKey, SqlName = PK_BD_AGASSESSTESTITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGAssessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property IsFit As %Library.Boolean [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDAGAssessItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGAssessDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>IsFit</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>AbFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGAssessItemResultD</DataLocation>
<DefaultData>BDAGAssessItemResultDefaultData</DefaultData>
<IdLocation>^dbo.BDAGAssessItemResultD</IdLocation>
<IndexLocation>^dbo.BDAGAssessItemResultI</IndexLocation>
<StreamLocation>^dbo.BDAGAssessItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
