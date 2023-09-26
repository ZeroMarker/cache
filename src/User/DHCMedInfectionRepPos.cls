Class User.DHCMedInfectionRepPos Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRP_Rowid, SqlTableName = DHC_MedInfectionRepPos, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIRPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfectionRep Parent Reference
Relationship MIRPParRef As User.DHCMedInfectionRep [ Cardinality = parent, Inverse = ChildDHCMedInfectionRepPos, Required, SqlFieldName = MIRP_ParRef ];

/// Child subscript
Property MIRPChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),$c(1),1),"P",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRP_ChildSub ];

/// MIRP_InfPos_DR
Property MIRPInfPosDR As User.DHCMedInfPosition [ SqlColumnNumber = 3, SqlFieldName = MIRP_InfPos_DR ];

/// MIRP_InfDate
Property MIRPInfDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MIRP_InfDate ];

/// MIRP_InfDiag_DR
Property MIRPInfDiagDR As User.DHCMedInfDiagnose [ SqlColumnNumber = 5, SqlFieldName = MIRP_InfDiag_DR ];

/// MIRP_InroadOpr
Property MIRPInroadOpr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MIRP_InroadOpr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRP_InfDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIRP_InfDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIRP_InfPos_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIRP_InroadOpr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMedIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfectionRep.MIR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIRP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfectionRep.MIR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIRP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionRepPosS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
