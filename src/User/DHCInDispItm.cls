Class User.DHCInDispItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDSI_Rowid, SqlTableName = DHC_InDispItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INDSIChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_InDisp Parent Reference
Relationship INDSIINDSParref As User.DHCInDisp [ Cardinality = parent, Inverse = ChildDHCInDispItm, Required, SqlFieldName = INDSI_INDS_Parref ];

/// INDSI_Childsub
Property INDSIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = INDSI_Childsub ];

/// INDSI_Qty
Property INDSIQty As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INDSI_Qty ];

/// INDSI_INCLB_DR
Property INDSIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 4, SqlFieldName = INDSI_INCLB_DR ];

/// INDSI_CTUOM_DR
Property INDSICTUOMDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = INDSI_CTUOM_DR ];

/// INDSI_Remarks
Property INDSIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INDSI_Remarks ];

/// INDSI_CTLOC_DR
Property INDSICTLOCDR As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = INDSI_CTLOC_DR ];

/// Real Price
Property INDSIUCost As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INDSI_UCost ];

/// INDSI_ConsReason_DR
Property INDSIConsReasonDR As User.INCConsumptionReason [ SqlColumnNumber = 10, SqlFieldName = INDSI_ConsReason_DR ];

/// INDSI_AmountSoldFor
Property INDSIAmountSoldFor As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INDSI_AmountSoldFor ];

/// INDSI_CompanySoldTo_DR
Property INDSICompanySoldToDR As User.CTCompany [ SqlColumnNumber = 12, SqlFieldName = INDSI_CompanySoldTo_DR ];

/// INDSI_ReceiveUser_DR
Property INDSIReceiveUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = INDSI_ReceiveUser_DR ];

/// INDSI_SalePrice
Property INDSISalePrice As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INDSI_SalePrice ];

/// INDSI_RQI_DR
Property INDSIRQIDR As User.DHCINDispReqItm [ SqlColumnNumber = 15, SqlFieldName = INDSI_RQI_DR ];

/// INDSI_RpAmt
Property INDSIRpAmt As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INDSI_RpAmt ];

/// INDSI_RetQty
Property INDSIRetQty As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INDSI_RetQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INDSI_AmountSoldFor">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDSI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDSI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDSI_CompanySoldTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDSI_ConsReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDSI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDSI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDSI_RQI_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDSI_ReceiveUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDSI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDSI_RetQty">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDSI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDSI_SalePrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDSI_UCost">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINDS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InDisp.INDS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INDSI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InDisp.INDS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DSI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDSI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCLB">
<Global>^DHCINDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InDisp.INDS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INDSI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INDSI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_InDisp.INDS_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INDSI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRQI">
<Global>^DHCINDS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InDisp.INDS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INDSI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INDSI_RQI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_InDisp.INDS_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INDSI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserItm">
<Global>^DHCINDS</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_InDisp.INDS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INDSI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"USERITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INDSI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INDSI_ReceiveUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{INDSI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHC_InDisp.INDS_Rowid}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{INDSI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInDispItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
