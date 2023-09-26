Class User.DHCINAdjItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INADI_RowId, SqlTableName = DHC_INAdjItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INADIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INAdj Parent Reference
Relationship INADIINADParRef As User.DHCINAdj [ Cardinality = parent, Inverse = ChildDHCINAdjItm, Required, SqlFieldName = INADI_INAD_ParRef ];

/// INADI_ChildSub
Property INADIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = INADI_ChildSub ];

/// INADI_Qty
Property INADIQty As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INADI_Qty ];

/// INADI_INCLB_DR
Property INADIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 4, SqlFieldName = INADI_INCLB_DR ];

/// INADI_INSTI_DR
Property INADIINSTIDR As User.DHCInStkTkItm [ SqlColumnNumber = 5, SqlFieldName = INADI_INSTI_DR ];

/// INADI_UCost
Property INADIUCost As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = INADI_UCost ];

/// INADI_CTUOM_DR
Property INADICTUOMDR As User.CTUOM [ SqlColumnNumber = 7, SqlFieldName = INADI_CTUOM_DR ];

/// INADI_CTLOC_DR
Property INADICTLOCDR As User.CTLoc [ SqlColumnNumber = 8, SqlComputeCode = { s {INADI_CTLOC_DR}=$$CO09^at447({INADI_INCLB_DR})
}, SqlComputed, SqlFieldName = INADI_CTLOC_DR, Transient ];

/// pointer to In_AdjItm
Property INADIAdjItmDR As User.INAdjItm [ SqlColumnNumber = 9, SqlFieldName = INADI_AdjItm_DR ];

/// INADI_QtyBUom
Property INADIQtyBUom As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INADI_QtyBUom ];

/// INADI_SPAmt
Property INADISPAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INADI_SPAmt ];

/// INADI_RP
Property INADIRP As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INADI_RP ];

/// INADI_RPAmt
Property INADIRPAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INADI_RPAmt ];

/// 备注
Property INADIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INADI_Remark ];

/// 调整原因
Property INADIReasonAdjDR As User.INCReasonForAdjustment [ SqlColumnNumber = 15, SqlFieldName = INADI_ReasonAdj_DR ];

/// INADI_ResultQty   //调后数量
Property INADIResultQty As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INADI_ResultQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterINADI">
<Data name="INADI_AdjItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INADI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INADI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INADI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INADI_INSTI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INADI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INADI_QtyBUom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INADI_RP">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INADI_RPAmt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INADI_ReasonAdj_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INADI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INADI_ResultQty">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INADI_SPAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INADI_UCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INAdj.INAD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INADI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INAdj.INAD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdjItmDr">
<Global>^DHCINAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INAdj.INAD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INADI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INADJITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADI_AdjItm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_INAdj.INAD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INADI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^DHCINAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INAdj.INAD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INADI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_INAdj.INAD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INADI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINAdjItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
