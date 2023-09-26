Class dbo.BDReqAssessIndexResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReqAssessIndexResult ]
{

/// Foreign Key FKBDRFIRReqForm created via DDL
ForeignKey FKBDRAIRReqAssess(ReqAssessDR) References dbo.BDReqAssess(PKBDREQASSESS) [ SqlName = FK_BD_RAIR_ReqAssess ];

/// Foreign Key FKBDRFIRTestItem created via DDL
ForeignKey FKBDRAIRIndex(AssessIndexDR) References dbo.BBAssessIndex(PKBBASSESSINDEX) [ SqlName = FK_BD_RAIR_Index ];

Index IndexMaster On (ReqAssessDR, AssessIndexDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREQASSESSINDEXRESULT On RowID [ PrimaryKey, SqlName = PK_BD_REQASSESSINDEXRESULT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReqAssessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AssessIndexDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property IndexType As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 6 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BDReqAssessIndexResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqAssessDR</Value>
</Value>
<Value name="3">
<Value>AssessIndexDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>IndexType</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReqAssessIndexResultD</DataLocation>
<DefaultData>BDReqAssessIndexResultDefaultData</DefaultData>
<IdLocation>^dbo.BDReqAssessIndexResultD</IdLocation>
<IndexLocation>^dbo.BDReqAssessIndexResultI</IndexLocation>
<StreamLocation>^dbo.BDReqAssessIndexResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
