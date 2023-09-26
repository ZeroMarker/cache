Class User.DHCPhaCollectItmLB Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHACIL_Rowid, SqlTableName = DHC_PhaCollectItmLB, StorageStrategy = SQLStorage ]
{

/// d ##Class(User.DHCPhaCollectItmLB).%BuildIndices()
Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHACILChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHACollectItm Parent Reference
Relationship PHACILPHACIParref As User.DHCPHACollectItm [ Cardinality = parent, Inverse = ChildDHCPhaCollectItmLB, Required, SqlFieldName = PHACIL_PHACI_Parref ];

/// PHACIL_ChildSub
Property PHACILChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHACIL_ChildSub ];

/// PHACIL_INCLB_Dr
Property PHACILINCLBDr As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = PHACIL_INCLB_Dr ];

/// PHACIL_Qty
Property PHACILQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHACIL_Qty ];

/// PHACIL_Rp
Property PHACILRp As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHACIL_Rp ];

/// PHACIL_RpAmt
Property PHACILRpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHACIL_RpAmt ];

/// PHACIL_Sp
Property PHACILSp As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHACIL_Sp ];

/// PHACIL_SpAmt
Property PHACILSpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHACIL_SpAmt ];

/// 打包子表
Property PHACILDSPBDr As User.DHCOEDispBatch [ SqlColumnNumber = 9, SqlFieldName = PHACIL_DSPB_Dr ];

/// 本次冲减数
Property PHACILResQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PHACIL_ResQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDspBatch">
<Global>^DHCPHACi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_PHACollectItm.PHACI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHACIL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSPB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHACIL_DSPB_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHACollectItm.PHACI_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHACIL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="datamaster">
<Data name="PHACIL_DSPB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHACIL_INCLB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHACIL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHACIL_ResQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHACIL_Rp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHACIL_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHACIL_Sp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHACIL_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PHACollectItm.PHACI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHACIL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollectItm.PHACI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"B"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHACIL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaCollectItmLBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
