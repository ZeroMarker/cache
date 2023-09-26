Class dbo.QCEQALoseAnalysisSub Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQALoseAnalysisSub, StorageStrategy = Default ]
{

Index IndexMaster On EQALoseAnalysisDR [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKQCEQALoseAnalysisSub On RowID [ PrimaryKey, SqlName = PK_QC_EQALoseAnalysisSub, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EQALoseAnalysisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Label As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

Property EstimateResult As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="QCEQALoseAnalysisSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EQALoseAnalysisDR</Value>
</Value>
<Value name="3">
<Value>Label</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>EstimateResult</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQALoseAnalysisSubD</DataLocation>
<DefaultData>QCEQALoseAnalysisSubDefaultData</DefaultData>
<IdLocation>^dbo.QCEQALoseAnalysisSubD</IdLocation>
<IndexLocation>^dbo.QCEQALoseAnalysisSubI</IndexLocation>
<StreamLocation>^dbo.QCEQALoseAnalysisSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
