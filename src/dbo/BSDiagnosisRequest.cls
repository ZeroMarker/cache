/// 单病种申请单信息
Class dbo.BSDiagnosisRequest Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_DiagnosisRequest ]
{

/// Foreign Key created via DDL
ForeignKey FKTAT(BSDiagnosisDR) References dbo.BSDiagnosis(PKDiagnosisId) [ SqlName = FK_BLD_CT_REQ_Detalis_BLDRequestDR ];

Index IndexMaster On (BSDiagnosisDR, RequestDR, ProductDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property BSDiagnosisDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

///  申请单DR
Property RequestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

///  血液制品
Property ProductDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

///  申请单血型
Property BloodGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

///  输血目的
Property PorposeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

///  血液制品
Property Volume As %Library.Float(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BSDiagnosisRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSDiagnosisDR</Value>
</Value>
<Value name="3">
<Value>RequestDR</Value>
</Value>
<Value name="4">
<Value>ProductDR</Value>
</Value>
<Value name="5">
<Value>BloodGroupDR</Value>
</Value>
<Value name="6">
<Value>PorposeDR</Value>
</Value>
<Value name="7">
<Value>Volume</Value>
</Value>
</Data>
<DataLocation>^dbo.BSDiagnosisRequestD</DataLocation>
<DefaultData>BSDiagnosisRequestDefaultData</DefaultData>
<IdLocation>^dbo.BSDiagnosisRequestD</IdLocation>
<IndexLocation>^dbo.BSDiagnosisRequestI</IndexLocation>
<StreamLocation>^dbo.BSDiagnosisRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
