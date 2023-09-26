///     
Class dbo.BDReactionNature Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReactionNature, StorageStrategy = Default ]
{

/// Foreign Key FKBDREACTADVER created via DDL
ForeignKey FKBDREACTADVER(AdverseReactionDR) References dbo.BDAdverseReaction(PKBDADVERSEREACTION) [ SqlName = FK_BD_REACT_ADVER ];

/// Foreign Key FKBDREACTNATURE created via DDL
ForeignKey FKBDREACTNATURE(NatureDR) References dbo.BBReactionNature(PKBBREACTIONNATURE) [ SqlName = FK_BD_REACT_NATURE ];

Index IndexAdverseReaction On AdverseReactionDR [ SqlName = Index_AdverseReaction, Type = index ];

/// DDL Primary Key Specification
Index PKBDREACTIONNATURE On RowID [ PrimaryKey, SqlName = PK_BD_REACTIONNATURE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2 ];

Property AdverseReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property NatureDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BDReactionNatureDefaultData">
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
<Value>NatureDR</Value>
</Value>
<Value name="5">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReactionNatureD</DataLocation>
<DefaultData>BDReactionNatureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDReactionNatureD</IdLocation>
<IndexLocation>^dbo.BDReactionNatureI</IndexLocation>
<StreamLocation>^dbo.BDReactionNatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
