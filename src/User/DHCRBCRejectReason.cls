Class User.DHCRBCRejectReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRR_RowID, SqlTableName = DHCRBC_RejectReason, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRR_Desc
Property DRRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRR_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBReject("Reason"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DRR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBReject</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Reason"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCRejectReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
