Class dbo.BDEvaluationPack Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_EvaluationPack, StorageStrategy = Default ]
{

/// Foreign Key FKEvaluationItemResultBBTestItem created via DDL
ForeignKey FKEvaluationPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_Evaluation_Pack ];

/// Foreign Key FKEvaluationItemResultTransEvaluation created via DDL
ForeignKey FKEvaluation(BDEvaluationDR) References dbo.BDTransEvaluation(PKBDTransEvaluation) [ SqlName = FK_Evaluation ];

/// DDL Primary Key Specification
Index IndexMaster On (BDEvaluationDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BDEvaluationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDEvaluationPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDEvaluationDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDEvaluationPackD</DataLocation>
<DefaultData>BDEvaluationPackDefaultData</DefaultData>
<IdLocation>^dbo.BDEvaluationPackD</IdLocation>
<IndexLocation>^dbo.BDEvaluationPackI</IndexLocation>
<StreamLocation>^dbo.BDEvaluationPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
