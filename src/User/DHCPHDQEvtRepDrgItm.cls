Class User.DHCPHDQEvtRepDrgItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DQERDI_RowID, SqlTableName = DHC_PHDQEvtRepDrgItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DQERDIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHDrgQuaEvtReport Parent Reference DQERDI_DQER_Parref
Relationship DQERDIDQERParref As User.DHCPHDrgQuaEvtReport [ Cardinality = parent, Inverse = ChildDHCPHDQEVTREPDRGITM, Required, SqlFieldName = DQERDI_DQER_Parref ];

/// DQERDI_ChildSub
Property DQERDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DQERDI_ChildSub ];

/// DQERDI_OEORI_DR
Property DQERDIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DQERDI_OEORI_DR ];

/// DQERDI_PHCD_DR
Property DQERDIPHCDDR As User.PHCDrgMast [ SqlColumnNumber = 4, SqlFieldName = DQERDI_PHCD_DR ];

/// DQERDI_GoodsName
Property DQERDIGoodsName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DQERDI_GoodsName ];

/// DQERDI_Generic_DR
Property DQERDIGenericDR As User.PHCGeneric [ SqlColumnNumber = 6, SqlFieldName = DQERDI_Generic_DR ];

/// DQERDI_PhForm_DR
Property DQERDIPhFormDR As User.PHCForm [ SqlColumnNumber = 7, SqlFieldName = DQERDI_PhForm_DR ];

/// DQERDI_Manf_DR
Property DQERDIManfDR As User.PHManufacturer [ SqlColumnNumber = 8, SqlFieldName = DQERDI_Manf_DR ];

/// DQERDI_Spec
Property DQERDISpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DQERDI_Spec ];

/// DQERDI_PackType
Property DQERDIPackType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DQERDI_PackType ];

/// DQERDI_Vendor
Property DQERDIVendor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DQERDI_Vendor ];

/// DQERDI_BatNoExp
Property DQERDIBatNoExp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DQERDI_BatNoExp ];

/// DQERDI_Qty
Property DQERDIQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DQERDI_Qty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DQERDI_BatNoExp">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DQERDI_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DQERDI_GoodsName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DQERDI_Manf_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DQERDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DQERDI_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DQERDI_PackType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DQERDI_PhForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DQERDI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DQERDI_Spec">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DQERDI_Vendor">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHDQER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDrgQuaEvtReport.DQER_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DQERDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHDrgQuaEvtReport.DQER_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DQERDI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DQERDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDQEvtRepDrgItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
