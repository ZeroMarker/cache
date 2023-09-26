///     
Class dbo.BBXMResultRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_XMResultRule, StorageStrategy = Default ]
{

/// Foreign Key FKBBXMRRLastResult created via DDL
ForeignKey FKBBXMRRLastResult(XMLastResultDR) References dbo.BBXMLastResult(PKBBXMLASTRESULT) [ SqlName = FK_BB_XMRR_LastResult ];

/// Foreign Key FKBBXMRRMajorConclusion created via DDL
ForeignKey FKBBXMRRMajorConclusion(MajorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BB_XMRR_MajorConclusion ];

/// Foreign Key FKBBXMRRMinorConclusion created via DDL
ForeignKey FKBBXMRRMinorConclusion(MinorXMConclusionDR) References dbo.BBXMConclusion(PKBBXMCONCLUSION) [ SqlName = FK_BB_XMRR_MinorConclusion ];

Index IndexMaster On (MajorXMConclusionDR, MinorXMConclusionDR, XMLastResultDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBXMRESULTRULE On RowID [ PrimaryKey, SqlName = PK_BB_XMRESULTRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property MajorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MinorXMConclusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property XMLastResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property IsDefault As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBXMResultRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MajorXMConclusionDR</Value>
</Value>
<Value name="3">
<Value>MinorXMConclusionDR</Value>
</Value>
<Value name="4">
<Value>XMLastResultDR</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.BBXMResultRuleD</DataLocation>
<DefaultData>BBXMResultRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBXMResultRuleD</IdLocation>
<IndexLocation>^dbo.BBXMResultRuleI</IndexLocation>
<StreamLocation>^dbo.BBXMResultRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
