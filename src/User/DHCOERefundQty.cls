Class User.DHCOERefundQty Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OERQ_RowID, SqlTableName = DHC_OERefundQty, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OERQ_Qty
Property OERQRefundQty As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = OERQ_RefundQty ];

/// OERQ_OEORI_DR
Property OERQOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = OERQ_OEORI_DR ];

/// OERQ_PayFlag
Property OERQPayFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OERQ_PayFlag ];

/// OERQ_TotalQty
Property OERQTotalQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = OERQ_TotalQty ];

/// OERQ_Status
Property OERQStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OERQ_Status ];

/// OERQ_RefUser_DR
Property OERQRefUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = OERQ_RefUser_DR ];

/// OERQ_RefDate
Property OERQRefDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = OERQ_RefDate ];

/// OERQ_RefTime
Property OERQRefTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = OERQ_RefTime ];

/// OERQ_PRTInv_DR
Property OERPRTInvDR As User.DHCINVPRT [ SqlColumnNumber = 10, SqlFieldName = OERQ_PRTInv_DR ];

/// OERQ_ActRefFlag
Property OERQActRefFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OERQ_ActRefFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOERefundQTY)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCOERefundQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OERQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RefundDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OERQ_RefDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OERQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCOERefundQTY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OERQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OERQ_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OERQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="OERQ_ActRefFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OERQ_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OERQ_PRTInv_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OERQ_PayFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OERQ_RefDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OERQ_RefTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OERQ_RefUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OERQ_RefundQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OERQ_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OERQ_TotalQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCOERefundQTY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OERQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{OERQ_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCOERefundQtyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
