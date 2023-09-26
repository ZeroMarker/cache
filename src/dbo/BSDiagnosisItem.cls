Class dbo.BSDiagnosisItem Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_DiagnosisItem ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSDiagnosisDR) References dbo.BSDiagnosis(PKDiagnosisId) [ SqlName = FK_BLD_CT_REQ_Detalis_BLDRequestDR ];

Index IndexMaster On (BSDiagnosisDR, PackDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSDiagnosisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  血袋
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

///  血液制品
Property ProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

///  血液制品
Property BloodCompontDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

///  血液制品
Property Volume As %Library.Float(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BSDiagnosisItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSDiagnosisDR</Value>
</Value>
<Value name="3">
<Value>PackDR</Value>
</Value>
<Value name="4">
<Value>ProductDR</Value>
</Value>
<Value name="5">
<Value>BloodCompontDR</Value>
</Value>
<Value name="6">
<Value>Volume</Value>
</Value>
</Data>
<DataLocation>^dbo.BSDiagnosisItemD</DataLocation>
<DefaultData>BSDiagnosisItemDefaultData</DefaultData>
<IdLocation>^dbo.BSDiagnosisItemD</IdLocation>
<IndexLocation>^dbo.BSDiagnosisItemI</IndexLocation>
<StreamLocation>^dbo.BSDiagnosisItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
