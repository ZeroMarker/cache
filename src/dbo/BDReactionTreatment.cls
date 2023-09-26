///     
Class dbo.BDReactionTreatment Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReactionTreatment ]
{

/// Foreign Key FKBDReactionTreatmentReactionDR created via DDL
ForeignKey FKBDReactionTreatmentReactionDR(ReactionDR) References dbo.BDReaction(PKBDREACTION) [ SqlName = FK_BDReactionTreatmentReactionDR ];

/// Foreign Key FKBDReactionTreatmentClinicalTreatmentDR created via DDL
ForeignKey FKBDReactionTreatmentClinicalTreatmentDR(ClinicalTreatmentDR) References dbo.BBClinicalTreatment(PKBBCLINICALTREATMENT) [ SqlName = FK_BDReactionTreatmentClinicalTreatmentDR ];

/// DDL Primary Key Specification
Index PKBDREACTIONTREATMENT On RowID [ PrimaryKey, SqlName = PK_BD_REACTIONTREATMENT, Type = index, Unique ];

Index IndexMaster On (ReactionDR, ClinicalTreatmentDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (ReactionDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ClinicalTreatmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDReactionTreatmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReactionDR</Value>
</Value>
<Value name="3">
<Value>ClinicalTreatmentDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReactionTreatmentD</DataLocation>
<DefaultData>BDReactionTreatmentDefaultData</DefaultData>
<IdLocation>^dbo.BDReactionTreatmentD</IdLocation>
<IndexLocation>^dbo.BDReactionTreatmentI</IndexLocation>
<StreamLocation>^dbo.BDReactionTreatmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
