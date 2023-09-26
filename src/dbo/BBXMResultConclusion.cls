///     
Class dbo.BBXMResultConclusion Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_XMResultConclusion, StorageStrategy = Default ]
{

/// Foreign Key FKBBXMRCConclusion created via DDL
ForeignKey FKBBXMRCConclusion(XMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BB_XMRC_Conclusion ];

/// Foreign Key FKBBXMRCResult created via DDL
ForeignKey FKBBXMRCResult(XMResultDR) References dbo.BBXMResult(PKBBXMRESULT) [ SqlName = FK_BB_XMRC_Result ];

Index IndexMaster On (XMResultDR, XMConclusionDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBBXMRESULTCONCLUSION On RowID [ PrimaryKey, SqlName = PK_BB_XMRESULTCONCLUSION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property XMResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property XMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BBXMResultConclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XMResultDR</Value>
</Value>
<Value name="3">
<Value>XMConclusionDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.BBXMResultConclusionD</DataLocation>
<DefaultData>BBXMResultConclusionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBXMResultConclusionD</IdLocation>
<IndexLocation>^dbo.BBXMResultConclusionI</IndexLocation>
<StreamLocation>^dbo.BBXMResultConclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
