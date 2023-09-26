/// 单病种用血明细
Class dbo.BSDiagnosisIssue Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_DiagnosisIssue ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSDiagnosisDR) References dbo.BSDiagnosis(PKDiagnosisId) [ SqlName = FK_BSDiagnosisDR ];

Index IndexMaster On (BSDiagnosisDR, IssueDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSDiagnosisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  发血单号
Property IssueDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

///  血袋ID
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

///  血液制品
Property ProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

///  血液制品
Property BloodCompontDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

///  血液制品
Property Volume As %Library.Float(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BSDiagnosisIssueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSDiagnosisDR</Value>
</Value>
<Value name="3">
<Value>IssueDR</Value>
</Value>
<Value name="4">
<Value>PackDR</Value>
</Value>
<Value name="5">
<Value>ProductDR</Value>
</Value>
<Value name="6">
<Value>BloodCompontDR</Value>
</Value>
<Value name="7">
<Value>Volume</Value>
</Value>
</Data>
<DataLocation>^dbo.BSDiagnosisIssueD</DataLocation>
<DefaultData>BSDiagnosisIssueDefaultData</DefaultData>
<IdLocation>^dbo.BSDiagnosisIssueD</IdLocation>
<IndexLocation>^dbo.BSDiagnosisIssueI</IndexLocation>
<StreamLocation>^dbo.BSDiagnosisIssueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
