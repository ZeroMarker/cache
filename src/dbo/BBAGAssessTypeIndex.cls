///     
Class dbo.BBAGAssessTypeIndex Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AGAssessTypeIndex, StorageStrategy = Default ]
{

/// Foreign Key FKAGAssessTypeIndex1 created via DDL
ForeignKey FKAGAssessTypeIndex1(AGAssessTypeDR) References dbo.BBAGAssessType(PKBBAGASSESSTYPE) [ SqlName = FK_AGAssessTypeIndex1 ];

/// Foreign Key FKAGAssessTypeIndex2 created via DDL
ForeignKey FKAGAssessTypeIndex2(AGAssessIndexDR) References dbo.BBAGAssessIndex(PKBBAGASSESSINDEX) [ SqlName = FK_AGAssessTypeIndex2 ];

Index IndexMaster On (AGAssessTypeDR, AGAssessIndexDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (AGAssessTypeDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBAGASSESSTYPEINDEX On RowID [ PrimaryKey, SqlName = PK_BB_AGASSESSTYPEINDEX, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AGAssessTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property AGAssessIndexDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBAGAssessTypeIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGAssessTypeDR</Value>
</Value>
<Value name="3">
<Value>AGAssessIndexDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAGAssessTypeIndexD</DataLocation>
<DefaultData>BBAGAssessTypeIndexDefaultData</DefaultData>
<IdLocation>^dbo.BBAGAssessTypeIndexD</IdLocation>
<IndexLocation>^dbo.BBAGAssessTypeIndexI</IndexLocation>
<StreamLocation>^dbo.BBAGAssessTypeIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
