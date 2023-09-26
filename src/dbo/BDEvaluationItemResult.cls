///     
Class dbo.BDEvaluationItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_EvaluationItemResult, StorageStrategy = Default ]
{

/// Foreign Key FKEvaluationItemResultBBTestItem created via DDL
ForeignKey FKEvaluationItemResultBBTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_EvaluationItemResult_BBTestItem ];

/// Foreign Key FKEvaluationItemResultSYSUser created via DDL
ForeignKey FKEvaluationItemResultSYSUser(ResultUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_EvaluationItemResult_SYSUser ];

/// Foreign Key FKEvaluationItemResultTransEvaluation created via DDL
ForeignKey FKEvaluationItemResultTransEvaluation(BDEvaluationDR) References dbo.BDTransEvaluation(PKBDTransEvaluation) [ SqlName = FK_EvaluationItemResult_TransEvaluation ];

/// DDL Primary Key Specification
Index IndexMaster On (BDEvaluationDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BDEvaluationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property ResultUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property Resflag As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 150) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BDEvaluationItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDEvaluationDR</Value>
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
<Value>Resflag</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDEvaluationItemResultD</DataLocation>
<DefaultData>BDEvaluationItemResultDefaultData</DefaultData>
<IdLocation>^dbo.BDEvaluationItemResultD</IdLocation>
<IndexLocation>^dbo.BDEvaluationItemResultI</IndexLocation>
<StreamLocation>^dbo.BDEvaluationItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
