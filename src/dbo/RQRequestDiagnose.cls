/// 申请诊断
Class dbo.RQRequestDiagnose Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RQ_RequestDiagnose, StorageStrategy = Default ]
{

/// Foreign Key FKRequestDiagnose created via DDL
ForeignKey FKRequestDiagnose(DiseaseDR) References dbo.BTDisease(PKBTDISEASE) [ SqlName = FK_RequestDiagnose ];

/// Foreign Key FKRequestDiagnoseReq created via DDL
ForeignKey FKRequestDiagnoseReq(RequestDR) References dbo.RQRequest(PKRQREQUEST) [ SqlName = FK_RequestDiagnoseReq ];

Index IndexMaster On (RequestDR, DiseaseDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (RequestDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKRQREQUESTDIAGNOSE On RowID [ PrimaryKey, SqlName = PK_RQ_REQUESTDIAGNOSE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单  
Property RequestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 诊断疾病  
Property DiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否是主诊断  {1:true,0:false}
Property MainDiag As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RQRequestDiagnoseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestDR</Value>
</Value>
<Value name="3">
<Value>DiseaseDR</Value>
</Value>
<Value name="4">
<Value>MainDiag</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RQRequestDiagnoseD</DataLocation>
<DefaultData>RQRequestDiagnoseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RQRequestDiagnoseD</IdLocation>
<IndexLocation>^dbo.RQRequestDiagnoseI</IndexLocation>
<StreamLocation>^dbo.RQRequestDiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
