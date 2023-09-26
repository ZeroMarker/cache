Class dbo.BDReactionDrug Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_ReactionDrug, StorageStrategy = Default ]
{

/// Foreign Key FKBBRTestItemHospital created via DDL
ForeignKey FKBDRDRection(ReactionDR) References dbo.BDReaction(PKBDREACTION) [ SqlName = FK_BD_RD_Rection ];

/// Foreign Key FKBBRTestItemReqType created via DDL
ForeignKey FKBDRDRectionDrug(DrugDR) References dbo.BBReactionDrug(PKBBRECTIONDRUG) [ SqlName = FK_BD_RD_RectionDrug ];

Index IndexMaster On (ReactionDR, DrugDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDREACTIONDRUG On RowID [ PrimaryKey, SqlName = PK_BDREACTION_DRUG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReactionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property DrugDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BDReactionDrugDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReactionDR</Value>
</Value>
<Value name="3">
<Value>DrugDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDReactionDrugD</DataLocation>
<DefaultData>BDReactionDrugDefaultData</DefaultData>
<IdLocation>^dbo.BDReactionDrugD</IdLocation>
<IndexLocation>^dbo.BDReactionDrugI</IndexLocation>
<StreamLocation>^dbo.BDReactionDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
