Class User.DHCAppPatSymTemp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AM_RowID, SqlTableName = DHC_AppPatSymTemp, StorageStrategy = SQLStorage ]
{

/// 就诊ID
Property AMAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = AM_Adm_Dr ];

/// 主诉
Property AMText As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AM_Text ];

/// 保存为
Property AMSaveAs As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AM_SaveAs ];

/// 对应id
Property AMPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AM_Pointer ];

/// 操作者
Property AMOpUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = AM_OpUser ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPATSYT)</SqlIdExpression>
<SQLMap name="Indexsave">
<Global>^DHCAPPATSYT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SaveAs"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AM_SaveAs}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AM_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextext">
<Global>^DHCAPPATSYT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$System.Encryption.SHA1Hash({AM_Text})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AM_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Masterdata">
<Data name="AM_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AM_OpUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AM_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AM_SaveAs">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AM_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPATSYT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPatSymTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
