Class User.DHCAppPreHisTemp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPreHisTemp, StorageStrategy = SQLStorage ]
{

/// 就诊ID
Property APAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = AP_Adm_Dr ];

/// 主诉
Property APText As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AP_Text ];

/// 保存为
Property APSaveAs As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AP_SaveAs ];

/// 对应id
Property APPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AP_Pointer ];

/// 操作者
Property APOpUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = AP_OpUser ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPREHT)</SqlIdExpression>
<SQLMap name="Indexsave">
<Global>^DHCAPPREHT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SaveAs"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_SaveAs}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextext">
<Global>^DHCAPPREHT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_Text}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterIndex">
<Data name="AP_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_OpUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_SaveAs">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPREHT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPreHisTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
