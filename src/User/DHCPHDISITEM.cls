Class User.DHCPHDISITEM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDI_ROWID, SqlTableName = DHC_PHDISITEM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHDICHILDSUB [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPHDISITMCLB As User.DHCPHDISITMCLB [ Cardinality = children, Inverse = PHDICPHDIPARREF ];

/// DHC_PHDISPEN Parent Reference
Relationship PHDIPHDPARREF As User.DHCPHDISPEN [ Cardinality = parent, Inverse = ChildDHCPHDISITEM, Required, SqlFieldName = PHDI_PHD_PARREF ];

/// PHDI_CHILDSUB
Property PHDICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHDI_CHILDSUB ];

/// PHDI_PAPMI_DR
Property PHDIPAPMIDR As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = PHDI_PAPMI_DR ];

/// PHDI_INCLB_DR
Property PHDIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 4, SqlFieldName = PHDI_INCLB_DR ];

/// PHDI_QTY
Property PHDIQTY As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHDI_QTY ];

/// PHDI_PAYAMOUNT
Property PHDIPAYAMOUNT As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHDI_PAYAMOUNT ];

/// PHDI_OEORI_DR
Property PHDIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 7, SqlFieldName = PHDI_OEORI_DR ];

/// phdi_rtqty
Property phdiretqty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = phdi_retqty ];

/// PHDI_CTLOC_DR
Property PHDICTLOCDR As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = PHDI_CTLOC_DR ];

/// PHDI_UNIT_DR
Property PHDIUNITDR As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = PHDI_UNIT_DR ];

/// PHDI_CFNO
Property PHDICFNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHDI_CFNO ];

/// PHDI_FYFLAG
Property PHDIFYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHDI_FYFLAG ];

/// PHDI_PRICE
Property PHDIPRICE As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PHDI_PRICE ];

/// 毒麻编号
Property PHDIPoisonMaBianNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHDI_PoisonMaBianNo ];

/// 配药完成标记
Property PHDIPYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHDI_PYFLAG ];

/// 摆药机发放标识
Property PHDIMachienDispFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 16, SqlFieldName = PHDI_MachienDisp_Flag ];

/// 医嘱发票
Property PHDIPRTDR As User.DHCINVPRT [ SqlColumnNumber = 17, SqlFieldName = PHDI_PRT_DR ];

/// PHDI_MachienDisp_Qty
Property PHDIMachienDispQty As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PHDI_MachienDisp_Qty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexOeori">
<Global>^DHCPHDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHDISPEN.PHD_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHDI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHDI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHDISPEN.PHD_ROWID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDI_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHDIMASTER">
<Data name="PHDI_CFNO">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHDI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHDI_FYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHDI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDI_MachienDisp_Flag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHDI_MachienDisp_Qty">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDI_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDI_PAYAMOUNT">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDI_PRICE">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHDI_PRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHDI_PYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHDI_PoisonMaBianNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHDI_QTY">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDI_UNIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="phdi_retqty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDISPEN.PHD_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHDI_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDISPEN.PHD_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PHDI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHDI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDISITEMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
