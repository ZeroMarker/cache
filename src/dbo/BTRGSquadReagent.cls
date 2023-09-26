///     
Class dbo.BTRGSquadReagent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_SquadReagent, StorageStrategy = Default ]
{

/// Foreign Key FKRGSquadReagentReagent created via DDL
ForeignKey FKRGSquadReagentReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_SquadReagent_Reagent ];

/// Foreign Key FKRGSquadReagentSquad created via DDL
ForeignKey FKRGSquadReagentSquad(SquadDR) References dbo.BTRGSquad(PKBTRGSQUAD) [ SqlName = FK_RG_SquadReagent_Squad ];

Index IndexSquadReagentMaster On (SquadDR, ReagentDR) [ SqlName = Index_SquadReagent_Master, Type = index, Unique ];

Index IndexSquadReagentSequence On (SquadDR, Sequence) [ SqlName = Index_SquadReagent_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGSQUADREAGENT On RowID [ PrimaryKey, SqlName = PK_BTRG_SQUADREAGENT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property SquadDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTRGSquadReagentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SquadDR</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGSquadReagentD</DataLocation>
<DefaultData>BTRGSquadReagentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGSquadReagentD</IdLocation>
<IndexLocation>^dbo.BTRGSquadReagentI</IndexLocation>
<StreamLocation>^dbo.BTRGSquadReagentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
