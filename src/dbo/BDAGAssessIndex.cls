///     
Class dbo.BDAGAssessIndex Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGAssessIndex, StorageStrategy = Default ]
{

/// Foreign Key FKAGAssessIndex1 created via DDL
ForeignKey FKAGAssessIndex1(AGAssessDR) References dbo.BDAGAssess(PKBDAGASSESS) [ SqlName = FK_AGAssessIndex1 ];

/// Foreign Key FKAGAssessIndex2 created via DDL
ForeignKey FKAGAssessIndex2(AGAssessIndexDR) References dbo.BBAGAssessIndex(PKBBAGASSESSINDEX) [ SqlName = FK_AGAssessIndex2 ];

Index IndexMaster On (AGAssessDR, AGAssessIndexDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (AGAssessDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDAGASSESSINDEX On RowID [ PrimaryKey, SqlName = PK_BD_AGASSESSINDEX, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGAssessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AGAssessIndexDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BDAGAssessIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGAssessDR</Value>
</Value>
<Value name="3">
<Value>AGAssessIndexDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGAssessIndexD</DataLocation>
<DefaultData>BDAGAssessIndexDefaultData</DefaultData>
<IdLocation>^dbo.BDAGAssessIndexD</IdLocation>
<IndexLocation>^dbo.BDAGAssessIndexI</IndexLocation>
<StreamLocation>^dbo.BDAGAssessIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
