Class dbo.QCEQALoseAnalysis Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQALoseAnalysis, StorageStrategy = Default ]
{

Index IndexMaster On EQASampleResultDR [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKQCEQALoseAnalysis On RowID [ PrimaryKey, SqlName = PK_QC_EQALoseAnalysis, Type = index, Unique ];

/// Foreign Key FKBTEQAItemPlanEQAItem created via DDL
ForeignKey FKQCEQALoseAnalysisEQASampleResult(EQASampleResultDR) References dbo.QCEQASampleResult(PKQCEQASAMPLEResult) [ SqlName = FK_QC_EQALoseAnalysis_EQASampleResult ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EQASampleResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TargetResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property Reasons As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 5 ];

Property ElseReason As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 6 ];

Property IsControl As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Property IsAffect As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

Property Measures As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="QCEQALoseAnalysisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EQASampleResultDR</Value>
</Value>
<Value name="3">
<Value>TargetResult</Value>
</Value>
<Value name="4">
<Value>Reasons</Value>
</Value>
<Value name="5">
<Value>ElseReason</Value>
</Value>
<Value name="6">
<Value>IsControl</Value>
</Value>
<Value name="7">
<Value>IsAffect</Value>
</Value>
<Value name="8">
<Value>Measures</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQALoseAnalysisD</DataLocation>
<DefaultData>QCEQALoseAnalysisDefaultData</DefaultData>
<IdLocation>^dbo.QCEQALoseAnalysisD</IdLocation>
<IndexLocation>^dbo.QCEQALoseAnalysisI</IndexLocation>
<StreamLocation>^dbo.QCEQALoseAnalysisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
