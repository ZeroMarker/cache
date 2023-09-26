Class User.DHCSTPHADOCReqItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDRQI_RowId, SqlTableName = DHCST_PHADOCReqItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PDRQIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PDRQIPDRQParRef As User.DHCSTPHADOCReq [ Cardinality = parent, Inverse = ChildDHCSTPHADOCReqItm, Required, SqlFieldName = PDRQI_PDRQ_ParRef ];

/// PDRQI_Childsub
Property PDRQIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PDRQI_ChildSub ];

/// Des Ref to INCI
Property PDRQIINCIDR As INCItm [ Required, SqlColumnNumber = 3, SqlFieldName = PDRQI_INCI_DR ];

/// Des Ref to CTUOM
Property PDRQICTUOMDR As CTUOM [ SqlColumnNumber = 4, SqlFieldName = PDRQI_CTUOM_DR ];

/// Request Quantity
Property PDRQIReqQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ Required, SqlColumnNumber = 5, SqlFieldName = PDRQI_ReqQty ];

/// Request Quantity in Base Uom
Property PDRQIReqBQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ Required, SqlColumnNumber = 6, SqlFieldName = PDRQI_ReqBQty ];

/// Oeori Quantity in Base Uom
Property PDRQIOeoriQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 7, SqlFieldName = PDRQI_OeoriQty ];

/// Ought to Return Quantity in Base Uom
Property PDRQIORetQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 8, SqlFieldName = PDRQI_ORetQty ];

/// Actual Return Quantity in Base Uom
Property PDRQIARetQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = PDRQI_ARetQty ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterPDRQI">
<Data name="PDRQI_ARetQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDRQI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDRQI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDRQI_ORetQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDRQI_OeoriQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDRQI_ReqBQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDRQI_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTPDRQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCST_PHADOCReq.PDRQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PDRQI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCST_PHADOCReq.PDRQ_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PDRQI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDRQI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCSTPDRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCST_PHADOCReq.PDRQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PDRQI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDRQI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCST_PHADOCReq.PDRQ_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDRQI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDRQI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSTPHADOCReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
