Class User.DHCRBRejectApplication Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRA_RowID, SqlTableName = DHCRB_RejectApplication, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRA_OeordItm_DR
Property DRAOeordItmDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DRA_OeordItm_DR ];

/// DRA_Reason_DR
Property DRAReasonDR As User.DHCRBCRejectReason [ SqlColumnNumber = 3, SqlFieldName = DRA_Reason_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBReject("Reject"))</SqlIdExpression>
<SQLMap name="IndexOeorditem">
<Global>^DHCRBRejecti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OeordDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRA_OeordItm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRA_OeordItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRA_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBReject</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Reject"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBRejectApplicationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
