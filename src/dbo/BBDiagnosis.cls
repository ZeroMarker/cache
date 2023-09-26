/// 诊断
Class dbo.BBDiagnosis Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BB_Diagnosis ]
{

/// DDL Primary Key Specification
Index PKBBDiagnosis On RowID [ PrimaryKey, SqlName = PK_BB_Diagnosis, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBDiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HISCode</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBDiagnosisD</DataLocation>
<DefaultData>BBDiagnosisDefaultData</DefaultData>
<IdLocation>^dbo.BBDiagnosisD</IdLocation>
<IndexLocation>^dbo.BBDiagnosisI</IndexLocation>
<StreamLocation>^dbo.BBDiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
