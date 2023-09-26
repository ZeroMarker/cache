Class User.DHCINSpItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSPI_Rowid, SqlTableName = DHC_INSpItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INSPIChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_INScrap Parent Reference
Relationship INSPIParref As User.DHCINScrap [ Cardinality = parent, Inverse = ChildDHCINSpItm, Required, SqlFieldName = INSPI_Parref ];

/// INSPI_Childsub
Property INSPIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = INSPI_Childsub ];

/// INSPI_INCLB_DR
Property INSPIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = INSPI_INCLB_DR ];

/// INSPI_CTUOM_DR
Property INSPICTUOMDR As User.CTUOM [ SqlColumnNumber = 4, SqlFieldName = INSPI_CTUOM_DR ];

/// INSPI_Qty
Property INSPIQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INSPI_Qty ];

/// INSPI_Rp
Property INSPIRp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INSPI_Rp ];

/// INSPI_RpAmt
Property INSPIRpAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INSPI_RpAmt ];

/// INSPI_Pp
Property INSPIPp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INSPI_Pp ];

/// INSPI_PpAmt
Property INSPIPpAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INSPI_PpAmt ];

/// INSPI_Sp
Property INSPISp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INSPI_Sp ];

/// INSPI_SpAmt
Property INSPISpAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INSPI_SpAmt ];

/// INSPI_QtyBUom
Property INSPIQtyBUom As %Library.Float(MAXVAL = 999999999999, MINVAL = 0) [ Required, SqlColumnNumber = 12, SqlFieldName = INSPI_QtyBUom ];

/// INSPI_Reason_Dr
Property INSPIReasonDr As User.DHCIncReasonForStockScrap [ SqlColumnNumber = 13, SqlFieldName = INSPI_Reason_Dr ];

/// 备注
Property INSPIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INSPI_Remarks ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INSPI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSPI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSPI_Pp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSPI_PpAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSPI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSPI_QtyBUom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSPI_Reason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSPI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSPI_Rp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSPI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSPI_Sp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSPI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCINSP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INScrap.INSCP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INSPI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_INScrap.INSCP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INSPI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInclb">
<Global>^DHCINSP</Global>
<PopulationType>nonnull</PopulationType>
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
<Expression>{INSPI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INScrap.INSCP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INSPI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINSpItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
