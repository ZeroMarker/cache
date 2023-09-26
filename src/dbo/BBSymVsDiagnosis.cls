Class dbo.BBSymVsDiagnosis Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_SymVsDiagnosis, StorageStrategy = Default ]
{

/// Foreign Key FKBBSVDSymptom created via DDL
ForeignKey FKBBSVDSymptom(SymptomDR) References dbo.BBSymptom(PKBBSYMPTOM) [ SqlName = FK_BB_SVD_Symptom ];

Index IndexSym On SymptomDR [ SqlName = Index_Sym, Type = index ];

/// DDL Primary Key Specification
Index PKBBSYMPTOM On RowID [ PrimaryKey, SqlName = PK_BBSYMPTOM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property SymptomDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property DiagnoisDes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBSymVsDiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SymptomDR</Value>
</Value>
<Value name="3">
<Value>DiagnoisDes</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSymVsDiagnosisD</DataLocation>
<DefaultData>BBSymVsDiagnosisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBSymVsDiagnosisD</IdLocation>
<IndexLocation>^dbo.BBSymVsDiagnosisI</IndexLocation>
<StreamLocation>^dbo.BBSymVsDiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
