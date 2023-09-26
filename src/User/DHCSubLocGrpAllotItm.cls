Class User.DHCSubLocGrpAllotItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SLGAI_Rowid, SqlTableName = DHC_SubLocGrpAllotItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SLGAIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship SLGAISLGAParref As User.DHCSubLocGrpAllot [ Cardinality = parent, Inverse = ChildDHCSubLocGrpAllotItm, Required, SqlFieldName = SLGAI_SLGA_Parref ];

Relationship ChildDHCSLGAInDsiItm As User.DHCSLGAIndsiItm [ Cardinality = children, Inverse = SLGADSISLGAIParref ];

/// SLGAI_Childsub
Property SLGAIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SLGAI_Childsub ];

/// SLGAI_INCI_DR
Property SLGAIINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = SLGAI_INCI_DR ];

/// SLGAI_Qty
Property SLGAIQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SLGAI_Qty ];

/// SLGAI_UOM_DR
Property SLGAIUOMDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = SLGAI_UOM_DR ];

/// SLGAI_SpAmt
Property SLGAIRpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SLGAI_RpAmt ];

/// SLGAI_RpAmt
Property SLGAISpAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SLGAI_SpAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterMap">
<Data name="SLGAI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SLGAI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLGAI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SLGAI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SLGAI_UOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSLGA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_SubLocGrpAllot.SLGA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SLGAI_Childsub</Field>
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
<Expression>{SLGAI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSubLocGrpAllotItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
