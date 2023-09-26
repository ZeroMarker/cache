Class dbo.BDTransRecTestItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_TransRecTestItem, StorageStrategy = Default ]
{

/// Foreign Key FKEvaluationItemResultBBTestItem created via DDL
ForeignKey FKBDTIBBTestItem(TestItemDR) References dbo.BBTestItem(PKBBTESTITEM) [ SqlName = FK_BDTI_BBTestItem ];

/// Foreign Key FKEvaluationItemResultTransEvaluation created via DDL
ForeignKey FKBDTIAutoTRec(TransRecordDR) References dbo.BDAutologousTransRecord(PKBDAUTOTRANSREC) [ SqlName = FK_BDTI_AutoTRec ];

/// DDL Primary Key Specification
Index IndexMaster On (TransRecordDR, TestItemDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TransRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDTransRecTestItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransRecordDR</Value>
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
<DataLocation>^dbo.BDTransRecTestItemD</DataLocation>
<DefaultData>BDTransRecTestItemDefaultData</DefaultData>
<IdLocation>^dbo.BDTransRecTestItemD</IdLocation>
<IndexLocation>^dbo.BDTransRecTestItemI</IndexLocation>
<StreamLocation>^dbo.BDTransRecTestItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
