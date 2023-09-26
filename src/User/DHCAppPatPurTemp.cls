Class User.DHCAppPatPurTemp Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = APT_RowID, SqlTableName = DHC_AppPatPurTemp, StorageStrategy = SQLStorage ]
{

/// 就诊ID
Property APTAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = APT_Adm_Dr ];

/// 检查目的
Property APTText As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = APT_Text ];

/// 保存为
Property APTSaveAs As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = APT_SaveAs ];

/// 对应id
Property APTPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = APT_Pointer ];

/// 操作者
Property APTOpUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = APT_OpUser ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPPUR)</SqlIdExpression>
<SQLMap name="IndexSaveas">
<Global>^DHCAPPPUR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SaveAs"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APT_SaveAs}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APT_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^DHCAPPPUR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>APT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APT_Text}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APT_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="APT_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APT_OpUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APT_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APT_SaveAs">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APT_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPPUR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{APT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPatPurTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
