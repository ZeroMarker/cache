/// 诊断分组
Class dbo.BBDiagnosisClassLink Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BB_DiagnosisClassLink ]
{

/// Foreign Key created via DDL
ForeignKey FKBBDiagnosisClassDR(BBDiagnosisClassDR) References dbo.BBDiagnosisClass(PKDiagnosisClassId) [ SqlName = FK_BB_DiagnosisClassDR ];

/// Foreign Key created via DDL
ForeignKey FKBBDiagnosisDR(BBDiagnosisDR) References dbo.BBDiagnosis(PKBBDiagnosis) [ SqlName = FK_BB_DiagnosisDR ];

Index IndexMaster On (BBDiagnosisClassDR, BBDiagnosisDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BBDiagnosisClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property BBDiagnosisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BBDiagnosisClassLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BBDiagnosisClassDR</Value>
</Value>
<Value name="3">
<Value>BBDiagnosisDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBDiagnosisClassLinkD</DataLocation>
<DefaultData>BBDiagnosisClassLinkDefaultData</DefaultData>
<IdLocation>^dbo.BBDiagnosisClassLinkD</IdLocation>
<IndexLocation>^dbo.BBDiagnosisClassLinkI</IndexLocation>
<StreamLocation>^dbo.BBDiagnosisClassLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
