Class User.DHCPHOweListItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHOI_ROWID, SqlTableName = DHC_PHOweListItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHOIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHOweList Parent Reference
Relationship PHOIPHOPARREF As User.DHCPHOweList [ Cardinality = parent, Inverse = ChildDHCPHOweListItm, Required, SqlFieldName = PHOI_PHO_PARREF ];

/// PHOI_OrdItm
Property PHOIOrdItm As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = PHOI_OrdItm ];

/// PHOI_Qty
Property PHOIQty As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PHOI_Qty ];

/// PHOI_Price
Property PHOIPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHOI_Price ];

/// PHOI_ChildSub
Property PHOIChildSub As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHOI_ChildSub ];

/// PHOI_ReqFlag
Property PHOIReqFlag As %Library.String [ SqlColumnNumber = 6, SqlFieldName = PHOI_ReqFlag ];

/// PHOI_Inci_Dr
Property PHOIInciDr As User.INCItm [ SqlColumnNumber = 7, SqlFieldName = PHOI_Inci_Dr ];

/// PHOI_DspSub_Dr
Property PHOIDspSubDr As User.DHCOEDispBatch [ SqlColumnNumber = 8, SqlFieldName = PHOI_DspSub_Dr ];

/// PHOI_PRT_Dr
Property PHOPrtDr As User.DHCINVPRT [ SqlColumnNumber = 9, SqlFieldName = PHOI_Prt_Dr ];

/// PHOI_RetPrt_Dr
Property PHORetPrtDr As User.DHCINVPRT [ SqlColumnNumber = 10, SqlFieldName = PHOI_RetPrt_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDspSub">
<Global>^DHCPHOWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHOweList.PHO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DspSub"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHOI_DspSub_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHOweList.PHO_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrt">
<Global>^DHCPHOWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHOweList.PHO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHOI_Prt_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHOweList.PHO_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCPHOWEI">
<Data name="PHOI_DspSub_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHOI_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHOI_OrdItm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHOI_Price">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHOI_Prt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHOI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHOI_ReqFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHOI_RetPrt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPHOW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHOweList.PHO_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHOweList.PHO_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHOI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHOweListItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
