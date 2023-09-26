Class User.DHCAppRepHtmlView Extends %Persistent [ SqlRowIdName = ARHV_RowID, SqlTableName = DHC_AppRepHtmlView, StorageStrategy = SQLStorage ]
{

/// 检查申请单号 ARHV_RepNo
Property ARHVRepNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ARHV_RepNo ];

/// Html内容 ARHV_Content
Property ARHVContent As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ARHV_Content ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPRHV)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ARHV_Content">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARHV_RepNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPRHV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARHV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ARHV_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRepNo">
<Global>^DHCAPRHV</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARHV_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARHV_RepNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARHV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepHtmlViewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
