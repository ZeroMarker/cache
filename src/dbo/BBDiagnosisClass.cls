/// 诊断分类
Class dbo.BBDiagnosisClass Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BB_DiagnosisClass ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKDiagnosisClassId On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBDiagnosisClassDefaultData">
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
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBDiagnosisClassD</DataLocation>
<DefaultData>BBDiagnosisClassDefaultData</DefaultData>
<IdLocation>^dbo.BBDiagnosisClassD</IdLocation>
<IndexLocation>^dbo.BBDiagnosisClassI</IndexLocation>
<StreamLocation>^dbo.BBDiagnosisClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
