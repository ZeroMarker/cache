Class User.DHCAPPStatContrast Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = AP_RowId, SqlTableName = DHC_AppStatContrast, StorageStrategy = SQLStorage ]
{

/// AP_Status_Dr检查状态表id
Property APStatusDr As %Library.String [ SqlColumnNumber = 2, SqlFieldName = AP_Status_Dr ];

/// AP_PisCode pis状态代码
Property APPisCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = AP_PisCode ];

/// AP_PisDesc pis状态描述
Property APPisDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AP_PisDesc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPSC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPPSC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_PisCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Status_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPSC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_PisDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Status_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCAPPSC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_Status_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<BlockCount>1</BlockCount>
<Data name="AP_PisCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_PisDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPPSC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAPPStatContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
