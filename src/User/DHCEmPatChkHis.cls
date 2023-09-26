Class User.DHCEmPatChkHis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCH_RowID, SqlTableName = DHC_EmPatChkHis, StorageStrategy = SQLStorage ]
{

/// 预检表 PCH_Chk_Dr
Property PCHChkDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCH_Chk_Dr ];

/// 既往史 PCH_His_Dr
Property PCHHisDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCH_His_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPCH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCH_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCH_His_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPCH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCH_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCH_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkHisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
