Class User.DHCMedInfectionRepDia Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRMR_Rowid, SqlTableName = DHC_MedInfectionRepDia, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIRMRChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfectionRep Parent Reference
Relationship MIRMRParRef As User.DHCMedInfectionRep [ Cardinality = parent, Inverse = ChildDHCMedInfectionRepDia, Required, SqlFieldName = MIRMR_ParRef ];

/// Child subscript
Property MIRMRChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),$c(1),1),"MR",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRMR_ChildSub ];

/// MIRMR_MrDia_DR
Property MIRMRMrDiaDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MIRMR_MrDia_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRMR_MrDia_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMedIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfectionRep.MIR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIRMR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfectionRep.MIR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIRMR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionRepDiaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
