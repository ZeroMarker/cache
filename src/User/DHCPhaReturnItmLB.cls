Class User.DHCPhaReturnItmLB Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHARIL_Rowid, SqlTableName = DHC_PhaReturnItmLB, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHARILChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaReturnItm Parent Reference
Relationship PHARILPHARIParref As User.DHCPhaReturnItm [ Cardinality = parent, Inverse = ChildDHCPhaReturnItmLB, Required, SqlFieldName = PHARIL_PHARI_Parref ];

/// PHARIL_ChildSub
Property PHARILChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHARIL_ChildSub ];

/// PHARIL_INCLB_DR
Property PHARILINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = PHARIL_INCLB_DR ];

/// PHARIL_Qty
Property PHARILQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHARIL_Qty ];

/// PHARIL_Rp
Property PHARILRp As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHARIL_Rp ];

/// PHARIL_RpAmt
Property PHARILRpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHARIL_RpAmt ];

/// PHARIL_Sp
Property PHARILSp As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHARIL_Sp ];

/// PHARIL_SpAmt
Property PHARILSpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHARIL_SpAmt ];

/// 打包子表
Property PHARILDSPBDR As User.DHCOEDispBatch [ SqlColumnNumber = 9, SqlFieldName = PHARIL_DSPB_DR ];

/// 发药孙表
Property PHARILPHDICDR As User.DHCPhaCollectItmLB [ SqlColumnNumber = 10, SqlFieldName = PHARIL_PHDIC_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDspBatch">
<Global>^PHARETi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PhaReturn.PHAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_PhaReturnItm.PHARI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHARIL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSPB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHARIL_DSPB_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PhaReturn.PHAR_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PhaReturnItm.PHARI_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHARIL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhclbRowid">
<Global>^PHARETi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_PhaReturn.PHAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_PhaReturnItm.PHARI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHARIL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHDICDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHARIL_PHDIC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PhaReturn.PHAR_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PhaReturnItm.PHARI_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHARIL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="datamaster">
<Data name="PHARIL_DSPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHARIL_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHARIL_PHDIC_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHARIL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHARIL_Rp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHARIL_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHARIL_Sp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHARIL_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PHARET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaReturn.PHAR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PhaReturnItm.PHARI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHARIL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PhaReturn.PHAR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PhaReturnItm.PHARI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"B"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHARIL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaReturnItmLBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
