Class dbo.BDPerioOperateRecordItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PerioOperateRecordItem, StorageStrategy = Default ]
{

/// Foreign Key FKEvaluationItemResultBBTestItem created via DDL
ForeignKey FKPRIBBTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_PRI_BBTestItem ];

/// Foreign Key FKEvaluationItemResultTransEvaluation created via DDL
ForeignKey FKPRIPerioOpeRec(BDPerOpeRecordDR) References dbo.BDPerioOperateRecord(PKBDPerioOpeRecord) [ SqlName = FK_PRI_PerioOpeRec ];

/// DDL Primary Key Specification
Index IndexMaster On (BDPerOpeRecordDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BDPerOpeRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDPerioOperateRecordItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPerOpeRecordDR</Value>
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
</Data>
<DataLocation>^dbo.BDPerioOperateRecordItemD</DataLocation>
<DefaultData>BDPerioOperateRecordItemDefaultData</DefaultData>
<IdLocation>^dbo.BDPerioOperateRecordItemD</IdLocation>
<IndexLocation>^dbo.BDPerioOperateRecordItemI</IndexLocation>
<StreamLocation>^dbo.BDPerioOperateRecordItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
