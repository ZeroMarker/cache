Class User.DHCSLGAIndsiItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SLGAIDSI_Rowid, SqlTableName = DHC_SLGAInDsiItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SLGAIDSIChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_SubLocGrpAllotItm Parent Reference
Relationship SLGADSISLGAIParref As User.DHCSubLocGrpAllotItm [ Cardinality = parent, Inverse = ChildDHCSLGAInDsiItm, Required, SqlFieldName = SLGAIDSI_SLGAI_Parref ];

/// SLGAIDSI_Childsub
Property SLGAIDSIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SLGAIDSI_Childsub ];

/// SLGAIDSI_Indsi_DR
Property SLGAIDSIIndsiDR As User.DHCInDispItm [ SqlColumnNumber = 3, SqlFieldName = SLGAIDSI_Indsi_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexIndsi">
<Global>^DHCSLGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_SubLocGrpAllot.SLGA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_SubLocGrpAllotItm.SLGAI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SLGAIDSI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INDSI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SLGAIDSI_Indsi_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocGrpAllot.SLGA_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocGrpAllotItm.SLGAI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{SLGAIDSI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="SLGAIDSI_Indsi_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSLGA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_SubLocGrpAllot.SLGA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_SubLocGrpAllotItm.SLGAI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SLGAIDSI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocGrpAllot.SLGA_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocGrpAllotItm.SLGAI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SLGAIDSI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSLGAIndsiItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
