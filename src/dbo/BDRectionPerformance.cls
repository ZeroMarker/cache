///     
Class dbo.BDRectionPerformance Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_RectionPerformance, StorageStrategy = Default ]
{

/// Foreign Key FKBDRECTIADVER created via DDL
ForeignKey FKBDRECTIADVER(AdverseReactionDR) References dbo.BDAdverseReaction(PKBDADVERSEREACTION) [ SqlName = FK_BD_RECTI_ADVER ];

/// Foreign Key FKBDRECTIPER created via DDL
ForeignKey FKBDRECTIPER(PerformanceDR) References dbo.BBRectionPerformance(PKBBRECTIONPERFORMANCE) [ SqlName = FK_BD_RECTI_PER ];

Index IndexAdverseReaction On AdverseReactionDR [ SqlName = Index_AdverseReaction, Type = index ];

/// DDL Primary Key Specification
Index PKBDRECTIONPERFORMANCE On RowID [ PrimaryKey, SqlName = PK_BD_RECTIONPERFORMANCE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property AdverseReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property PerformanceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDRectionPerformanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>AdverseReactionDR</Value>
</Value>
<Value name="4">
<Value>PerformanceDR</Value>
</Value>
<Value name="5">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^dbo.BDRectionPerformanceD</DataLocation>
<DefaultData>BDRectionPerformanceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDRectionPerformanceD</IdLocation>
<IndexLocation>^dbo.BDRectionPerformanceI</IndexLocation>
<StreamLocation>^dbo.BDRectionPerformanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
