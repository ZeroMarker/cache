/// 排班管理-班次类型字典
Class User.PIVASchedulType Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PIVA_SchedulType, StorageStrategy = CacheSQLStorage ]
{

/// 配液中心
Property PSTLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PST_Loc_Dr ];

/// 班次类型名称
Property PSTDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PST_Desc ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^Code.PIVA.SchedulType(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PST_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^Code.PIVA.SchedulType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PST_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PST_RowId</SqlRowIdName>
<StreamLocation>^Code.PIVA.SchedulTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
