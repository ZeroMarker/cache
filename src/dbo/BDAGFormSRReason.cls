Class dbo.BDAGFormSRReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_AGFormSRReason ]
{

ForeignKey FKAGFormSRReasonAG(AgreeFormDR) References dbo.BDAgreeForm(PKBDAGREEFORM) [ SqlName = FK_AGFormSRReason_AG ];

/// Foreign Key FKAGAssessSpecies created via DDL
ForeignKey FKAGFormSRReasonSR(SpeReqReaDR) References dbo.BBSpecialReqReason(PKBBSPECIALREQREASON) [ SqlName = FK_AGFormSRReason_SR ];

Index IndexSpeReqRea On (AgreeFormDR, SpeReqReaDR) [ SqlName = Index_SpeReqRea, Type = index, Unique ];

Index IndexSeqNum On (AgreeFormDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDAGFORMSRREASON On RowID [ PrimaryKey, SqlName = PK_BD_AGFORMSRREASON, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 知情同意书DR  
Property AgreeFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 特殊用血原因  
Property SpeReqReaDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDAGFormSRReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AgreeFormDR</Value>
</Value>
<Value name="3">
<Value>SpeReqReaDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDAGFormSRReasonD</DataLocation>
<DefaultData>BDAGFormSRReasonDefaultData</DefaultData>
<IdLocation>^dbo.BDAGFormSRReasonD</IdLocation>
<IndexLocation>^dbo.BDAGFormSRReasonI</IndexLocation>
<StreamLocation>^dbo.BDAGFormSRReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
