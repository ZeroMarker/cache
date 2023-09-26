///     
Class dbo.BDReactionPerformance Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReactionPerformance ]
{

/// Foreign Key FKBDReactionPerformanceReactionDR created via DDL
ForeignKey FKBDReactionPerformanceReactionDR(ReactionDR) References dbo.BDReaction(PKBDREACTION) [ SqlName = FK_BDReactionPerformanceReactionDR ];

/// Foreign Key FKBDReactionPerformancePerformanceDR created via DDL
ForeignKey FKBDReactionPerformancePerformanceDR(PerformanceDR) References dbo.BBRectionPerformance(PKBBRECTIONPERFORMANCE) [ SqlName = FK_BDReactionPerformancePerformanceDR ];

Index IndexMaster On (ReactionDR, PerformanceDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (ReactionDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBDREACTIONPERFORMANCE On RowID [ PrimaryKey, SqlName = PK_BD_REACTIONPERFORMANCE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PerformanceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDReactionPerformanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReactionDR</Value>
</Value>
<Value name="3">
<Value>PerformanceDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReactionPerformanceD</DataLocation>
<DefaultData>BDReactionPerformanceDefaultData</DefaultData>
<IdLocation>^dbo.BDReactionPerformanceD</IdLocation>
<IndexLocation>^dbo.BDReactionPerformanceI</IndexLocation>
<StreamLocation>^dbo.BDReactionPerformanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
