Class User.DHCPHREQITEM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHReqi_Rowid, SqlTableName = DHC_PHREQITEM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHReqiChild [ IdKey, PrimaryKey, Unique ];

/// PHReqi_Child
Property PHReqiChild As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHReqi_Child ];

/// DHC_PHREQUEST Parent Reference
Relationship PHReqiPHReqparref As User.DHCPHREQUEST [ Cardinality = parent, Inverse = ChildDHCPHREQITEM, Required, SqlFieldName = PHReqi_PHReq_parref ];

/// 发药子表
Property PHReqiPhdidr As User.DHCPHDISITEM [ SqlColumnNumber = 2, SqlFieldName = PHReqi_Phdi_dr ];

/// PHReqi_Price
Property PHReqiPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHReqi_Price ];

/// PHReqi_RefReason
Property PHReqiRefReason As User.DHCINVOPRefReason [ SqlColumnNumber = 6, SqlFieldName = PHReqi_RefReason ];

/// PHReqi_ReqQty
Property PHReqiReqQty As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PHReqi_ReqQty ];

/// PHReqi_RetQty
Property PHReqiRetQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHReqi_RetQty ];

/// PHReqi_ChowFlag
Property PHReqiChowFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHReqi_ChowFlag ];

/// 退费申请标示
Property PHReqiRefundReqMark As %Library.String [ SqlColumnNumber = 9, SqlFieldName = PHReqi_RefundReqMark ];

/// 拒绝退药标志
Property PHReqiRefuseType As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PHReqi_RefuseType ];

/// 拒绝退药原因
Property PHReqiRefuseReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHReqi_RefuseReason ];

/// 发药孙表
Property PHReqiPHDICDR As User.DHCPHDISITMCLB [ SqlColumnNumber = 12, SqlFieldName = PHReqi_PHDIC_DR ];

/// 打包子表
Property PHReqiDSPBDR As User.DHCOEDispBatch [ SqlColumnNumber = 13, SqlFieldName = PHReqi_DSPB_DR ];

/// 科室库存批次
Property PHReqiINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 14, SqlFieldName = PHReqi_INCLB_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDspBatch">
<Global>^DHCPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHREQUEST.PHReq_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHReqi_Child</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSPB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHReqi_DSPB_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHREQUEST.PHReq_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHReqi_Child}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhdSub">
<Global>^DHCPHREQi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHREQUEST.PHReq_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHReqi_Child</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHDSUB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHReqi_PHDIC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHREQUEST.PHReq_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHReqi_Child}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRefund">
<Global>^DHCPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHREQUEST.PHReq_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHReqi_Child</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Refund"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHReqi_RefundReqMark}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHREQUEST.PHReq_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHReqi_Child}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phreqimaster">
<Data name="PHReqi_ChowFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHReqi_DSPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHReqi_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHReqi_PHDIC_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHReqi_Phdi_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHReqi_Price">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHReqi_RefReason">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHReqi_RefundReqMark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHReqi_RefuseReason">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHReqi_RefuseType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHReqi_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHReqi_RetQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHREQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHREQUEST.PHReq_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHReqi_Child</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHREQUEST.PHReq_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHReqi_Child}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="phreqitmindex">
<Global>^DHCPHREQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHREQUEST.PHReq_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHReqi_Child</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHReqi_Phdi_dr}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHDI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHREQUEST.PHReq_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHReqi_Child}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHREQITEMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
