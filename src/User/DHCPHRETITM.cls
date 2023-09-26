Class User.DHCPHRETITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHRTI_ROWID, SqlTableName = DHC_PHRETITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHRTICHILDSUB [ IdKey, PrimaryKey, Unique ];

/// DHC_PHRETURN Parent Reference
Relationship PHRTIPHRETPARREF As User.DHCPHRETURN [ Cardinality = parent, Inverse = ChildDHCPHRETITM, Required, SqlFieldName = PHRTI_PHRET_PARREF ];

/// PHRTI_CHILDSUB
Property PHRTICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHRTI_CHILDSUB ];

/// PHRTI_OEORI_DR
Property PHRTIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PHRTI_OEORI_DR ];

/// PHRTI_RETQTY
Property PHRTIRETQTY As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHRTI_RETQTY ];

/// PHRTI_UNIT_DR
Property PHRTIUNITDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = PHRTI_UNIT_DR ];

/// PHRTI_AMOUNT
Property PHRTIAMOUNT As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHRTI_AMOUNT ];

/// PHRTI_FRF_DR
Property PHRTIFRFDR As User.DHCINVOPRefReason [ SqlColumnNumber = 7, SqlFieldName = PHRTI_FRF_DR ];

/// PHRTI_PRICE
Property PHRTIPRICE As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PHRTI_PRICE ];

/// PHRTI_PHDI_DR
Property PHRTIPHDIDR As User.DHCPHDISITEM [ SqlColumnNumber = 10, SqlFieldName = PHRTI_PHDI_DR ];

/// PHRTI_Rp
Property PHRTIRp As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PHRTI_Rp ];

/// PHRTI_RpAmt
Property PHRTIRpAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PHRTI_RpAmt ];

/// 发票ID
Property PHRTIINV As User.DHCINVPRT [ SqlColumnNumber = 13, SqlFieldName = PHRTI_INV ];

/// 门诊发药孙表
Property PHRTIPHDICDR As User.DHCPHDISITMCLB [ SqlColumnNumber = 14, SqlFieldName = PHRTI_PHDIC_DR ];

/// 退药打包子表（对应R的那条）
Property PHRTIDSPBDR As User.DHCOEDispBatch [ SqlColumnNumber = 15, SqlFieldName = PHRTI_DSPB_DR ];

/// 科室库存批次
Property PHRTIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 16, SqlFieldName = PHRTI_INCLB_DR ];

/// 退药批号
Property PHRTIBatCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHRTI_BatCode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDspBatch">
<Global>^DHCPHRTIi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHRETURN.PHRET_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHRTI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSPB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHRTI_DSPB_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHRETURN.PHRET_ROWID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHRTI_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhdlbRowid">
<Global>^DHCPHRTIi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHRETURN.PHRET_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHRTI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHDICDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHRTI_PHDIC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHRETURN.PHRET_ROWID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHRTI_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHRETIoeori">
<Global>^DHCPHRTIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHRETURN.PHRET_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHRTI_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHRTI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ORDI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PHRETURN.PHRET_ROWID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHRTI_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHRTIMASTER">
<Data name="PHRTI_AMOUNT">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHRTI_BatCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHRTI_DSPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHRTI_FRF_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHRTI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHRTI_INV">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHRTI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHRTI_PHDIC_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHRTI_PHDI_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHRTI_PRICE">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHRTI_RETQTY">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHRTI_Rp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHRTI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHRTI_UNIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHRTI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHRETURN.PHRET_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHRTI_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHRETURN.PHRET_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RTI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHRTI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHRETITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
