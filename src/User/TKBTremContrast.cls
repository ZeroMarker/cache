/// Function: 医用知识库 对照 通用表
/// CreateDate: 2017-06-23
/// Creator:  谷雪萍
Class User.TKBTremContrast Extends %Persistent [ SqlRowIdName = TKBTC_RowId, SqlTableName = TKB_TremContrast, StorageStrategy = SQLStorage ]
{

//^TKBTREMCON

Property TKBTCMainDr As User.TKBTrem [ SqlColumnNumber = 2, SqlFieldName = TKBTC_Main_Dr ];

Property TKBTCConDr As User.TKBTrem [ SqlColumnNumber = 3, SqlFieldName = TKBTC_Con_Dr ];

Property TKBTCMainBaseDr As User.TKBTremBase [ SqlColumnNumber = 4, SqlFieldName = TKBTC_MainBase_Dr ];

Property TKBTCConBaseDr As User.TKBTremBase [ SqlColumnNumber = 5, SqlFieldName = TKBTC_ConBase_Dr ];

/*Property TKBTCCode As %String [ SqlColumnNumber = 6, SqlFieldName = TKBTC_Code ];

Property TKBTCDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TKBTC_Desc ];

Property TKBTCConCode As %String [ SqlColumnNumber = 8, SqlFieldName = TKBTC_ConCode ];

Property TKBTCConDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TKBTC_ConDesc ];*/
Storage SQLStorage
{
<SqlIdExpression>$i(^TKBTREMCON(0))</SqlIdExpression>
<SQLMap name="ConDrIndex">
<Global>^TKBTREMCONi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTC_Con_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ConIndex">
<Global>^TKBTREMCONi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Con"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTC_Con_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTC_MainBase_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTC_ConBase_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TKBTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MainDrIndex">
<Global>^TKBTREMCONi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MainDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTC_Main_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MainIndex">
<Global>^TKBTREMCONi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TKBTC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Main"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTC_Main_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTC_MainBase_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTC_ConBase_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TKBTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTC_ConBase_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TKBTC_Con_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTC_MainBase_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBTC_Main_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TKBTREMCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="MasterIndex">
<Global>^TKBTREMCONi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Master"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTC_MainBase_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTC_ConBase_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UniqueIndex">
<Global>^TKBTREMCONi</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>TKBTC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Unique"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTC_MainBase_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTC_ConBase_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTC_Main_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TKBTC_Con_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{TKBTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
