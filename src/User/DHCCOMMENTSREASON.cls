Class User.DHCCOMMENTSREASON Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHC_CommentsReason_RowID, SqlTableName = DHC_CommentsReason, StorageStrategy = SQLStorage ]
{

Property PCRCommentsReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = PCR_CommentsReason ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCCOMM)</SqlIdExpression>
<SQLMap name="DHCCommentsReasonMaster">
<Data name="PCR_CommentsReason">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCOMM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CommentsReason_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_CommentsReason_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCOMMENTSREASONS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
