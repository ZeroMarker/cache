/// 标本诊断
Class dbo.RPVisitNumberDiagnose Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberDiagnose, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberDiagnoseDiag created via DDL
ForeignKey FKVisitNumberDiagnoseDiag(DiseaseDR) References dbo.BTDisease(PKBTDISEASE) [ SqlName = FK_VisitNumberDiagnoseDiag ];

/// Foreign Key FKVisitNumberDiagnoseSpec created via DDL
ForeignKey FKVisitNumberDiagnoseSpec(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberDiagnoseSpec ];

Index IndexDiagnose On (DiseaseDR, RequestDate) [ SqlName = Index_Diagnose, Type = index ];

Index IndexMaster On (VisitNumberDR, DiseaseDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (VisitNumberDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERDIAGNOSE On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERDIAGNOSE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 疾病  
Property DiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否是主诊断  {1:true,0:false}
Property MainDiag As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 是否报告  {1:true,0:false}
Property Reported As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 诊断日期  
Property RequestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPVisitNumberDiagnoseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>DiseaseDR</Value>
</Value>
<Value name="4">
<Value>MainDiag</Value>
</Value>
<Value name="5">
<Value>Reported</Value>
</Value>
<Value name="6">
<Value>RequestDate</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberDiagnoseD</DataLocation>
<DefaultData>RPVisitNumberDiagnoseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberDiagnoseD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberDiagnoseI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberDiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
