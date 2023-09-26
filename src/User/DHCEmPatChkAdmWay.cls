Class User.DHCEmPatChkAdmWay Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCW_RowID, SqlTableName = DHC_EmPatChkAdmWay, StorageStrategy = SqlStorage ]
{

/// 预检表 PCW_Chk_Dr
Property PCWChkDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCW_Chk_Dr ];

/// 来诊方式 PCW_Adw_Dr
Property PCWAdwDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCW_Adw_Dr ];

Storage SqlStorage
{
<SqlIdExpression>$i(^DHCEMPCAW)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCW_Adw_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCW_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMPCAW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCW_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCEMPCAW</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCW_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkAdmWayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
